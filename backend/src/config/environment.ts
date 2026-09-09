import { z } from "zod";

const schema = z
  .object({
    APP_ENV: z.enum(["local", "test", "staging", "production"]),
    DB_MODE: z.enum(["disabled", "local", "iam"]).default("disabled"),
    MAX_BODY_BYTES: z.coerce.number().int().min(1).max(131072).default(16384),
    DB_HOST: z.string().min(1).optional(),
    DB_PORT: z.coerce.number().int().min(1).max(65535).default(5432),
    DB_NAME: z
      .string()
      .regex(/^[a-z][a-z0-9_]*$/)
      .optional(),
    DB_USER: z
      .string()
      .regex(/^[a-z][a-z0-9_]*$/)
      .optional(),
    DB_PASSWORD: z.string().min(1).optional(),
    AWS_REGION: z.literal("eu-west-2").optional(),
    DB_CA_FILE: z.string().min(1).optional(),
  })
  .superRefine((value, ctx) => {
    const invalid = () =>
      ctx.addIssue({
        code: "custom",
        message: "Invalid database configuration",
      });
    if (
      value.DB_MODE !== "disabled" &&
      (!value.DB_HOST || !value.DB_NAME || !value.DB_USER)
    )
      invalid();
    if (
      value.DB_MODE === "local" &&
      (!["local", "test"].includes(value.APP_ENV) ||
        !["localhost", "127.0.0.1", "::1"].includes(value.DB_HOST ?? "") ||
        !value.DB_PASSWORD)
    )
      invalid();
    if (
      value.DB_MODE === "iam" &&
      (!value.AWS_REGION || !value.DB_CA_FILE || value.DB_PASSWORD)
    )
      invalid();
  });
export type Config = z.infer<typeof schema>;
export function readConfig(env: NodeJS.ProcessEnv): Config {
  const parsed = schema.safeParse(env);
  // Never expose Zod input, environment values or validation details in logs/errors.
  if (!parsed.success) throw new Error("Invalid application configuration");
  return parsed.data;
}
