export { emailHandler } from "./email.js";
import { createHash } from "node:crypto";
import { bearer, CognitoVerifier, type AuthVerifier } from "./verifier.js";
export function createAuthorizer(verifier: AuthVerifier) {
  return async (event: { headers?: Record<string, string | undefined> }) => {
    try {
      const token = bearer(event.headers ?? {});
      const identity = await verifier.verifyBearerToken(token);
      return {
        isAuthorized: true,
        context: {
          identity: JSON.stringify(identity),
          tokenHash: createHash("sha256").update(token).digest("hex"),
        },
      };
    } catch {
      return { isAuthorized: false, context: {} };
    }
  };
}
let verifier: AuthVerifier | undefined;
export async function handler(event: {
  headers?: Record<string, string | undefined>;
}) {
  try {
    verifier ??= new CognitoVerifier(
      process.env.AUTH_ISSUER!,
      process.env.AUTH_CLIENT_ID!,
    );
    return await createAuthorizer(verifier)(event);
  } catch {
    return { isAuthorized: false, context: {} };
  }
}
