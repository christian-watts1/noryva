import { readFileSync } from "node:fs";
import pg from "pg";
import { Signer } from "@aws-sdk/rds-signer";
import type { Config } from "../config/environment.js";

export interface QueryExecutor {
  query(
    text: string,
    values?: unknown[],
  ): Promise<{ rows: Record<string, unknown>[] }>;
}
export class Database {
  constructor(private readonly executor: QueryExecutor) {}
  async query(
    text: string,
    values: unknown[] = [],
  ): Promise<Record<string, unknown>[]> {
    return (await this.executor.query(text, values)).rows;
  }
  async ready(): Promise<boolean> {
    try {
      const rows = await this.query("SELECT 1 AS ok");
      return rows[0]?.ok === 1;
    } catch {
      return false;
    }
  }
}
export function poolOptions(config: Config): pg.PoolConfig {
  if (config.DB_MODE === "disabled") throw new Error("Database disabled");
  const signer =
    config.DB_MODE === "iam"
      ? new Signer({
          region: config.AWS_REGION!,
          hostname: config.DB_HOST!,
          port: config.DB_PORT,
          username: config.DB_USER!,
        })
      : undefined;
  return {
    host: config.DB_HOST!,
    port: config.DB_PORT,
    database: config.DB_NAME!,
    user: config.DB_USER!,
    password: signer ? () => signer.getAuthToken() : config.DB_PASSWORD!,
    ssl:
      config.DB_MODE === "iam"
        ? {
            rejectUnauthorized: true,
            ca: readFileSync(config.DB_CA_FILE!, "utf8"),
          }
        : false,
    max: 1,
    connectionTimeoutMillis: 2000,
    idleTimeoutMillis: 10000,
    maxLifetimeSeconds: 300,
    query_timeout: 3000,
    statement_timeout: 2500,
    application_name: "noryva-api",
  };
}
export function createPool(config: Config): pg.Pool {
  const pool = new pg.Pool(poolOptions(config));
  // pg emits idle socket errors; do not let an unhandled event crash or log credentials.
  pool.on("error", () => {});
  return pool;
}
