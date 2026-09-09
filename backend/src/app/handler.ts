import { randomUUID } from "node:crypto";
import type { APIGatewayProxyEventV2 } from "aws-lambda";
import type { Config } from "../config/environment.js";
import { parseJson } from "../middleware/json.js";
import { createLogger, type Logger } from "../observability/logger.js";
import { AppError, safeError } from "../security/errors.js";
import { jsonResponse } from "../security/response.js";
export interface Dependencies {
  config: () => Config;
  ready: () => Promise<boolean>;
  logger?: Logger;
}
export function createHandler(deps: Dependencies) {
  const log = deps.logger ?? createLogger();
  return async (event: APIGatewayProxyEventV2) => {
    const start = Date.now();
    // Generate internally: even syntactically valid client IDs can carry personal data.
    const correlationId = randomUUID();
    const requested = `${event.requestContext.http.method} ${event.rawPath}`;
    const route =
      requested === "GET /health" || requested === "GET /ready"
        ? requested
        : "unmatched";
    let status = 200;
    let category: "request_complete" | ReturnType<typeof safeError>["code"] =
      "request_complete";
    try {
      const config = deps.config();
      const input = parseJson(event, config.MAX_BODY_BYTES);
      if (route === "unmatched") throw new AppError("not_found");
      if (
        input !== undefined ||
        (event.body ?? "").length > 0 ||
        event.rawQueryString
      )
        throw new AppError("bad_request");
      if (route === "GET /ready" && !(await deps.ready()))
        throw new AppError("unavailable");
      return jsonResponse(200, { status: "ok" }, correlationId);
    } catch (error) {
      const safe = safeError(error);
      status = safe.status;
      category = safe.code;
      return jsonResponse(
        status,
        { error: safe.code, correlationId },
        correlationId,
      );
    } finally {
      // Telemetry failures must not alter the response. Never log the caught error.
      try {
        log({
          severity: status >= 500 ? "error" : "info",
          correlationId,
          route,
          status,
          latencyMs: Math.min(900000, Math.max(0, Date.now() - start)),
          category,
        });
      } catch {
        /* no fallback payload logging */
      }
    }
  };
}
