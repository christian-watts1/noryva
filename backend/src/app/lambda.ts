import type { APIGatewayProxyEventV2, Context } from "aws-lambda";
import { readConfig, type Config } from "../config/environment.js";
import { createPool, Database } from "../database/client.js";
import { createHandler } from "./handler.js";
let config: Config | undefined;
let database: Database | undefined;
const getConfig = () => (config ??= readConfig(process.env));
const application = createHandler({
  config: getConfig,
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
