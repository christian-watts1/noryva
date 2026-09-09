import { IdentityService } from "../identity/service.js";
import { GatewayVerifier } from "../identity/verifier.js";
import { AppError } from "../security/errors.js";
import type { APIGatewayProxyEventV2WithLambdaAuthorizer } from "aws-lambda";
import type pg from "pg";
import type { APIGatewayProxyEventV2, Context } from "aws-lambda";
import { readConfig, type Config } from "../config/environment.js";
import { createPool, Database } from "../database/client.js";
import { createHandler } from "./handler.js";
let config: Config | undefined;
let database: Database | undefined;
let identityPool: pg.Pool | undefined;
const getConfig = () => (config ??= readConfig(process.env));
const application = createHandler({
  config: getConfig,
  identity: async (event, input) => {
    const config = getConfig();
    if (
      config.DB_MODE === "disabled" ||
      !process.env.AUTH_ISSUER ||
      !process.env.AUTH_CLIENT_ID
    )
      throw new AppError("unavailable");
    identityPool ??= createPool(config);
    const context =
      (
        event as APIGatewayProxyEventV2WithLambdaAuthorizer<
          Record<string, unknown>
        >
      ).requestContext.authorizer?.lambda ?? {};
    return new IdentityService(
      identityPool,
      new GatewayVerifier(
        context,
        process.env.AUTH_ISSUER,
        process.env.AUTH_CLIENT_ID,
      ),
    ).execute(event, input);
  },
  ready: async () => {
    const value = getConfig();
    if (value.DB_MODE === "disabled") return false;
    database ??= new Database(createPool(value));
    return database.ready();
  },
});
export async function handler(event: APIGatewayProxyEventV2, context: Context) {
  context.callbackWaitsForEmptyEventLoop = false;
  return application(event);
}
