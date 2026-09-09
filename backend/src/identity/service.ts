import type pg from "pg";
import { z } from "zod";
import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { bearer, type AuthVerifier } from "./verifier.js";
import {
  deviceRegistrationSchema,
  verifiedPrincipalSchema,
  uuid,
} from "../contracts/domain.js";
import { AppError } from "../security/errors.js";
const empty = z.strictObject({});
export const identityRoutes = [
  "POST /v1/account/session",
  "POST /v1/devices/register",
  "GET /v1/account",
  "POST /v1/devices/{deviceId}/revoke",
] as const;
export function identityRoute(
  method: string,
  path: string,
): (typeof identityRoutes)[number] | null {
  const key = `${method} ${path}`;
  if (
    key === identityRoutes[0] ||
    key === identityRoutes[1] ||
    key === identityRoutes[2]
  )
    return key;
  if (method === "POST" && /^\/v1\/devices\/[0-9a-f-]{36}\/revoke$/i.test(path))
    return identityRoutes[3];
  return null;
}
export class IdentityService {
  constructor(
    private pool: pg.Pool,
    private verifier: AuthVerifier,
  ) {}
  async execute(event: APIGatewayProxyEventV2, input: unknown) {
    const route = identityRoute(
      event.requestContext.http.method,
      event.rawPath,
    );
    if (!route) throw new AppError("not_found");
    const parsed = (
      route === identityRoutes[1] ? deviceRegistrationSchema : empty
    ).safeParse(input === undefined ? {} : input);
    if (!parsed.success || event.rawQueryString)
      throw new AppError("bad_request");
    const identity = await this.verifier.verifyBearerToken(
      bearer(event.headers),
    );
    // Bootstrap requires fresh authentication, never a months-old refreshed login.
    if (
      (route === identityRoutes[0] || route === identityRoutes[1]) &&
      Date.now() / 1000 - identity.authenticatedAt > 300
    )
      throw new AppError("unauthorized");
    const client = await this.pool.connect();
    let destroy = false;
    try {
      await client.query("BEGIN");
      const accountId = String(
        (
          await client.query("SELECT public.map_identity($1,$2) AS id", [
            identity.issuer,
            identity.subject,
          ])
        ).rows[0].id,
      );
      await client.query("SELECT set_config('app.account_id',$1,true)", [
        accountId,
      ]);
      await client.query(
        "SELECT account_id FROM public.sync_state WHERE account_id=$1 FOR UPDATE",
        [accountId],
      );
      const account = (
        await client.query(
          "SELECT id,status,auth_valid_after FROM public.accounts WHERE id=$1 AND status='active' AND deleted_at IS NULL",
          [accountId],
        )
      ).rows[0];
      if (
        !account ||
        identity.authenticatedAt <= Number(account.auth_valid_after)
      )
        throw new AppError("unauthorized");
      let result: Record<string, unknown>;
      if (route === identityRoutes[0]) result = { accountId, status: "active" };
      else if (route === identityRoutes[1]) {
        const device = deviceRegistrationSchema.parse(parsed.data);
        const row = (
          await client.query(
            "SELECT public.register_owned_device($1,$2,$3,$4) AS id",
            [
              device.devicePublicId,
              device.platform,
              device.osMajor,
              device.appVersion,
            ],
          )
        ).rows[0];
        result = { accountId, deviceId: row.id };
      } else {
        const deviceId = uuid.safeParse(event.headers["x-noryva-device"]);
        if (!deviceId.success) throw new AppError("unauthorized");
        const principal = verifiedPrincipalSchema.parse({
          accountId,
          deviceId: deviceId.data,
        });
        const device = (
          await client.query(
            "SELECT id FROM public.devices WHERE account_id=$1 AND id=$2 AND revoked_at IS NULL",
            [principal.accountId, principal.deviceId],
          )
        ).rows[0];
        if (!device) throw new AppError("unauthorized");
        if (route === identityRoutes[2])
          result = {
            accountId,
            status: "active",
            deviceId: principal.deviceId,
          };
        else {
          const target = uuid.parse(event.rawPath.split("/")[3]);
          const revoked = (
            await client.query(
              "SELECT public.revoke_owned_device($1) AS revoked",
              [target],
            )
          ).rows[0].revoked;
          if (!revoked) throw new AppError("unauthorized");
          result = { status: "revoked" };
        }
      }
      await client.query("COMMIT");
      return result;
    } catch (e) {
      try {
        await client.query("ROLLBACK");
      } catch {
        destroy = true;
      }
      if (e instanceof AppError) throw e;
      // No PostgreSQL messages or Zod inputs leave the identity boundary.
      throw new AppError("unauthorized");
    } finally {
      try {
        await client.query("RESET app.account_id");
      } catch {
        destroy = true;
      }
      client.release(destroy);
    }
  }
}
