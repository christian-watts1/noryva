import { createHash } from "node:crypto";
import type { QueryExecutor } from "./client.js";
export interface Migration {
  name: string;
  sql: string;
}
export async function migrate(
  client: QueryExecutor,
  migrations: Migration[],
): Promise<void> {
  // Caller supplies one dedicated connection, never a pool (transaction/lock affinity).
  await client.query("SELECT pg_advisory_lock(78234119)");
  try {
    await client.query(
      "CREATE TABLE IF NOT EXISTS public.schema_migrations (name text PRIMARY KEY, sha256 text NOT NULL, applied_at timestamptz NOT NULL DEFAULT now())",
    );
    const applied = (
      await client.query(
        "SELECT name, sha256 FROM public.schema_migrations ORDER BY name",
      )
    ).rows;
    const expected = new Map(
      migrations.map((m) => [
        m.name,
        createHash("sha256").update(m.sql).digest("hex"),
      ]),
    );
    if (
      expected.size !== migrations.length ||
      migrations.some((m) => !/^\d{4}_[a-z0-9_]+\.sql$/.test(m.name))
    )
      throw new Error("Invalid migration set");
    for (const row of applied)
      if (expected.get(String(row.name)) !== row.sha256)
        throw new Error("Migration history mismatch");
    for (const migration of [...migrations].sort((a, b) =>
      a.name.localeCompare(b.name),
    )) {
      if (applied.some((row) => row.name === migration.name)) continue;
      await client.query("BEGIN");
      try {
        await client.query(migration.sql);
        await client.query(
          "INSERT INTO public.schema_migrations (name, sha256) VALUES ($1, $2)",
          [migration.name, expected.get(migration.name)],
        );
        await client.query("COMMIT");
      } catch (error) {
        await client.query("ROLLBACK");
        throw error;
      }
    }
  } finally {
    await client.query("SELECT pg_advisory_unlock(78234119)");
  }
}
