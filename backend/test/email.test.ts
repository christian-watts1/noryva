import { test } from "node:test";
import assert from "node:assert/strict";
import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { createEmailHandler } from "../src/identity/email.js";
import { createLogger } from "../src/observability/logger.js";
const signup = {
  operation: "SignUp",
  body: {
    Username: "synthetic@example.invalid",
    UserAttributes: [{ Name: "email", Value: "synthetic@example.invalid" }],
  },
};
function event(body: unknown) {
  return {
    rawPath: "/v1/auth/email",
    rawQueryString: "",
    requestContext: { http: { method: "POST" } },
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
    isBase64Encoded: false,
  } as unknown as APIGatewayProxyEventV2;
}
test("email boundary fixes provider/client, strips tokens and logs no identity content", async () => {
  const logs: string[] = [];
  const handler = createEmailHandler(
    "native",
    async (url, init) => {
      assert.equal(url, "https://cognito-idp.eu-west-2.amazonaws.com/");
      assert.equal(init?.redirect, "error");
      const body = JSON.parse(String(init?.body));
      assert.equal(body.ClientId, "native");
      assert.equal(body.ChallengeName, "EMAIL_OTP");
      return Response.json({
        AuthenticationResult: {
          AccessToken: "sensitive-access",
          ExpiresIn: 300,
          IdToken: "discard-id",
          RefreshToken: "discard-refresh",
        },
      });
    },
    createLogger((line) => logs.push(line)),
  );
  const result = await handler(
    event({
      operation: "RespondToAuthChallenge",
      body: {
        ChallengeName: "EMAIL_OTP",
        Session: "sensitive-session",
        ChallengeResponses: {
          USERNAME: "synthetic@example.invalid",
          EMAIL_OTP_CODE: "123456",
        },
      },
    }),
  );
  assert.equal(result.statusCode, 200);
  assert.deepEqual(JSON.parse(result.body), {
    AuthenticationResult: { AccessToken: "sensitive-access", ExpiresIn: 300 },
  });
  assert.doesNotMatch(logs.join(), /sensitive|synthetic|123456|discard/);
});
test("email overposting, arbitrary provider operations, query and size are rejected before transport", async () => {
  let calls = 0;
  const handler = createEmailHandler(
    "native",
    async () => {
      calls++;
      return Response.json({});
    },
    () => {},
  );
  for (const body of [
    null,
    { ...signup, account_id: "forged" },
    { ...signup, body: { ...signup.body, ClientId: "attacker" } },
    { ...signup, body: { ...signup.body, Password: "secret" } },
    { operation: "AdminCreateUser", body: {} },
    {
      operation: "InitiateAuth",
      body: { AuthFlow: "USER_PASSWORD_AUTH", AuthParameters: {} },
    },
    { ...signup, body: { ...signup.body, diary: [] } },
    { ...signup, body: { ...signup.body, Username: "bad" } },
    { ...signup, padding: "x".repeat(9000) },
  ])
    assert.equal((await handler(event(body))).statusCode, 400);
  assert.equal(
    (await handler({ ...event(signup), rawQueryString: "email=leak" }))
      .statusCode,
    400,
  );
  assert.equal(calls, 0);
});
test("signup duplicate/nonexistent provider outcomes have identical responses; errors never escape", async () => {
  for (const status of [200, 400, 429, 500]) {
    const result = await createEmailHandler(
      "native",
      async () =>
        Response.json(
          {
            message: "sensitive provider error",
            __type: "UsernameExistsException",
          },
          { status },
        ),
      () => {},
    )(event(signup));
    assert.equal(result.statusCode, 200);
    assert.equal(result.body, "{}");
  }
  const result = await createEmailHandler(
    "native",
    async () => Response.json({ message: "sensitive" }, { status: 400 }),
    () => {},
  )(
    event({
      operation: "ConfirmSignUp",
      body: {
        Username: "synthetic@example.invalid",
        ConfirmationCode: "123456",
      },
    }),
  );
  assert.equal(result.statusCode, 400);
  assert.doesNotMatch(result.body, /sensitive|synthetic/);
});
test("email challenge only permits EMAIL_OTP and bounds upstream responses", async () => {
  const request = event({
    operation: "InitiateAuth",
    body: {
      AuthFlow: "USER_AUTH",
      AuthParameters: {
        USERNAME: "synthetic@example.invalid",
        PREFERRED_CHALLENGE: "EMAIL_OTP",
      },
    },
  });
  for (const data of [
    { ChallengeName: "PASSWORD", Session: "x" },
    { ChallengeName: "EMAIL_OTP", Session: "x".repeat(40000) },
  ])
    assert.equal(
      (
        await createEmailHandler(
          "native",
          async () => Response.json(data),
          () => {},
        )(request)
      ).statusCode,
      400,
    );
  const response = await createEmailHandler(
    "native",
    async () =>
      Response.json({
        ChallengeName: "EMAIL_OTP",
        Session: "challenge",
        ChallengeParameters: { USERNAME: "synthetic", EMAIL: "discard" },
      }),
    () => {},
  )(request);
  assert.equal(response.statusCode, 200);
  assert.doesNotMatch(response.body, /discard/);
});
