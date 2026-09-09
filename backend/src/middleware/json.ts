import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { z } from "zod";
import { AppError } from "../security/errors.js";

export function parseJson(
  event: APIGatewayProxyEventV2,
  limit: number,
): unknown {
  const raw = event.body ?? "";
  // Bound encoded allocation before decoding. Gateway has its own larger transport limit.
  if (Buffer.byteLength(raw, "utf8") > Math.ceil(limit / 3) * 4 + 4)
    throw new AppError("payload_too_large");
  if (
    event.isBase64Encoded &&
    !/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(
      raw,
    )
  )
    throw new AppError("bad_request");
  const bytes = Buffer.from(raw, event.isBase64Encoded ? "base64" : "utf8");
  if (bytes.length > limit) throw new AppError("payload_too_large");
  if (!bytes.length) return undefined;
  const headers = Object.fromEntries(
    Object.entries(event.headers).map(([key, value]) => [
      key.toLowerCase(),
      value,
    ]),
  );
  if (headers["content-encoding"] && headers["content-encoding"] !== "identity")
    throw new AppError("unsupported_media_type");
  if (
    !/^application\/json(?:\s*;\s*charset=utf-8)?$/i.test(
      headers["content-type"] ?? "",
    )
  )
    throw new AppError("unsupported_media_type");
  try {
    return JSON.parse(
      new TextDecoder("utf-8", { fatal: true }).decode(bytes),
    ) as unknown;
  } catch {
    throw new AppError("bad_request");
  }
}
export function validateInput<T>(schema: z.ZodType<T>, input: unknown): T {
  const result = schema.safeParse(input);
  if (!result.success) throw new AppError("bad_request");
  return result.data;
}
