import { test } from "node:test";
import assert from "node:assert/strict";
import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { z } from "zod";
import { createHandler } from "../src/app/handler.js";
import { readConfig } from "../src/config/environment.js";
import { createLogger, type LogRecord } from "../src/observability/logger.js";
import { parseJson, validateInput } from "../src/middleware/json.js";

function event(
  path = "/health",
  body?: string,
  headers: Record<string, string> = {},
): APIGatewayProxyEventV2 {
  return {
    version: "2.0",
    routeKey: `GET ${path}`,
    rawPath: path,
    rawQueryString: "",
    headers,
    requestContext: {
      accountId: "test",
      apiId: "test",
      domainName: "test",
      domainPrefix: "test",
      http: {
        method: "GET",
        path,
        protocol: "HTTP/1.1",
        sourceIp: "127.0.0.1",
        userAgent: "test",
      },
      requestId: "test",
      routeKey: `GET ${path}`,
      stage: "$default",
      time: "",
      timeEpoch: 0,
    },
    isBase64Encoded: false,
    ...(body === undefined ? {} : { body }),
  };
}
const config = () => readConfig({ APP_ENV: "test" });
const app = (ready: () => Promise<boolean> = async () => true) =>
  createHandler({ config, ready, logger: () => {} });
test("health returns only generic status and security headers without querying DB", async () => {
  const response = await app(async () => {
    throw Error("DB must not be used");
  })(event());
  assert.equal(response.statusCode, 200);
  assert.deepEqual(JSON.parse(response.body), { status: "ok" });
  assert.equal(response.headers["cache-control"], "no-store");
  assert.equal(response.headers["x-content-type-options"], "nosniff");
  assert.match(
    response.headers["content-security-policy"],
    /default-src 'none'/,
  );
  assert.match(response.headers["strict-transport-security"], /max-age/);
});
test("ready reports success or generic unavailable, never DB details", async () => {
  assert.equal((await app()(event("/ready"))).statusCode, 200);
  const response = await app(async () => false)(event("/ready"));
  assert.equal(response.statusCode, 503);
  assert.equal(JSON.parse(response.body).error, "unavailable");
});
test("invalid route and method cannot expose a future module", async () => {
  assert.equal(
    (await app()(event("/profiles/private@example.com"))).statusCode,
    404,
  );
  const input = event();
  input.requestContext.http.method = "POST";
  assert.equal((await app()(input)).statusCode, 404);
});
test("central errors redact exceptions and configuration values", async () => {
  for (const handler of [
    app(async () => {
      throw Error("password=secret; DOB=01/01/1990");
    }),
    createHandler({
      config: () => {
        throw Error("TOKEN secret");
      },
      ready: async () => true,
      logger: () => {},
    }),
  ]) {
    const response = await handler(event("/ready"));
    assert.equal(response.statusCode, 500);
    assert.equal(JSON.parse(response.body).error, "internal_error");
    assert.doesNotMatch(response.body, /secret|DOB|TOKEN|stack/);
  }
});
test("malformed JSON, non-JSON and non-UTF8 are rejected", async () => {
  assert.equal(
    (await app()(event("/health", "{", { "content-type": "application/json" })))
      .statusCode,
    400,
  );
  assert.equal(
    (await app()(event("/health", "{}", { "content-type": "text/plain" })))
      .statusCode,
    415,
  );
  const invalid = event("/health", "/w==", {
    "content-type": "application/json",
  });
  invalid.isBase64Encoded = true;
  assert.equal((await app()(invalid)).statusCode, 400);
});
test("health rejects JSON bodies and query strings; parser validates future explicit DTOs", async () => {
  assert.equal(
    (
      await app()(
        event("/health", "{}", { "content-type": "application/json" }),
      )
    ).statusCode,
    400,
  );
  const input = event();
  input.rawQueryString = "email=private";
  assert.equal((await app()(input)).statusCode, 400);
  assert.deepEqual(
    parseJson(
      event("/future", '{"count":2}', {
        "Content-Type": "application/json; charset=utf-8",
      }),
      100,
    ),
    { count: 2 },
  );
  const schema = z.strictObject({ count: z.number().int() });
  assert.throws(() => validateInput(schema, { count: 2, email: "private" }));
  assert.deepEqual(validateInput(schema, { count: 2 }), { count: 2 });
});
test("size limit uses actual bytes, including base64, regardless of content-length", async () => {
  const handler = createHandler({
    config: () => readConfig({ APP_ENV: "test", MAX_BODY_BYTES: "8" }),
    ready: async () => true,
    logger: () => {},
  });
  assert.equal(
    (
      await handler(
        event("/health", '"éééé"', {
          "content-type": "application/json",
          "content-length": "1",
        }),
      )
    ).statusCode,
    413,
  );
  const input = event("/health", Buffer.from("123456789").toString("base64"), {
    "content-type": "application/json",
  });
  input.isBase64Encoded = true;
  assert.equal((await handler(input)).statusCode, 413);
  input.body = "***";
  assert.equal((await handler(input)).statusCode, 400);
});
test("correlation IDs are generated, unique, logged and returned; inbound values ignored", async () => {
  const records: LogRecord[] = [];
  const handler = createHandler({
    config,
    ready: async () => true,
    logger: (r) => records.push(r),
  });
  const input = event("/health", undefined, {
    "x-correlation-id": "private@example.com",
  });
  const first = await handler(input);
  const second = await handler(input);
  assert.match(first.headers["x-correlation-id"], /^[0-9a-f-]{36}$/);
  assert.notEqual(
    first.headers["x-correlation-id"],
    second.headers["x-correlation-id"],
  );
  assert.equal(records[0]?.correlationId, first.headers["x-correlation-id"]);
});
test("logger drops arbitrary properties and rejects unsafe values in allowed fields", () => {
  const lines: string[] = [];
  const logger = createLogger((line) => lines.push(line));
  const valid: LogRecord = {
    severity: "info",
    correlationId: "7518891f-f3e0-4e28-bd6c-a7f153c65fa7",
    route: "GET /health",
    status: 200,
    latencyMs: 1,
    category: "request_complete",
  };
  logger({
    ...valid,
    body: { email: "sentinel", weight: 70 },
    authorization: "sentinel",
    error: new Error("sentinel"),
  } as LogRecord);
  logger({ ...valid, route: "sentinel" } as unknown as LogRecord);
  assert.equal(lines.length, 1);
  assert.doesNotMatch(lines[0]!, /sentinel|weight|authorization|body|error/);
});
test("unmatched route logs contain no raw URL, query, headers, body or error", async () => {
  const lines: string[] = [];
  const handler = createHandler({
    config,
    ready: async () => true,
    logger: createLogger((line) => lines.push(line)),
  });
  const input = event("/sentinel@example.com", '{"food":"sentinel"}', {
    "content-type": "application/json",
    authorization: "sentinel",
  });
  input.rawQueryString = "sentinel";
  await handler(input);
  assert.equal(JSON.parse(lines[0]!).route, "unmatched");
  assert.doesNotMatch(lines.join(""), /sentinel|food|authorization/);
});
test("logging sink failures do not change response", async () => {
  const handler = createHandler({
    config,
    ready: async () => true,
    logger: () => {
      throw Error("sink");
    },
  });
  assert.equal((await handler(event())).statusCode, 200);
});
test("configuration rejects missing environment, unsafe cloud/local mode and missing IAM TLS", () => {
  for (const value of [
    {},
    {
      APP_ENV: "production",
      DB_MODE: "local",
      DB_HOST: "localhost",
      DB_NAME: "noryva",
      DB_USER: "api",
      DB_PASSWORD: "sentinel",
    },
    { APP_ENV: "test", MAX_BODY_BYTES: "NaN" },
    {
      APP_ENV: "staging",
      DB_MODE: "iam",
      DB_HOST: "host",
      DB_NAME: "noryva",
      DB_USER: "api",
    },
  ]) {
    assert.throws(
      () => readConfig(value),
      /^Error: Invalid application configuration$/,
    );
  }
  assert.equal(config().DB_MODE, "disabled");
  assert.equal(
    readConfig({
      APP_ENV: "staging",
      DB_MODE: "iam",
      DB_HOST: "host",
      DB_NAME: "noryva",
      DB_USER: "noryva_api",
      AWS_REGION: "eu-west-2",
      DB_CA_FILE: "/ca.pem",
    }).DB_MODE,
    "iam",
  );
});
