import { readdir, readFile } from "node:fs/promises";
import { readConfig } from "../config/environment.js";
import { createPool } from "./client.js";
import { migrate } from "./migrations.js";
// CLI only: never bundled into or called by API Lambda.
async function main() {
  const config = readConfig(process.env);
  const pool = createPool(config);
  try {
    const client = await pool.connect();
    try {
      const directory = new URL("../../migrations/", import.meta.url);
      const names = (await readdir(directory))
        .filter((name) => name.endsWith(".sql"))
        .sort();
      await migrate(
        client,
        await Promise.all(
          names.map(async (name) => ({
            name,
            sql: await readFile(new URL(name, directory), "utf8"),
          })),
        ),
      );
    } finally {
      client.release();
    }
  } finally {
    await pool.end();
  }
}
main().catch(() => {
  console.error('{"severity":"error","category":"migration_failed"}');
  process.exitCode = 1;
});
