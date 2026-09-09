import { before, after, test } from "node:test";
import assert from "node:assert/strict";
import { randomUUID, createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import pg from "pg";
import { migrate } from "../../src/database/migrations.js";
import { withAccountTransaction } from "../../src/database/account-transaction.js";
import {
  verifiedPrincipalSchema,
  type VerifiedPrincipal,
} from "../../src/contracts/domain.js";
import {
  enqueueJob,
  claimJob,
  finishJob,
  recoverExpiredJobs,
} from "../../src/modules/jobs.js";
// This harness deliberately permits only a loopback disposable test database.
const port = Number(process.env.PG_TEST_PORT);
if (
  !Number.isInteger(port) ||
  port < 1 ||
  port > 65535 ||
  !process.env.PG_TEST_PASSWORD
)
  throw Error("Use npm run test:integration");
const config = {
  host: "127.0.0.1",
  port,
  database: "noryva_test",
  password: process.env.PG_TEST_PASSWORD,
  connectionTimeoutMillis: 5000,
};
const admin = new pg.Pool({ ...config, user: "postgres", max: 1 });
const owner = new pg.Pool({ ...config, user: "noryva_migrator", max: 1 });
const app = new pg.Pool({ ...config, user: "noryva_api", max: 1 });
const migration = {
  name: "0001_core_identity_and_sync.sql",
  sql: await readFile(
    new URL(
      "../../migrations/0001_core_identity_and_sync.sql",
      import.meta.url,
    ),
    "utf8",
  ),
};
before(async () => {
  assert.match(
    (await admin.query("SHOW server_version")).rows[0].server_version,
    /^17\./,
  );
  // Bootstrap only. Tests below connect using actual distinct login roles.
  await admin.query(`CREATE ROLE noryva_migrator LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS PASSWORD 'noryva-disposable-only';
    CREATE ROLE noryva_api LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS PASSWORD 'noryva-disposable-only';
    REVOKE ALL ON DATABASE noryva_test FROM PUBLIC;
    GRANT CONNECT ON DATABASE noryva_test TO noryva_migrator, noryva_api;
    REVOKE ALL ON SCHEMA public FROM PUBLIC;
    ALTER SCHEMA public OWNER TO noryva_migrator;
    GRANT USAGE ON SCHEMA public TO noryva_api;`);
  const c = await owner.connect();
  try {
    await migrate(c, [migration]);
  } finally {
    c.release();
  }
});
after(async () => {
  await Promise.all([app.end(), owner.end(), admin.end()]);
});
async function fixture() {
  const a = verifiedPrincipalSchema.parse({
    accountId: randomUUID(),
    deviceId: randomUUID(),
  });
  const profile = randomUUID(),
    diary = randomUUID();
  const c = await owner.connect();
  try {
    await c.query("BEGIN");
    await c.query("SELECT set_config('app.account_id',$1,true)", [a.accountId]);
    await c.query(
      "INSERT INTO accounts(id,provider_issuer,provider_subject) VALUES ($1,'synthetic-issuer',$2)",
      [a.accountId, randomUUID()],
    );
    await c.query(
      "INSERT INTO devices(id,account_id,device_public_id,platform,os_major,app_version) VALUES ($1,$2,$3,'android',16,'1.0.0')",
      [a.deviceId, a.accountId, randomUUID()],
    );
    await c.query("INSERT INTO sync_state(account_id) VALUES ($1)", [
      a.accountId,
    ]);
    await c.query(
      `INSERT INTO fitness_profiles(id,account_id,calculation_sex,height_cm,weight_kg,activity,goal,bmr,maintenance_calories,daily_calories,goal_adjustment,protein_g,carbohydrate_g,fat_g,was_clamped,algorithm_version,height_unit,weight_unit)
      VALUES ($1,$2,'female',170,70,'low','maintainWeight',1400,1680,1680,0,112,180,56,false,'mifflin-st-jeor-v1','cm','kg')`,
      [profile, a.accountId],
    );
    await c.query(
      `INSERT INTO diary_entries(id,account_id,device_id,meal,logged_at,quantity,serving_description,basis_unit,food_name,calories,protein_g,carbohydrate_g,fat_g,fibre_g,sugar_g,salt_g)
      VALUES ($1,$2,$3,'lunch',now(),100,'100 g','g','Synthetic oats',100,3,15,4,2,1,0.1)`,
      [diary, a.accountId, a.deviceId],
    );
    await c.query("COMMIT");
  } catch (e) {
    await c.query("ROLLBACK");
    throw e;
  } finally {
    c.release();
  }
  return { principal: a, profile, diary };
}
const scoped = <T>(
  p: VerifiedPrincipal,
  cb: Parameters<typeof withAccountTransaction<T>>[2],
) => withAccountTransaction(app, p, cb);
const dbError = (code: string) => (e: unknown) =>
  e instanceof Error && "code" in e && e.code === code;

test("fresh migration, repeated execution and SHA256 ledger", async () => {
  const c = await owner.connect();
  try {
    await migrate(c, [migration]);
    await migrate(c, [migration]);
    const ledger = await c.query("SELECT name,sha256 FROM schema_migrations");
    assert.deepEqual(ledger.rows, [
      {
        name: migration.name,
        sha256: createHash("sha256").update(migration.sql).digest("hex"),
      },
    ]);
    await assert.rejects(
      migrate(c, [{ ...migration, sql: migration.sql + "\n-- changed" }]),
      /history mismatch/,
    );
    await assert.rejects(migrate(c, []), /history mismatch/);
  } finally {
    c.release();
  }
});
test("failed migration rolls back DDL and ledger, then releases migration lock", async () => {
  const c = await owner.connect();
  try {
    await assert.rejects(
      migrate(c, [
        migration,
        {
          name: "0002_failure.sql",
          sql: "CREATE TABLE public.rollback_probe(id integer); SELECT 1/0;",
        },
      ]),
      dbError("22012"),
    );
    assert.equal(
      (await c.query("SELECT to_regclass('public.rollback_probe') AS t"))
        .rows[0].t,
      null,
    );
    assert.equal(
      (await c.query("SELECT count(*)::int AS n FROM schema_migrations"))
        .rows[0].n,
      1,
    );
    assert.equal(
      (
        await c.query(
          "SELECT count(*)::int AS n FROM pg_locks WHERE pid=pg_backend_pid() AND locktype='advisory'",
        )
      ).rows[0].n,
      0,
    );
  } finally {
    c.release();
  }
});
test("real app role has no ownership, bypass, DDL, ledger, role or truncate privileges", async () => {
  const role = (
    await app.query(
      "SELECT rolsuper,rolbypassrls,rolcreatedb,rolcreaterole FROM pg_roles WHERE rolname=current_user",
    )
  ).rows[0];
  assert.deepEqual(role, {
    rolsuper: false,
    rolbypassrls: false,
    rolcreatedb: false,
    rolcreaterole: false,
  });
  const tables = (
    await app.query(
      "SELECT relname,relrowsecurity,relforcerowsecurity,pg_get_userbyid(relowner) AS owner FROM pg_class WHERE relnamespace='public'::regnamespace AND relkind='r' AND relname<>'schema_migrations' ORDER BY relname",
    )
  ).rows;
  assert.equal(tables.length, 6);
  for (const t of tables) {
    assert.equal(t.owner, "noryva_migrator");
    assert.equal(t.relrowsecurity, true);
    assert.equal(t.relforcerowsecurity, true);
  }
  assert.equal(
    (
      await app.query(
        "SELECT count(*)::int AS n FROM pg_policies WHERE schemaname='public'",
      )
    ).rows[0].n,
    6,
  );
  for (const sql of [
    "ALTER TABLE fitness_profiles DISABLE ROW LEVEL SECURITY",
    "ALTER TABLE diary_entries NO FORCE ROW LEVEL SECURITY",
    "DROP POLICY account_owner ON jobs",
    "CREATE TABLE public.forbidden(id int)",
    "CREATE TEMP TABLE forbidden(id int)",
    "TRUNCATE diary_entries",
    "SELECT * FROM schema_migrations",
    "SET ROLE noryva_migrator",
    "ALTER ROLE noryva_api BYPASSRLS",
  ])
    await assert.rejects(app.query(sql), dbError("42501"));
});
test("two real accounts: reciprocal SELECT/UPDATE/DELETE and crafted IDs are isolated", async () => {
  const a = await fixture(),
    b = await fixture();
  for (const [own, other] of [
    [a, b],
    [b, a],
  ] as const) {
    await scoped(own.principal, async (c) => {
      for (const [table, id] of [
        ["fitness_profiles", other.profile],
        ["diary_entries", other.diary],
      ]) {
        assert.equal(
          (await c.query(`SELECT * FROM ${table} WHERE id=$1`, [id])).rows
            .length,
          0,
        );
        assert.equal(
          (
            await c.query(
              `UPDATE ${table} SET version=version+1 WHERE id=$1 RETURNING id`,
              [id],
            )
          ).rows.length,
          0,
        );
        assert.equal(
          (
            await c.query(
              `DELETE FROM ${table} WHERE account_id=$1 RETURNING id`,
              [other.principal.accountId],
            )
          ).rows.length,
          0,
        );
        assert.equal(
          (
            await c.query(`SELECT * FROM ${table} WHERE id::text=$1`, [
              "' OR TRUE --",
            ])
          ).rows.length,
          0,
        );
        assert.equal((await c.query(`SELECT * FROM ${table}`)).rows.length, 1);
      }
    });
    await assert.rejects(
      scoped(own.principal, (c) =>
        c.query(
          "INSERT INTO fitness_profiles(id,account_id,deleted_at) VALUES ($1,$2,now())",
          [randomUUID(), other.principal.accountId],
        ),
      ),
      dbError("42501"),
    );
    await assert.rejects(
      scoped(own.principal, (c) =>
        c.query(
          "INSERT INTO diary_entries(id,account_id,device_id,deleted_at) VALUES ($1,$2,$3,now())",
          [randomUUID(), other.principal.accountId, other.principal.deviceId],
        ),
      ),
      dbError("42501"),
    );
    await assert.rejects(
      scoped(own.principal, (c) =>
        c.query(
          "INSERT INTO diary_entries(id,account_id,device_id,deleted_at) VALUES ($1,$2,$3,now())",
          [randomUUID(), own.principal.accountId, other.principal.deviceId],
        ),
      ),
      dbError("23503"),
    );
  }
});
test("missing and malformed DB account context fail closed; row_security off cannot bypass", async () => {
  await fixture();
  assert.equal(
    (await app.query("SELECT * FROM fitness_profiles")).rows.length,
    0,
  );
  await assert.rejects(
    app.query(
      "INSERT INTO fitness_profiles(id,account_id,deleted_at) VALUES ($1,$2,now())",
      [randomUUID(), randomUUID()],
    ),
    dbError("42501"),
  );
  const c = await app.connect();
  try {
    await c.query("BEGIN");
    await c.query("SELECT set_config('app.account_id',$1,true)", [
      "not-a-uuid' OR TRUE --",
    ]);
    await assert.rejects(
      c.query("SELECT * FROM diary_entries"),
      dbError("22P02"),
    );
    await c.query("ROLLBACK");
    await c.query("BEGIN");
    await c.query("SET LOCAL row_security=off");
    await assert.rejects(
      c.query("SELECT * FROM fitness_profiles"),
      dbError("42501"),
    );
    await c.query("ROLLBACK");
  } finally {
    c.release();
  }
});
test("snapshot versions, tombstone payload erasure and no resurrection", async () => {
  const a = await fixture();
  await assert.rejects(
    scoped(a.principal, (c) =>
      c.query("UPDATE diary_entries SET calories=200 WHERE id=$1", [a.diary]),
    ),
    dbError("23514"),
  );
  await scoped(a.principal, async (c) => {
    await c.query(
      "UPDATE diary_entries SET calories=200,version=version+1 WHERE id=$1",
      [a.diary],
    );
    await c.query(
      "UPDATE diary_entries SET deleted_at=now(),version=version+1 WHERE id=$1",
      [a.diary],
    );
    await c.query(
      "UPDATE fitness_profiles SET deleted_at=now(),version=version+1 WHERE id=$1",
      [a.profile],
    );
    const row = (
      await c.query(
        "SELECT food_name,calories,deleted_at FROM diary_entries WHERE id=$1",
        [a.diary],
      )
    ).rows[0]!;
    assert.equal(row.food_name, null);
    assert.equal(row.calories, null);
    assert.ok(row.deleted_at);
    assert.equal(
      (await c.query("SELECT bmr FROM fitness_profiles")).rows[0]!.bmr,
      null,
    );
  });
  await assert.rejects(
    scoped(a.principal, (c) =>
      c.query(
        "UPDATE diary_entries SET deleted_at=NULL,version=version+1 WHERE id=$1",
        [a.diary],
      ),
    ),
    dbError("23514"),
  );
});
test("same pooled connection loses context after commit, rollback and session contamination", async () => {
  const a = await fixture(),
    b = await fixture();
  const pid = (await app.query("SELECT pg_backend_pid() AS pid")).rows[0].pid;
  await scoped(a.principal, async (c) => {
    assert.equal(
      (await c.query("SELECT pg_backend_pid() AS pid")).rows[0]!.pid,
      pid,
    );
    assert.equal(
      (await c.query("SELECT account_id FROM fitness_profiles")).rows[0]!
        .account_id,
      a.principal.accountId,
    );
  });
  assert.equal(
    (await app.query("SELECT * FROM fitness_profiles")).rows.length,
    0,
  );
  await assert.rejects(
    scoped(a.principal, async (c) => {
      await c.query("SELECT set_config('app.account_id',$1,false)", [
        a.principal.accountId,
      ]);
      throw Error("synthetic failure");
    }),
  );
  assert.equal(
    (await app.query("SELECT * FROM fitness_profiles")).rows.length,
    0,
  );
  await scoped(a.principal, (c) =>
    c.query("SELECT set_config('app.account_id',$1,false)", [
      a.principal.accountId,
    ]),
  );
  assert.equal(
    (await app.query("SELECT * FROM fitness_profiles")).rows.length,
    0,
  );
  await scoped(b.principal, async (c) =>
    assert.equal(
      (await c.query("SELECT account_id FROM diary_entries")).rows[0]!
        .account_id,
      b.principal.accountId,
    ),
  );
  await assert.rejects(
    scoped(
      {
        ...a.principal,
        accountId: "x'; SET ROLE noryva_migrator; --",
      } as VerifiedPrincipal,
      async () => {},
    ),
  );
  await assert.rejects(
    scoped({ ...a.principal, deviceId: b.principal.deviceId }, async () => {}),
    /unavailable/,
  );
});
test("SQL injection stays a literal parameter and logs remain outside database helper", async () => {
  const a = await fixture();
  const value = "'; DROP TABLE accounts; --";
  await scoped(a.principal, async (c) => {
    await c.query(
      "UPDATE diary_entries SET food_name=$1,version=version+1 WHERE id=$2",
      [value, a.diary],
    );
    assert.equal(
      (
        await c.query("SELECT food_name FROM diary_entries WHERE id=$1", [
          a.diary,
        ])
      ).rows[0]!.food_name,
      value,
    );
    assert.equal((await c.query("SELECT * FROM accounts")).rows.length, 1);
  });
});
test("DB constraints reject invalid versions, numerics and job enums", async () => {
  const a = await fixture();
  for (const sql of [
    "UPDATE sync_state SET epoch=0",
    "UPDATE sync_state SET retention_floor=revision+1",
    "UPDATE fitness_profiles SET version=0",
    "UPDATE fitness_profiles SET height_cm='NaN',version=version+1",
  ])
    await assert.rejects(
      scoped(a.principal, (c) => c.query(sql)),
      dbError("23514"),
    );
  for (const type of ["analytics", "invalid"])
    await assert.rejects(
      scoped(a.principal, (c) =>
        c.query("INSERT INTO jobs(id,account_id,job_type) VALUES ($1,$2,$3)", [
          randomUUID(),
          a.principal.accountId,
          type,
        ]),
      ),
      dbError("23514"),
    );
  await assert.rejects(
    scoped(a.principal, (c) =>
      c.query(
        "INSERT INTO jobs(id,account_id,job_type,status) VALUES ($1,$2,'export','unknown')",
        [randomUUID(), a.principal.accountId],
      ),
    ),
    dbError("23514"),
  );
});
test("job ownership, single claim, retry schedule, terminal failure and completion", async () => {
  const a = await fixture(),
    b = await fixture(),
    worker = randomUUID();
  const j = await scoped(a.principal, (c) =>
    enqueueJob(c, { jobType: "export" }, 2),
  );
  assert.equal(await scoped(b.principal, (c) => claimJob(c, worker)), null);
  await assert.rejects(
    scoped(b.principal, (c) =>
      c.query(
        "INSERT INTO jobs(id,account_id,job_type) VALUES ($1,$2,'export')",
        [randomUUID(), a.principal.accountId],
      ),
    ),
    dbError("42501"),
  );
  const first = await scoped(a.principal, (c) => claimJob(c, worker));
  assert.equal(first!.id, j.id);
  assert.equal(await scoped(a.principal, (c) => claimJob(c, worker)), null);
  assert.equal(
    await scoped(a.principal, (c) =>
      finishJob(c, String(j.id), randomUUID(), 1),
    ),
    null,
  );
  assert.equal(
    (await scoped(a.principal, (c) =>
      finishJob(c, String(j.id), worker, 1, {
        code: "transient_failure",
        delaySeconds: 60,
      }),
    ))!.status,
    "pending",
  );
  assert.equal(await scoped(a.principal, (c) => claimJob(c, worker)), null);
  await scoped(a.principal, (c) =>
    c.query(
      "UPDATE jobs SET available_at=now()-interval '1 second' WHERE id=$1",
      [j.id],
    ),
  );
  assert.equal(
    (await scoped(a.principal, (c) => claimJob(c, worker)))!.attempts,
    2,
  );
  assert.equal(
    await scoped(a.principal, (c) => finishJob(c, String(j.id), worker, 1)),
    null,
  );
  assert.equal(
    (await scoped(a.principal, (c) =>
      finishJob(c, String(j.id), worker, 2, {
        code: "transient_failure",
        delaySeconds: 60,
      }),
    ))!.status,
    "failed",
  );
  const k = await scoped(a.principal, (c) =>
    enqueueJob(c, { jobType: "cloud_delete" }),
  );
  await scoped(a.principal, (c) => claimJob(c, worker));
  assert.equal(
    (await scoped(a.principal, (c) => finishJob(c, String(k.id), worker, 1)))!
      .status,
    "succeeded",
  );
  assert.equal(
    await scoped(a.principal, (c) => finishJob(c, String(k.id), worker, 1)),
    null,
  );
});
test("concurrent real worker connections SKIP LOCKED rather than claiming the same job", async () => {
  const a = await fixture();
  await scoped(a.principal, async (c) => {
    await enqueueJob(c, { jobType: "export" });
    await enqueueJob(c, { jobType: "export" });
  });
  const workers = new pg.Pool({ ...config, user: "noryva_api", max: 2 });
  const c1 = await workers.connect(),
    c2 = await workers.connect();
  try {
    for (const c of [c1, c2]) {
      await c.query("BEGIN");
      await c.query("SELECT set_config('app.account_id',$1,true)", [
        a.principal.accountId,
      ]);
      await c.query("SET LOCAL statement_timeout='2s'");
    }
    const first = await claimJob(c1, randomUUID());
    // First claim remains uncommitted and locked when the second executes.
    const second = await claimJob(c2, randomUUID());
    assert.ok(first);
    assert.ok(second);
    assert.notEqual(first.id, second.id);
    assert.equal(await claimJob(c2, randomUUID()), null);
    await c1.query("COMMIT");
    await c2.query("COMMIT");
  } finally {
    await c1.query("ROLLBACK");
    await c2.query("ROLLBACK");
    c1.release();
    c2.release();
    await workers.end();
  }
});
test("crashed worker lease recovery fences stale completion", async () => {
  const a = await fixture(),
    worker = randomUUID();
  const j = await scoped(a.principal, (c) =>
    enqueueJob(c, { jobType: "export" }, 2),
  );
  await scoped(a.principal, (c) => claimJob(c, worker));
  await scoped(a.principal, (c) =>
    c.query(
      "UPDATE jobs SET locked_at=now()-interval '10 minutes' WHERE id=$1",
      [j.id],
    ),
  );
  await scoped(a.principal, (c) => recoverExpiredJobs(c));
  await scoped(a.principal, (c) => claimJob(c, worker));
  assert.equal(
    await scoped(a.principal, (c) => finishJob(c, String(j.id), worker, 1)),
    null,
  );
  await scoped(a.principal, (c) =>
    c.query(
      "UPDATE jobs SET locked_at=now()-interval '10 minutes' WHERE id=$1",
      [j.id],
    ),
  );
  await scoped(a.principal, (c) => recoverExpiredJobs(c));
  await scoped(a.principal, async (c) =>
    assert.equal(
      (await c.query("SELECT status FROM jobs WHERE id=$1", [j.id])).rows[0]!
        .status,
      "failed",
    ),
  );
});

test("FORCE applies to migration-owner DML and revoked/inactive principals fail closed", async () => {
  const a = await fixture();
  assert.equal(
    (await owner.query("SELECT * FROM fitness_profiles")).rows.length,
    0,
  );
  await scoped(a.principal, (c) =>
    c.query("UPDATE devices SET revoked_at=now() WHERE id=$1", [
      a.principal.deviceId,
    ]),
  );
  await assert.rejects(
    scoped(a.principal, async () => {}),
    /unavailable/,
  );
  const b = await fixture();
  const c = await owner.connect();
  try {
    await c.query("BEGIN");
    await c.query("SELECT set_config('app.account_id',$1,true)", [
      b.principal.accountId,
    ]);
    await c.query("UPDATE accounts SET status='deleting' WHERE id=$1", [
      b.principal.accountId,
    ]);
    await c.query("COMMIT");
  } finally {
    c.release();
  }
  await assert.rejects(
    scoped(b.principal, async () => {}),
    /unavailable/,
  );
  assert.equal((await app.query("SELECT * FROM diary_entries")).rows.length, 0);
});
