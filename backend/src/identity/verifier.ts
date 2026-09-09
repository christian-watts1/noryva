import { createHash } from "node:crypto";
import { createRemoteJWKSet, jwtVerify, type JWTVerifyGetKey } from "jose";
import { z } from "zod";
import { AppError } from "../security/errors.js";
export const identitySchema = z
  .strictObject({
    issuer: z.string().url().max(500),
    subject: z.string().min(1).max(200),
    clientId: z.string().min(1).max(200),
    issuedAt: z.number().int().positive(),
    expiresAt: z.number().int().positive(),
    authenticatedAt: z.number().int().positive(),
  })
  .brand<"VerifiedIdentity">();
export type VerifiedIdentity = z.infer<typeof identitySchema>;
export interface AuthVerifier {
  verifyBearerToken(token: string): Promise<VerifiedIdentity>;
}
export function bearer(headers: Record<string, string | undefined>): string {
  const value = headers.authorization ?? headers.Authorization;
  if (!value || !/^Bearer [A-Za-z0-9_.-]{1,8192}$/.test(value))
    throw new AppError("unauthorized");
  return value.slice(7);
}
export class CognitoVerifier implements AuthVerifier {
  private keys: JWTVerifyGetKey;
  constructor(
    private issuer: string,
    private clientId: string,
    keys?: JWTVerifyGetKey,
  ) {
    if (
      !/^https:\/\/cognito-idp\.eu-west-2\.amazonaws\.com\/eu-west-2_[A-Za-z0-9]+$/.test(
        issuer,
      )
    )
      throw Error("Invalid issuer configuration");
    this.keys =
      keys ??
      createRemoteJWKSet(new URL(`${issuer}/.well-known/jwks.json`), {
        timeoutDuration: 3000,
        cooldownDuration: 30000,
        cacheMaxAge: 3600000,
      });
  }
  async verifyBearerToken(token: string): Promise<VerifiedIdentity> {
    try {
      if (token.length > 8192) throw Error();
      const { payload } = await jwtVerify(token, this.keys, {
        issuer: this.issuer,
        algorithms: ["RS256"],
        requiredClaims: [
          "sub",
          "exp",
          "iat",
          "auth_time",
          "client_id",
          "token_use",
        ],
      });
      const now = Math.floor(Date.now() / 1000);
      if (
        payload.token_use !== "access" ||
        payload.client_id !== this.clientId ||
        (payload.aud !== undefined && payload.aud !== this.clientId)
      )
        throw Error();
      const result = identitySchema.parse({
        issuer: payload.iss,
        subject: payload.sub,
        clientId: payload.client_id,
        issuedAt: payload.iat,
        expiresAt: payload.exp,
        authenticatedAt: payload.auth_time,
      });
      if (
        result.issuedAt > now ||
        result.authenticatedAt > result.issuedAt ||
        result.expiresAt <= result.issuedAt
      )
        throw Error();
      return result;
    } catch {
      throw new AppError("unauthorized");
    }
  }
}
// Only for API Gateway Lambda-authorizer context, never request headers/body.
// The API invocation permission is restricted to the configured gateway routes.
export class GatewayVerifier implements AuthVerifier {
  constructor(
    private context: Record<string, unknown>,
    private issuer: string,
    private clientId: string,
  ) {}
  async verifyBearerToken(token: string): Promise<VerifiedIdentity> {
    try {
      if (
        this.context.tokenHash !==
        createHash("sha256").update(token).digest("hex")
      )
        throw Error();
      const identity = identitySchema.parse(
        JSON.parse(String(this.context.identity)),
      );
      if (
        identity.issuer !== this.issuer ||
        identity.clientId !== this.clientId ||
        identity.expiresAt <= Date.now() / 1000
      )
        throw Error();
      return identity;
    } catch {
      throw new AppError("unauthorized");
    }
  }
}
