import { randomUUID } from "node:crypto";
import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { z } from "zod";
import { parseJson } from "../middleware/json.js";
import { jsonResponse } from "../security/response.js";
import { createLogger, type Logger } from "../observability/logger.js";
const email = z.email().max(254);
const code = z.string().regex(/^\d{6}$/);
const username = z.string().min(1).max(254);
const requestSchema = z.discriminatedUnion("operation", [
  z.strictObject({
    operation: z.literal("SignUp"),
    body: z.strictObject({
      Username: email,
      UserAttributes: z.tuple([
        z.strictObject({ Name: z.literal("email"), Value: email }),
      ]),
    }),
  }),
  z.strictObject({
    operation: z.literal("ConfirmSignUp"),
    body: z.strictObject({ Username: email, ConfirmationCode: code }),
  }),
  z.strictObject({
    operation: z.literal("InitiateAuth"),
    body: z.strictObject({
      AuthFlow: z.literal("USER_AUTH"),
      AuthParameters: z.strictObject({
        USERNAME: email,
        PREFERRED_CHALLENGE: z.literal("EMAIL_OTP"),
      }),
    }),
  }),
  z.strictObject({
    operation: z.literal("RespondToAuthChallenge"),
    body: z.strictObject({
      ChallengeName: z.literal("EMAIL_OTP"),
      Session: z.string().min(1).max(4096),
      ChallengeResponses: z.strictObject({
        USERNAME: username,
        EMAIL_OTP_CODE: code,
      }),
    }),
  }),
]);
export function createEmailHandler(
  clientId: string,
  transport: typeof fetch = fetch,
  log: Logger = createLogger(),
) {
  return async (event: APIGatewayProxyEventV2) => {
    const correlationId = randomUUID();
    const start = Date.now();
    let status = 400;
    try {
      if (
        !clientId ||
        event.rawPath !== "/v1/auth/email" ||
        event.requestContext.http.method !== "POST" ||
        event.rawQueryString
      )
        throw Error();
      const request = requestSchema.parse(parseJson(event, 8192));
      if (
        request.operation === "SignUp" &&
        request.body.Username !== request.body.UserAttributes[0].Value
      )
        throw Error();
      const response = await transport(
        "https://cognito-idp.eu-west-2.amazonaws.com/",
        {
          method: "POST",
          redirect: "error",
          signal: AbortSignal.timeout(4000),
          headers: {
            "content-type": "application/x-amz-json-1.1",
            "x-amz-target": `AWSCognitoIdentityProviderService.${request.operation}`,
          },
          body: JSON.stringify({ ...request.body, ClientId: clientId }),
        },
      );
      // Never disclose duplicate/nonexistent signup identities or provider errors.
      // Delivery is deliberately not confirmed to the caller.
      if (request.operation === "SignUp") {
        await response.body?.cancel();
        status = 200;
        return jsonResponse(200, {}, correlationId);
      }
      if (!response.ok) {
        await response.body?.cancel();
        throw Error();
      }
      const reader = response.body?.getReader();
      if (!reader) throw Error();
      let raw = "";
      let size = 0;
      const decoder = new TextDecoder("utf-8", { fatal: true });
      try {
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          size += value.length;
          if (size > 32768) throw Error();
          raw += decoder.decode(value, { stream: true });
        }
        raw += decoder.decode();
      } finally {
        await reader.cancel();
      }
      const data = JSON.parse(raw) as Record<string, unknown>;
      let result: Record<string, unknown> = {};
      if (request.operation === "InitiateAuth") {
        const challenge = z
          .object({
            ChallengeName: z.literal("EMAIL_OTP"),
            Session: z.string().min(1).max(4096),
            ChallengeParameters: z.object({ USERNAME: username }).optional(),
          })
          .parse(data);
        result = challenge;
      } else if (request.operation === "RespondToAuthChallenge") {
        const auth = z
          .object({
            AccessToken: z.string().min(1).max(8192),
            ExpiresIn: z.number().int().min(1).max(3600),
          })
          .parse(data.AuthenticationResult);
        result = { AuthenticationResult: auth }; // Strip ID/refresh tokens and all other provider metadata.
      }
      status = 200;
      return jsonResponse(200, result, correlationId);
    } catch {
      return jsonResponse(
        400,
        { error: "account_action_unavailable", correlationId },
        correlationId,
      );
    } finally {
      try {
        log({
          severity: "info",
          correlationId,
          route: "POST /v1/auth/email",
          status,
          latencyMs: Math.min(900000, Date.now() - start),
          category: status === 200 ? "request_complete" : "bad_request",
        });
      } catch {
        /* no payload fallback */
      }
    }
  };
}
export async function emailHandler(event: APIGatewayProxyEventV2) {
  return createEmailHandler(process.env.AUTH_CLIENT_ID ?? "")(event);
}
