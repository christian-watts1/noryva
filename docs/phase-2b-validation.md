# Phase 2B founder review and final validation report

Reviewed 9 September 2026 against the existing working tree. **Scaffold checks pass; full Phase 2B acceptance is not established. Stop here.** No AWS resources were created or modified in this review, no live Terraform plan/apply or database bootstrap was executed, and Phase 2C was not started. Public AWS pricing/documentation reads are not account inventory or billing verification.

This report supersedes Phase 2A's REST-first selection and standing staging cost assumptions. It does not approve deployment or claim the unfinished backend meets the complete Phase 2A acceptance criteria. Existing mobile/backend/Terraform work predates this review; this review changes the architecture cross-reference, this report, and the API mocked-test identity fixture only, plus local build output.

## API Gateway decision

**Retain HTTP API for the Phase 2B foundation.** The current Terraform exposes only `GET /health` and `GET /ready`, backed by generic status responses; there are no account, fitness, sync or analytics routes. There is no demonstrated requirement here for API keys, private ingress, gateway request validation or direct WAF. A private RDS integration does not require a private API endpoint. AWS's [feature comparison](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html) confirms HTTP API supports JWT/Lambda authorization but not direct WAF integration or REST's per-client usage controls.

The [current London AWS price list](https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonApiGateway/current/eu-west-2/index.json), retrieved during this review, has publication date `2026-08-31T09:21:34Z`. First-tier on-demand request rates are **$1.16/million HTTP** (SKU `MFY3FVZZSQWYVNHM`) and **$3.50/million REST** (SKU `Z5KFC4J7492YHH8P`). Do not substitute the commonly quoted $1.00 HTTP rate from another region.

| Monthly billable request units | HTTP | REST | REST premium |
|---|---:|---:|---:|
| 10,000 | $0.0116 | $0.0350 | $0.0234 |
| 100,000 (Phase 2A assumption) | $0.116 | $0.350 | $0.234 |
| 1,000,000 | $1.16 | $3.50 | $2.34 |

Calculated with Python Decimal from the published rates. USD, no tax, credits or discounts; excludes Lambda, logs, transfer, identity and WAF. These are request-unit comparisons for small payloads, not total bills or measured Noryva traffic. HTTP payload metering and other charges follow [API Gateway pricing](https://aws.amazon.com/api-gateway/pricing/). Request savings at early volume are small; avoiding unjustified standing infrastructure is the larger decision.

| Noryva threat | Relevant control and decision |
|---|---|
| Cross-account disclosure, mutation or deletion | Verified identity, live account/device checks, ownership predicates, constrained DB roles/RLS and two-user negative tests. WAF cannot establish ownership. These domain controls remain unimplemented. |
| Token theft or compromised mailbox | Future Cognito/PKCE/token lifecycle and recovery controls. HTTP JWT support is useful, but JWT validation alone does not implement immediate device/account revocation. |
| Malformed input and injection | Current bounded parsing, explicit routes, parameterized query adapter and generic errors; future strict domain DTO validation. WAF can add filtering, but cannot replace these controls. |
| Request floods and cost abuse | Current stage target 2 requests/second, burst 4, reserved Lambda concurrency 2, 10-second timeout, pool size 1 and 14-day logs. These protect capacity only partially; unauthenticated traffic can still incur charges and deny availability. |
| OTP/email abuse | Must be assessed on the actual future Cognito/identity surface; adding WAF to the Noryva API alone would not cover every identity request. |
| Operator/log/backup exposure and age inference | Minimize data and logs, constrain privileges and retention, disclose server readability. Ingress product choice does not resolve these risks. |

API Gateway [throttling is best effort](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html), not a hard spend ceiling. The current parser runs inside Lambda, after invocation costs can accrue. No claim is made that HTTP is security-equivalent to REST plus WAF. Reconsider REST before public data-bearing routes if measured abuse, required managed filtering, private ingress or another concrete feature justifies it. Include [WAF ACL/rule/request charges](https://aws.amazon.com/waf/pricing/) in that comparison. Do not add CloudFront merely to attach WAF without a demonstrated need and an origin-bypass design. Health-only validation does not authorise unauthenticated future routes.

## Staging operating model

**Default: local development and CI; no cloud resources during this phase.** The existing staging root has `enable_database = false`. If separately deployed later, it would create a request-driven HTTP/Lambda smoke-test surface with logs, not a functional database integration environment. `/ready` must not be interpreted as proof of a configured database when DB mode is disabled. Production also defaults to no database: its scaffold is not production-ready.

| Component | Staging decision and remaining cost |
|---|---|
| RDS | Off by default. Prefer disposable local PostgreSQL for domain/integration tests. A later synthetic AWS integration window can opt into Single-AZ `db.t4g.small`, 20 GiB gp3, with an explicit end time and reviewed cleanup. Running RDS charges while idle; storage, snapshots, managed secret and keys add costs. |
| RDS Proxy | Absent. Current concurrency/pool limits do not justify it. Add only after connection/failover measurement; [proxy pricing](https://aws.amazon.com/rds/proxy/pricing/) introduces capacity-based charges. |
| Interface endpoints | Absent. Current optional API signs IAM DB tokens and connects directly to PostgreSQL; its role has no secret-read permission. Future secret retrieval, identity administration, exports or SDK calls require a fresh connectivity inventory. [PrivateLink bills endpoint-hours per AZ](https://aws.amazon.com/privatelink/pricing/) even while idle. |
| NAT Gateway | Absent; optional subnets have isolated routes. Do not add NAT to repair an unexplained connectivity failure. |
| ALB | Absent; API Gateway invokes Lambda directly. No hourly load balancer is needed. |
| Always-on compute | No ECS/EC2 tasks, provisioned Lambda concurrency or standing migration runner. Reserved concurrency is a limit, not provisioned warm capacity. |
| Other fixed costs | DB opt-in creates two customer-managed KMS keys and an RDS-managed administrator secret. No custom DNS, WAF, cache or interface endpoints are present in the default foundation. Logs can retain billable storage after traffic ends. |

Stopping RDS is not the idle-cost strategy: AWS [automatically restarts it after seven days](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_StopInstance.html), and storage/backup costs remain while stopped. Any future ephemeral integration environment needs an owner, expiry, cleanup verification and retained-artifact inventory. That automation does not exist yet; this report does not execute or authorise deletion.

Incremental AWS cost of this phase is **$0 from resource creation**, because none is performed. This is not a claim about the account's existing bill. A future database-free smoke environment has no modeled standing compute/database/network charge, but requests, duration, logs and transfer remain billable. The old $76–150 permanent staging allowance is withdrawn as the default. No exact London RDS integration-window total is claimed: price the selected SKU, running hours, storage lifetime, backups, keys and secret before any future resource approval. Keep production-like integration testing time-bounded; do not trade away private DB access or data safeguards to reduce cost. DynamoDB or Aurora would change persistence assumptions and are not justified merely to keep staging always available.

## Privacy finding preserved

Omitting explicit DOB and age fields does **not** guarantee age secrecy. For the existing Mifflin–St Jeor calculation, `age = (10 × weight_kg + 6.25 × height_cm + sex_constant − BMR) / 5`. Exact saved inputs and BMR can recover calculation age; rounding can still narrow it. This does not necessarily recover exact DOB. Saved outputs and other reconstructive inputs require the same necessity review as in Phase 2A.

The proposed cloud remains server-readable with encryption in transit and at rest, not end-to-end encrypted or zero knowledge. Do not describe the future synced plan as age-free, anonymous or incapable of revealing age. No new cloud DTO or mobile behavior was implemented in this review.

## Validation and acceptance limits

| Check | Result |
|---|---|
| Backend format, ESLint, TypeScript | Passed |
| Backend tests | 18 passed; database tests use mock query executors |
| Lambda artifact build | Passed |
| npm advisory audit | Reported 0 vulnerabilities at review time; not a security audit |
| Terraform recursive format | Passed |
| Staging and production validate | Both passed |
| Mocked Terraform plans | Network 1, database 2, API 2 passed; no AWS provider operations |
| CI privilege inspection | Read-only repository permission, pinned action SHAs, no AWS credentials/OIDC deployment job; Terraform tests use mock providers and `command = plan` |
| Real PostgreSQL/RLS/two-user tests | Not present or executed |
| Live account plan, deployment, IAM/TLS/connectivity checks | Not executed; outside this phase's resource authority |
| Mobile regression suite | Not rerun; review did not edit mobile code |

Initial sandbox restrictions prevented the test runner's local socket and Terraform provider startup; the same local checks passed outside that sandbox. API mock plans initially failed because a generated caller account ID was not 12 digits. The fixture now supplies a synthetic account ID, region and partition, and both API runs pass. No runtime security control was weakened to make the tests pass.

Against the full Phase 2A section 20 definition of 2B, ownership/RLS schema, real local PostgreSQL constraint/two-user validation, domain contracts and the durable job skeleton remain absent (see `backend/migrations/README.md` and `backend/src/modules/README.md`). The current bootstrap grants no domain-table access, and mock migration tests do not demonstrate real PostgreSQL enforcement. A deployable account-specific plan and costed integration window also remain unverified. Record this as a validated **foundation scaffold**, not a completed functional backend or full Phase 2B acceptance.

Founder review decisions are incorporated. Stop after this validation report; no automatic Phase 2C, cloud creation, authentication integration or health-data upload.
