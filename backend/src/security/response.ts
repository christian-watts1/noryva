export const securityHeaders = Object.freeze({
  "content-type": "application/json; charset=utf-8",
  "cache-control": "no-store",
  "x-content-type-options": "nosniff",
  "strict-transport-security": "max-age=31536000",
  "content-security-policy": "default-src 'none'; frame-ancestors 'none'",
  "x-frame-options": "DENY",
  "referrer-policy": "no-referrer",
});
export function jsonResponse(
  statusCode: number,
  body: Record<string, unknown>,
  correlationId: string,
) {
  return {
    statusCode,
    headers: { ...securityHeaders, "x-correlation-id": correlationId },
    body: JSON.stringify(body),
    isBase64Encoded: false,
  };
}
