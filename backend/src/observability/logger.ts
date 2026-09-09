import { z } from "zod";
import { identityRoutes } from "../identity/service.js";
// Runtime allow-list, including values. Merely dropping secret-named keys is insufficient.
const recordSchema = z.object({
  severity: z.enum(["info", "error"]),
  correlationId: z.uuid(),
  route: z.enum([
    "GET /health",
    "GET /ready",
    ...identityRoutes,
    "POST /v1/auth/email",
    "unmatched",
  ]),
  status: z.number().int().min(100).max(599),
  latencyMs: z.number().int().min(0).max(900000),
  category: z.enum([
    "request_complete",
    "unauthorized",
    "bad_request",
    "unsupported_media_type",
    "payload_too_large",
    "not_found",
    "unavailable",
    "internal_error",
  ]),
});
export type LogRecord = z.infer<typeof recordSchema>;
export type Logger = (record: LogRecord) => void;
export function createLogger(
  sink: (line: string) => void = console.log,
): Logger {
  return (record) => {
    const parsed = recordSchema.safeParse(record);
    // Discard malformed records rather than stringify unknown values or errors.
    if (!parsed.success) return;
    sink(
      JSON.stringify({ timestamp: new Date().toISOString(), ...parsed.data }),
    );
  };
}
