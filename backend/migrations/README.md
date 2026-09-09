# Migrations and PostgreSQL integration tests

From the repository root, after `cd backend && npm ci`, run:

```sh
npm run test:integration
```

This starts an official `docker.io/library/postgres:17` container using rootless Podman on Fedora (Docker when Podman is absent). Select explicitly with `CONTAINER_ENGINE=docker npm run test:integration`. Bash, coreutils `timeout` and a working container engine are prerequisites; no permanent database configuration is needed. The major is pinned to 17, matching the planned RDS major; minor security updates follow the official tag. The remediation was tested on PostgreSQL 17.11.

The runner binds an ephemeral port to loopback, uses tmpfs storage, waits for TCP readiness for up to 60 seconds, bounds the suite to 180 seconds, and removes the named container and volumes on exit, failure, INT or TERM. A forced host/process kill cannot run shell traps; remove a leftover `noryva-pg-test-*` container before retrying in that exceptional case. Only synthetic fixtures and a disposable test password are used. The image remains cached, but database storage does not persist. GitHub Actions runs this same command with Docker, without AWS credentials.

`test:integration:run` is the harness's internal entry point, not a command for an existing developer database. It only connects to loopback and the fixed `noryva_test` database. Its superuser connection is used for role bootstrap and server-version inspection only. Domain fixtures/migrations use the migration owner; isolation tests use real application-role connections.

## First immutable migration

`0001_core_identity_and_sync.sql` creates `accounts`, `devices`, `fitness_profiles`, `diary_entries`, `sync_state` and `jobs`, plus the RLS context function and snapshot triggers. The runner separately owns `schema_migrations`. There are no analytics tables, email columns, exact DOB fields, arbitrary JSON payloads or free-text job errors. Provider issuer/subject fields represent a future verified mapping, not an implemented Cognito flow.

Run migrations on one dedicated connection as `noryva_migrator`. Each reviewed SQL file runs transactionally under the runner's advisory lock. The SHA-256 ledger rejects modified or missing applied files. Re-running the same migration set does not reapply it. A failed migration rolls back both its DDL and ledger insertion. Never edit an applied migration, run it from API Lambda, or add automatic down migrations. Later changes require a new immutable file and a reviewed recovery plan.

## Roles and ownership

| Concept          | Actual role       | Authority                                                                                                                                                                                                                                        |
| ---------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| migration_owner  | `noryva_migrator` | Owns public schema, migrations, tables and policies; no superuser/BYPASSRLS. Trusted DDL authority, never the API role.                                                                                                                          |
| application_role | `noryva_api`      | SELECT accounts; SELECT/INSERT/UPDATE devices and jobs; SELECT/UPDATE sync state; SELECT/INSERT/UPDATE/DELETE profiles and diary. No table/schema ownership, schema creation, temporary objects, role administration, ledger access or TRUNCATE. |

All six domain tables have ENABLE and FORCE ROW LEVEL SECURITY, with both USING and WITH CHECK ownership expressions. `accounts.id` and other tables' `account_id` must equal `current_account_id()`. Missing/empty context gives NULL and no visible rows; malformed context raises an error. Composite device/diary references prevent cross-account associations. Setting `row_security=off` does not bypass policies for the application role. FORCE also subjects the owner to policy checks for ordinary DML, although a trusted owner can change the policies themselves. [PostgreSQL RLS documentation](https://www.postgresql.org/docs/17/ddl-rowsecurity.html)

The integration bootstrap revokes PUBLIC database/schema privileges and establishes separate real login roles. `scripts/bootstrap-roles.sql` describes the future RDS equivalent and IAM login intent; it was not executed against AWS. Its existing-role membership/attribute review remains a deployment prerequisite. Local tests deliberately do not use IAM authentication.

`withAccountTransaction(pool, principal, callback)` validates the internal principal, acquires one connection, begins a transaction, calls parameterized `set_config('app.account_id', $1, true)`, locks the account's sync-state row, checks live account/device state, runs trusted SQL, and commits or rolls back. Finally it resets the context and releases the connection, discarding it if cleanup fails. Callbacks must not control transactions, change identity or expose the client to mobile input. The tests reuse the same backend PID after commit, rollback and deliberate session contamination to prove context isolation.

RLS protects against missing predicates and cross-account row access under the selected context. It does not authenticate a PostgreSQL setting: compromised application SQL/credentials could set a different valid UUID. Only a future verified server principal may select context; the branded Zod schema proves shape, not token authenticity. No request DTO or current route accepts account ownership. Parameterized queries remain mandatory.

Profile and diary updates require exactly the next version and preserve identity, creation time and epoch. Nutrition snapshots are independent of a mutable food catalogue and immutable within an accepted version; a future deliberate edit replaces the versioned aggregate. Soft deletion clears health/food payloads immediately and leaves owner-visible metadata. Updating a tombstone, including resurrection, is rejected. Full sync receipts, cursor retention, hard-deletion lifecycle and anti-resurrection after tombstone expiry remain Phase 2D/2E work; this is not an implemented sync protocol.

## Phase 2C update

See [the Phase 2C identity design](../../docs/phase-2c-identity.md) for migration 0002, narrow identity-mapping functions, revoked-device handling and the centralized authorization boundary. The earlier sections describe the accepted Phase 2B baseline; the API now has optional identity-only routes. No health upload or sync routes exist. Migration 0002 removes direct application device INSERT/UPDATE and grants fixed registration/revocation functions instead.
