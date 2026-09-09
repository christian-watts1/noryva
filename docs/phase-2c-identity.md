# Phase 2C — optional identity and account safety

This phase implements a code-only, testable identity foundation. It does not deploy AWS, send real email, upload profile/diary records or implement Phase 2D sync. The default build has no identity configuration and remains fully usable locally. Account creation/sign-in is an explicit action under **Me → Optional account**. Authentication never enables backup, analytics, merging or deletion of local health records.

## Architecture and Cognito compatibility

The mobile identity adapter calls only Noryva's `POST /v1/auth/email` endpoint. A bounded, non-VPC Lambda adapter invokes Cognito's native `SignUp` / `ConfirmSignUp` and `USER_AUTH` / `EMAIL_OTP` challenge operations over HTTPS. It supplies no password or client secret. Email and challenge codes pass transiently through the Noryva identity adapter to Cognito; neither is stored or logged by Noryva. The configured provider/client cannot be supplied by the mobile request. No Identity Pool, IAM credentials, phone number, passkey, tracking identifier or generic AWS client is exposed to mobile.

This is a concrete adjustment to Phase 2A's managed-login/PKCE proposal: AWS currently documents that managed-login signup still requires a password even when passwordless sign-in is enabled. SDK/API signup can omit it. Native Cognito challenge authentication is not an OAuth authorization-code redirect flow, so PKCE is not bolted onto it. A later OAuth/browser flow must use code + PKCE and independently validate redirect/state behavior. [AWS authentication methods](https://docs.aws.amazon.com/cognito/latest/developerguide/authentication.html)

Cognito Terraform defines an Essentials User Pool and a public native App Client: EMAIL_OTP only, ALLOW_USER_AUTH only, no secret, no Identity Pool/domain, five-minute access/ID tokens, token revocation, refresh rotation, generic user-existence errors and production deletion protection. MFA is OFF because this chosen email-OTP first factor is incompatible with required MFA; it is not represented as MFA. Password reset uses no self-service recovery flow; mailbox OTP is the recovery mechanism.

AWS requires an SES email configuration for email OTP. `identity_email_source_arn` must identify a separately approved existing London SES identity when identity is enabled. This phase creates no SES resources and does not verify an identity, request sending access or send email. Both `enable_identity` and `enable_database` remain false by default; functioning future identity routes need both explicitly enabled, migrations/bootstrap, and that SES prerequisite. No plan/apply against an AWS account was run. [AWS email/OTP prerequisites](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-email.html)

A non-VPC Lambda authorizer performs cryptographic JWT verification and can retrieve Cognito JWKS without NAT or interface endpoints. The isolated database Lambda receives only the verified identity context through API Gateway. HTTP API is retained: there is no new demonstrated REST/WAF requirement. No fixed-cost ALB, RDS Proxy or networking component is added; authorizer/email-adapter reserved concurrency is a cap, not provisioned warm capacity. The default staging cost model is unchanged.

## Token verification and trust boundaries

`AuthVerifier.verifyBearerToken` returns an internal branded `VerifiedIdentity`: configured issuer, provider subject, client ID, issued/expiry/authentication times. `CognitoVerifier` uses the maintained `jose` library and verifies RS256 signature against the configured issuer's JWKS, exact issuer, client_id, optional audience, token_use=access, expiry, not-before if present, issued/authentication timestamps and required subject. Unsigned, forged, wrong-algorithm, ID-token, malformed and wrong-client tokens are rejected. Merely decoding a JWT never establishes identity.

The authorizer has no database or Cognito administration permissions. Its result cache is disabled. The API consumes only API Gateway Lambda-authorizer context, checks issuer/client/expiry again, and binds that context to the actual bearer token using a SHA-256 digest. Request headers/body cannot supply verified issuer/subject/account fields. IAM invocation permissions restrict gateway entry points; privileged control-plane actors with separate invoke/code authority remain trusted. Authorizer context and token digests are not logged.

Tests inject an `AuthVerifier` returning an already verified synthetic identity; cryptographic tests separately sign real local test JWTs and use local JWKS. No test retrieves live Cognito keys or makes an AWS call. The existing `VerifiedPrincipal` is constructed centrally only after mapping and live device validation. Its UUID schema alone is not authentication.

## Mapping, transactions and database privileges

Immutable migration `0002_identity_lifecycle.sql` extends the accepted 0001 migration. The unique `(provider_issuer, provider_subject)` mapping is serialized with a transaction advisory lock and generates its own internal account UUID. Repeat/concurrent first login maps to the same account. Email is never a relational identifier. Deleting/deleted mappings remain reserved and deny ordinary use; they are not reassigned or recreated implicitly.

A narrow SECURITY DEFINER mapping function is necessary because no account RLS context exists before mapping. A policy permits its migration-owner role to access accounts; the application role gets EXECUTE on fixed functions, not owner membership, arbitrary table privileges or BYPASSRLS. Function search paths are fixed; object references are qualified; PUBLIC execution is revoked. Fitness/diary FORCE RLS remains unchanged. Compromised arbitrary application SQL is outside the protection of caller-selected RLS settings, as documented in Phase 2B.

`IdentityService` is the centralized protected-route middleware. It parses the bearer token and strict endpoint body, verifies identity, begins a dedicated-connection transaction, maps identity, sets the account context with parameters, locks the existing account sync-state gate, checks live account status/revocation time, and checks the requested internal device before normal account operations. It commits/rolls back, resets context and releases/discards the connection. Bootstrap session/registration are explicit exceptions to requiring an already registered device, but require fresh authentication within five minutes and an active account. Route handlers cannot choose an account context. No SQL parameters, provider errors, email, raw token or health values are logged.

## Devices and revocation

Registration collects only a random public UUID, platform, OS major and app version. The native metadata channel returns only OS major and app version; it does not request advertising/hardware IDs or fingerprinting fields. Registration is idempotent for an active `(account, public UUID)` and bounded to ten active / one hundred lifetime device rows per account. Metadata updates and quota recovery are future explicit operations.

Every normal protected operation checks live account/device status inside the transaction. A fabricated device, another account's device, or revoked device is denied regardless of JWT signature validity. Revocation marks the old internal device revoked and advances account `auth_valid_after`. **This conservative policy requires fresh mailbox authentication on all devices after any device revocation**, preventing a still-valid old token from bypassing revocation by registering a new public UUID. Refreshed tokens retain the older authentication time and do not bypass this floor. Times in the same second as revocation are conservatively rejected.

After fresh authentication, re-registering the same public UUID generates a new internal device identity; the old revoked identity stays revoked for historical references. There is no un-revoke operation or broad API device-table UPDATE privilege. The default mobile adapter discards ID/refresh tokens and retains only the short-lived access session; expiry requires another email sign-in. Background refresh is not implemented.

## Routes and strict contracts

| Route | Requirements and response |
|---|---|
| `POST /v1/auth/email` | Public bounded email-OTP exchange; strict operation-specific identity bodies, fixed provider/client, generic errors, no health fields. Returns only challenge data or access token/expiry. |
| `POST /v1/account/session` | Fresh verified identity, empty object; maps account and returns internal account ID/status. No health attachment or upload. |
| `POST /v1/devices/register` | Fresh verified identity, strict technical-metadata DTO; returns account/internal device IDs. |
| `GET /v1/account` | Verified identity and `x-noryva-device`; returns active account/device identity only. |
| `POST /v1/devices/{deviceId}/revoke` | Active caller device, verified account, empty object; revokes only an owned target. |
| `GET /health`, `GET /ready` | Remain unauthenticated. |

No profile/diary/sync/analytics routes or deletion-request route were added. Account/device bodies reject unknown ownership, issuer, subject, email, DOB and health fields. Only the explicitly defined OTP endpoint accepts email/challenge material. It permits four fixed passwordless operations, limits requests to 8 KiB and provider responses to 32 KiB, strips ID/refresh tokens, hides signup existence outcomes, and has no DB or Cognito administration permissions. Gateway/body limits, existing timeouts/concurrency caps, UUID validation, strict route labels, no-store responses and generic errors remain in place. API throttles are best-effort, not a spending guarantee. Device quotas limit one authenticated account; distributed account creation and OTP/email abuse still need monitored pre-launch controls. Cognito SignUp itself can expose provider-specific existence behavior to someone calling its public API; generic app wording is not a promise of provider-wide enumeration resistance.

## Local workspace state machine

SQLite schema 4 adds a separate `workspace_identity` row containing only the attached account UUID and random public device UUID. The additive migration leaves profile, diary and calculation data intact. This association is intentionally durable separately from secure session storage.

| Current workspace | Action | Result |
|---|---|---|
| Local-only (no association) | Continue anonymously | All existing local features work; no identity request. |
| Local-only | Explicit successful identity mapping | Record account association before persisting a session; register the device. No health upload. |
| Attached A | Sign in as A | Retain local data/owner; establish a session, subject to server device policy. |
| Attached A | Sign in as B | Block before B device registration/session persistence; no overwrite or merge. |
| Attached A | Sign out, lose/expire session | Retain association A and all local profile/diary data; no upload rights transfer. |
| Attached A | Reset local health data | Existing reset behavior clears local health records but retains the account safety association. No implicit detach/reassignment. |

A partial registration/storage failure may leave an association without a session; retrying the same account is safe. There is no detach, workspace merge or different-account conflict resolution in this phase. No backend accepts a mobile-provided workspace owner as authentication evidence.

The mobile build needs only `--dart-define=NORYVA_API_URL=https://...` to point to an explicitly authorised future deployment; no Cognito client/provider selection is exposed to mobile. Session secrets use `flutter_secure_storage` (platform secure storage; device-only Keychain accessibility on iOS), never Drift or shared preferences directly. Version 10.3.2 is locked for the existing Android SDK 36 toolchain; version 11 requires SDK 37 ([upstream changelog](https://pub.dev/packages/flutter_secure_storage/changelog)). The session abstraction is testable independently. Android cloud backup/device-transfer exclusions cover app files, databases and preferences, and cleartext network access is disabled. These settings are not claims of universal protection against rooted devices, OS compromise or untested OEM backup behavior.

Sign-out attempts server device revocation, then securely removes the local session. It never deletes diary/profile data or the owner association. Offline failure is explicitly reported as local sign-out without confirmed remote revocation; there is no claim that stolen tokens were remotely invalidated. Secure-storage deletion failure is surfaced and retryable. No browser login cookie is created by the native challenge flow.

## Recovery and deletion boundaries

Mailbox control is the initial passwordless recovery mechanism. A compromised mailbox can authenticate as its owner; there are no security questions, phone fallback or stronger recovery claims. Loss of mailbox access requires a separately designed support policy, not an email-based reassignment of fitness records.

Active accounts operate normally. Deleting/deleted accounts deny ordinary account/device operations. This phase tests those existing states but does not implement an end-user deletion transition, cloud cleanup, Cognito deletion or erasure receipts. UI does not claim account deletion is available. Local-only tracking remains separate from cloud account status.

## Privacy inventory and threat assessment

| Data | Location/purpose |
|---|---|
| Email, OTP and native challenge session | Transient mobile memory and Noryva OTP-adapter/provider interaction; no application DB/log copy. |
| Issuer/subject, internal UUID, account status/times, authentication revocation floor | PostgreSQL identity mapping and account safety. |
| Random public/internal device IDs, platform, OS major, app version, registration/revocation times | Account-scoped device authorization. |
| Access token and expiry plus account/device binding | Secure local session storage; transient authorizer verification context. No ID/refresh token persistence. |
| Account/public device association | Separate local SQLite row for workspace safety. |
| Correlation ID, canonical route, status/category, latency | Redacted operational logs. No raw URL/body/token/email/health fields. |

Main threats addressed are forged/confused JWTs, first-login races, cross-account access, stale-token revocation bypass, device-registration abuse, log leakage and silent workspace reassignment. Residual risks include mailbox/device compromise, stolen tokens before expiry/revocation, provider email abuse/enumeration, trusted service/DB administrator compromise and real deployment/platform behavior not exercised offline. This is acceptance testing and source review, not an independent penetration test.

No profile/diary data is transmitted by the application in Phase 2C; analytics, ads, branded foods, subscriptions and Health Connect remain absent. The eventual cloud encryption model is still server-readable. Excluding DOB does not guarantee age secrecy if reconstructive fitness calculation inputs/outputs are later synced.

## Validation and phase boundary

Code-only Phase 2C validation: **PASS**.

- Backend: `npm ci`, formatting, lint, typecheck, **32 unit tests**, both Lambda bundle builds and audit passed; audit reported zero vulnerabilities.
- Disposable PostgreSQL **17**: `cd backend && npm run test:integration` passed **21 tests**, including the original Phase 2B suite and seven identity subtests (the Node total also counts their parent test). No permanent database or cloud dependency.
- Flutter: formatting and analysis clean; **50 tests passed**, including local onboarding/diary, schema migration, workspace conflicts, session storage and API-only identity transport. Android debug APK compiled successfully.
- Terraform: recursive format check, backend-disabled init/validation for staging and production, and **9 mocked tests** (network 1, database 2, API 4, identity 2) passed.
- CI retains backend/real PostgreSQL/build/audit and Flutter checks, adds the identity Terraform module to mocked validation, and explicitly restricts both workflows to `contents: read`. No deployment job or AWS credentials.
- Source/diff review preserved the immutable Phase 2B migration, existing health-domain behavior and local-only defaults. iOS Keychain entitlement configuration is included for Debug/Profile/Release; compilation cannot be verified on this Linux host.

 No AWS apply, live Cognito call, real email or SES configuration is part of these checks. Live email delivery, device-native secure-storage/backup behavior, production signing and iOS compilation/device acceptance remain deployment/release gates rather than inferred successes from unit tests.

Phase 2D must be separately authorised. Its recommended scope is explicit backup consent, reviewed cloud DTO transport, account-bound outbox/cursors, conflict handling, epoch/tombstone safety and synthetic multi-device testing. Signing in here must not implicitly start any of that work. Stop at the Phase 2C report.
