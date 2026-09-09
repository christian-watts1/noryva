import { test } from "node:test";
import assert from "node:assert/strict";
import {
  Database,
  poolOptions,
  type QueryExecutor,
} from "../src/database/client.js";
import { readConfig } from "../src/config/environment.js";
import { migrate } from "../src/database/migrations.js";

test("database forwards parameters separately from SQL", async () => {
  const calls: unknown[] = [];
  const db = new Database({
    query: async (text, values) => {
      calls.push([text, values]);
      return { rows: [{ ok: 1 }] };
    },
  });
  const input = "'; DROP TABLE users; --";
  await db.query("SELECT $1 AS value", [input]);
  assert.deepEqual(calls, [["SELECT $1 AS value", [input]]]);
  assert.equal(await db.ready(), true);
});
test("readiness fails closed on DB failure or unexpected result without logging error", async () => {
  assert.equal(
    await new Database({
      query: async () => {
        throw Error("postgres://secret");
      },
    }).ready(),
    false,
  );
  assert.equal(
    await new Database({ query: async () => ({ rows: [] }) }).ready(),
    false,
  );
});
test("local pool is bounded, timed out and only available for explicit loopback development", () => {
  const value = poolOptions(
    readConfig({
      APP_ENV: "test",
      DB_MODE: "local",
      DB_HOST: "127.0.0.1",
      DB_NAME: "noryva",
      DB_USER: "test",
      DB_PASSWORD: "local-placeholder",
    }),
  );
  assert.equal(value.max, 1);
  assert.equal(value.connectionTimeoutMillis, 2000);
  assert.equal(value.statement_timeout, 2500);
  assert.equal(value.ssl, false);
  assert.throws(() => poolOptions(readConfig({ APP_ENV: "test" })));
});
function fake(
  fail = false,
  applied: Record<string, unknown>[] = [],
): { client: QueryExecutor; calls: string[] } {
  const calls: string[] = [];
  return {
    calls,
    client: {
      query: async (text) => {
        calls.push(text);
        if (fail && text === "SELECT migration")
          throw Error("sensitive database failure");
        return { rows: text.startsWith("SELECT name") ? applied : [] };
      },
    },
  };
}
test("migrations lock one connection and transact before recording checksum", async () => {
  const { client, calls } = fake();
  await migrate(client, [{ name: "0001_test.sql", sql: "SELECT migration" }]);
  assert.equal(calls[0], "SELECT pg_advisory_lock(78234119)");
  assert.ok(calls.indexOf("BEGIN") < calls.indexOf("SELECT migration"));
  assert.ok(
    calls.indexOf("COMMIT") >
      calls.findIndex((x) => x.startsWith("INSERT INTO")),
  );
  assert.equal(calls.at(-1), "SELECT pg_advisory_unlock(78234119)");
});
test("failed migration rolls back and releases lock", async () => {
  const { client, calls } = fake(true);
  await assert.rejects(
    migrate(client, [{ name: "0001_test.sql", sql: "SELECT migration" }]),
  );
  assert.ok(calls.includes("ROLLBACK"));
  assert.ok(!calls.includes("COMMIT"));
  assert.equal(calls.at(-1), "SELECT pg_advisory_unlock(78234119)");
});
test("modified or missing migration history prevents further DDL", async () => {
  const { client, calls } = fake(false, [
    { name: "0001_test.sql", sha256: "wrong" },
  ]);
  await assert.rejects(
    migrate(client, [{ name: "0001_test.sql", sql: "SELECT migration" }]),
    /history mismatch/,
  );
  assert.ok(!calls.includes("BEGIN"));
});
