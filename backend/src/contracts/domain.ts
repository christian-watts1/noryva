import { z } from "zod";
export const uuid = z.uuid();
export const version = z.number().int().min(1).max(Number.MAX_SAFE_INTEGER);
const timestamp = z.iso.datetime({ offset: true });
const amount = z.number().finite().min(0).max(100000);
// INTERNAL boundary only. Parsing proves shape, never authentication. No HTTP route
// accepts this object. A future verifier must resolve these IDs from trusted identity.
export const verifiedPrincipalSchema = z
  .strictObject({ accountId: uuid, deviceId: uuid })
  .brand<"VerifiedPrincipal">();
export type VerifiedPrincipal = z.infer<typeof verifiedPrincipalSchema>;
export const fitnessProfileSchema = z
  .strictObject({
    calculationSex: z.enum(["male", "female"]),
    heightCm: z.number().min(120).max(230),
    weightKg: z.number().min(35).max(350),
    activity: z.enum(["low", "light", "moderate", "high"]),
    goal: z.enum([
      "loseWeight",
      "maintainWeight",
      "gainWeight",
      "buildMuscle",
      "improveFitness",
      "trackNutrition",
    ]),
    goalWeightKg: z.number().min(35).max(350).nullable(),
    rateKgPerWeek: z
      .union([z.literal(0.25), z.literal(0.5), z.literal(0.75)])
      .nullable(),
    bmr: amount,
    maintenanceCalories: amount,
    dailyCalories: amount,
    goalAdjustment: z.number().finite().min(-10000).max(10000),
    proteinG: amount,
    carbohydrateG: amount,
    fatG: amount,
    wasClamped: z.boolean(),
    algorithmVersion: z.literal("mifflin-st-jeor-v1"),
    heightUnit: z.enum(["cm", "ftIn"]),
    weightUnit: z.enum(["kg", "lb", "stLb"]),
  })
  .refine(
    (p) =>
      !["loseWeight", "gainWeight"].includes(p.goal) ||
      p.rateKgPerWeek !== null,
    { message: "Goal rate required" },
  );
export const diarySnapshotSchema = z.strictObject({
  id: uuid,
  meal: z.enum(["breakfast", "lunch", "dinner", "snack"]),
  loggedAt: timestamp,
  quantity: z.number().positive().max(100000),
  servingDescription: z.string().min(1).max(200),
  basisUnit: z.enum(["g", "ml", "serving"]),
  foodName: z.string().min(1).max(200),
  brand: z.string().max(200).nullable(),
  calories: amount,
  proteinG: amount,
  carbohydrateG: amount,
  fatG: amount,
  fibreG: amount,
  sugarG: amount,
  saltG: amount,
});
export const syncMetadataSchema = z.strictObject({
  epoch: version,
  version,
  revision: version,
  createdAt: timestamp,
  updatedAt: timestamp,
});
export const tombstoneSchema = z.strictObject({
  id: uuid,
  entity: z.enum(["fitness_profile", "diary_entry"]),
  epoch: version,
  version,
  revision: version,
  deletedAt: timestamp,
});
export const deviceRegistrationSchema = z.strictObject({
  devicePublicId: uuid,
  platform: z.enum(["android", "ios"]),
  osMajor: z.number().int().min(1).max(999),
  appVersion: z.string().regex(/^\d{1,3}\.\d{1,3}\.\d{1,3}$/),
});
export const jobTypeSchema = z.enum([
  "export",
  "cloud_delete",
  "account_delete",
]);
export const jobRequestSchema = z.strictObject({ jobType: jobTypeSchema });
export const jobStatusSchema = z.strictObject({
  id: uuid,
  jobType: jobTypeSchema,
  status: z.enum(["pending", "running", "succeeded", "failed"]),
  attempts: z.number().int().min(0).max(10),
  createdAt: timestamp,
  completedAt: timestamp.nullable(),
});
export const errorCodeSchema = z.enum([
  "transient_failure",
  "dependency_unavailable",
  "attempts_exhausted",
]);
// Client mutations supply an expected version, never an accepted server version.
export const profileMutationSchema = z.strictObject({
  baseVersion: z.number().int().min(0).max(Number.MAX_SAFE_INTEGER),
  profile: fitnessProfileSchema,
});
export const diaryMutationSchema = z.strictObject({
  baseVersion: z.number().int().min(0).max(Number.MAX_SAFE_INTEGER),
  snapshot: diarySnapshotSchema,
});
