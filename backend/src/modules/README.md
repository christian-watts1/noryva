# Phase 2B domain boundaries

The foundation now contains explicit contracts, PostgreSQL ownership enforcement and account-scoped durable job operations. Identity verification, Cognito, account HTTP routes, mobile sync, privacy side effects and analytics remain unimplemented. The deployed-shape API still exposes only health/readiness. Account use stays optional and local tracking remains independent of cloud availability.

## Contracts

`contracts/domain.ts` uses strict Zod objects, bounded values and UUIDs. Unknown fields are rejected, including account IDs, DOB, age, email, search fields and analytics properties in fitness/diary bodies. Free-form food labels are required historical content, not a claim that content can never contain personal information; they must never be logged.

| Boundary            | Client supplied                                                                        | Server generated / controlled                                          | Immutable or versioned                                                  |
| ------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Verified principal  | Nothing                                                                                | Account/device IDs resolved from a future verified identity            | Internal branded type; validation is not authentication                 |
| Fitness profile     | Completed body, goal/activity, canonical units and saved calculation/target values     | Ownership, profile ID, accepted version, timestamps, epoch             | One versioned aggregate; no DOB/draft                                   |
| Diary snapshot      | Stable entry UUID, meal/time, quantity/serving/basis, food name/brand, seven nutrients | Ownership, trusted device binding, accepted version, timestamps, epoch | Snapshot immutable within its version; edits replace an aggregate       |
| Mutation envelope   | Expected `baseVersion` (0 for create)                                                  | Accepted next version                                                  | Never trust a client-selected accepted version                          |
| Sync metadata       | Nothing in write bodies                                                                | Epoch, revision, accepted version, creation/update times               | Describes an accepted record; initial sync-state revision 0 is internal |
| Tombstone           | Nothing in generic writes                                                              | ID/entity, epoch, version/revision and deletion time                   | Payload-free server metadata; deletion routes deferred                  |
| Device registration | Random public device ID, platform, OS major, app version                               | Internal device/account IDs, registration and revocation times         | Public device ID is not proof of authentication                         |
| Job request/status  | Allow-listed job type only                                                             | Job ID/owner, status, attempts and times                               | Queue operations enforce transitions; no client status/ownership        |

Transport weight limits preserve the existing calculation engine's supported 35–350 kg range; the onboarding UI currently has a lower ceiling. No mobile validation or formula was changed. The saved clamp boolean and algorithm version carry the calculation state without adding free-text diagnostic fields. Optional catalogue linkage and full protocol envelopes can be added only as reviewed contracts later.

No exact DOB is stored, but saved BMR, height, weight and calculation sex can reveal calculation age. This is still server-readable cloud data under the proposed encryption model, not E2EE, anonymous data or an age-secrecy guarantee. Necessity review of reconstructive fields remains required before health upload.

## Durable jobs

`jobs.ts` supplies enqueue, claim, finish/retry and expired-lease recovery operations on a trusted account-scoped connection. Jobs have a non-null owner, UUID, constrained type/status, attempts/max attempts, availability/lease/completion timestamps, worker UUID and an allow-listed error code. No sensitive payload or arbitrary error string is stored. Supported types are `export`, `cloud_delete`, and `account_delete`; these are queue labels, not implemented actions.

Claims atomically select a due pending row with `FOR UPDATE SKIP LOCKED`, increment attempts and record the worker. Completion/retry requires the matching owner context, worker and attempt number. Failures schedule a bounded delay or mark terminal failure at the attempt limit. Expired leases become pending or terminal failed; a stale attempt cannot complete a newly claimed job. Real overlapping transactions prove another worker skips a locked row. [PostgreSQL locking clauses](https://www.postgresql.org/docs/17/sql-select.html)

Use `withAccountTransaction` for the current safe execution boundary. Its account sync gate intentionally serializes same-account operations; the claim primitive also supports multiple already-scoped worker connections. No global dispatcher, cross-account worker bypass, EventBridge change, external effect or long-running transaction has been added. External actions must eventually execute outside the short claim transaction and be idempotent: database leases do not provide exactly-once external side effects. Workers for deletion of inactive accounts will need a separately reviewed restricted service context in the privacy phase; an interactive principal is intentionally rejected once its account/device is inactive.

See `backend/migrations/README.md` for roles, transaction rules and the disposable PostgreSQL command. Phase 2C may later implement approved optional identity and device lifecycle integration; it must not implicitly enable fitness uploads, analytics or AWS deployment.
