import { test } from "node:test";
import assert from "node:assert/strict";
import { generateKeyPair, exportJWK, createLocalJWKSet, SignJWT } from "jose";
import {
  CognitoVerifier,
  bearer,
  GatewayVerifier,
} from "../src/identity/verifier.js";
import { createAuthorizer } from "../src/identity/authorizer.js";
const issuer = "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_test";
const keys = await generateKeyPair("RS256");
const jwk = await exportJWK(keys.publicKey);
jwk.kid = "test";
const verifier = new CognitoVerifier(
  issuer,
  "native",
  createLocalJWKSet({ keys: [jwk] }),
);
const now = Math.floor(Date.now() / 1000);
async function token(
  claims: Record<string, unknown> = {},
  algorithm = "RS256",
) {
  return new SignJWT({
    iss: issuer,
    sub: "synthetic-subject",
    client_id: "native",
    token_use: "access",
    iat: now,
    auth_time: now,
    exp: now + 300,
    ...claims,
  })
    .setProtectedHeader({ alg: algorithm, kid: "test" })
    .sign(keys.privateKey);
}
test("cryptographic Cognito access-token validation accepts valid signed identity", async () => {
  const identity = await verifier.verifyBearerToken(await token());
  assert.equal(identity.subject, "synthetic-subject");
});
test("rejects expired, wrong issuer/client/audience/type, missing subject, future nbf/iat and unsigned JWTs", async () => {
  for (const claims of [
    { exp: now - 1 },
    { iss: "https://attacker.invalid" },
    { client_id: "other" },
    { aud: "other" },
    { token_use: "id" },
    { sub: "" },
    { sub: undefined },
    { nbf: now + 600 },
    { iat: now + 60 },
    { auth_time: undefined },
  ])
    await assert.rejects(
      verifier.verifyBearerToken(await token(claims)),
      /unauthorized/,
    );
  for (const raw of [
    "x",
    "a.b.c",
    `${Buffer.from('{"alg":"none"}').toString("base64url")}.${Buffer.from("{}").toString("base64url")}.`,
  ])
    await assert.rejects(verifier.verifyBearerToken(raw), /unauthorized/);
});
test("wrong algorithm and forged signature are rejected", async () => {
  const other = await generateKeyPair("RS256");
  const forged = await new SignJWT({ iss: issuer, sub: "subject" })
    .setProtectedHeader({ alg: "RS256", kid: "test" })
    .sign(other.privateKey);
  await assert.rejects(verifier.verifyBearerToken(forged));
  const hmac = await new SignJWT({ iss: issuer })
    .setProtectedHeader({ alg: "HS256", kid: "test" })
    .sign(new TextEncoder().encode("synthetic-test-key-long-enough-32-bytes"));
  await assert.rejects(verifier.verifyBearerToken(hmac));
});
test("authorizer context is token bound, denies failures and never includes token/email", async () => {
  const raw = await token({ email: "sentinel@example.invalid" });
  const result = await createAuthorizer(verifier)({
    headers: { authorization: `Bearer ${raw}` },
  });
  assert.equal(result.isAuthorized, true);
  assert.ok(!JSON.stringify(result).includes(raw));
  assert.ok(!JSON.stringify(result).includes("sentinel"));
  assert.equal(
    (
      await new GatewayVerifier(
        result.context,
        issuer,
        "native",
      ).verifyBearerToken(raw)
    ).subject,
    "synthetic-subject",
  );
  await assert.rejects(
    new GatewayVerifier(result.context, issuer, "native").verifyBearerToken(
      "different",
    ),
  );
  assert.equal(
    (
      await createAuthorizer(verifier)({
        headers: { authorization: "Bearer invalid" },
      })
    ).isAuthorized,
    false,
  );
  assert.throws(() => bearer({}));
  assert.throws(() => bearer({ authorization: "Basic value" }));
});
