import { test } from "node:test";
import assert from "node:assert/strict";
import { randomUUID } from "node:crypto";
import {
  verifiedPrincipalSchema,
  fitnessProfileSchema,
  diarySnapshotSchema,
  syncMetadataSchema,
  tombstoneSchema,
  deviceRegistrationSchema,
  jobRequestSchema,
  jobStatusSchema,
  profileMutationSchema,
  diaryMutationSchema,
} from "../src/contracts/domain.js";
const profile = {
  calculationSex: "female",
  heightCm: 170,
  weightKg: 70,
  activity: "low",
  goal: "maintainWeight",
  goalWeightKg: null,
  rateKgPerWeek: null,
  bmr: 1400,
  maintenanceCalories: 1680,
  dailyCalories: 1680,
  goalAdjustment: 0,
  proteinG: 112,
  carbohydrateG: 180,
  fatG: 56,
  wasClamped: false,
  algorithmVersion: "mifflin-st-jeor-v1",
  heightUnit: "cm",
  weightUnit: "kg",
};
const diary = {
  id: randomUUID(),
  meal: "lunch",
  loggedAt: "2026-09-09T12:00:00Z",
  quantity: 100,
  servingDescription: "100 g",
  basisUnit: "g",
  foodName: "Synthetic oats",
  brand: null,
  calories: 100,
  proteinG: 3,
  carbohydrateG: 15,
  fatG: 4,
  fibreG: 2,
  sugarG: 1,
  saltG: 0.1,
};
const metadata = {
  epoch: 1,
  version: 1,
  revision: 1,
  createdAt: "2026-09-09T12:00:00Z",
  updatedAt: "2026-09-09T12:00:00Z",
};
test("profile and diary contracts accept bounded snapshots without recalculating", () => {
  assert.deepEqual(fitnessProfileSchema.parse(profile), profile);
  assert.deepEqual(diarySnapshotSchema.parse(diary), diary);
  profileMutationSchema.parse({ baseVersion: 0, profile });
  diaryMutationSchema.parse({ baseVersion: 1, snapshot: diary });
});
test("strict DTOs reject ownership, DOB, email, search, analytics and nested overposting", () => {
  for (const [schema, value] of [
    [fitnessProfileSchema, profile],
    [diarySnapshotSchema, diary],
  ] as const) {
    for (const key of [
      "account_id",
      "accountId",
      "email",
      "dob",
      "dateOfBirth",
      "age",
      "bodyDraft",
      "searchTerms",
      "analytics",
      "token",
      "createdAt",
      "version",
    ])
      assert.equal(
        schema.safeParse({ ...value, [key]: "forbidden" }).success,
        false,
      );
  }
  assert.equal(
    profileMutationSchema.safeParse({
      baseVersion: 1,
      profile: { ...profile, dob: "1990-01-01" },
    }).success,
    false,
  );
  assert.equal(
    diaryMutationSchema.safeParse({
      baseVersion: 1,
      snapshot: diary,
      accountId: randomUUID(),
    }).success,
    false,
  );
});
test("principal validates internal UUIDs only; parsing is not auth", () => {
  verifiedPrincipalSchema.parse({
    accountId: randomUUID(),
    deviceId: randomUUID(),
  });
  for (const accountId of ["invalid", "';SET ROLE admin;--", ""])
    assert.equal(
      verifiedPrincipalSchema.safeParse({ accountId, deviceId: randomUUID() })
        .success,
      false,
    );
  assert.equal(
    verifiedPrincipalSchema.safeParse({
      accountId: randomUUID(),
      deviceId: randomUUID(),
      role: "admin",
    }).success,
    false,
  );
});
test("metadata, tombstones and device registration are explicit", () => {
  syncMetadataSchema.parse(metadata);
  tombstoneSchema.parse({
    id: randomUUID(),
    entity: "diary_entry",
    epoch: 1,
    version: 2,
    revision: 3,
    deletedAt: metadata.updatedAt,
  });
  deviceRegistrationSchema.parse({
    devicePublicId: randomUUID(),
    platform: "android",
    osMajor: 16,
    appVersion: "1.0.0",
  });
  assert.equal(
    deviceRegistrationSchema.safeParse({
      devicePublicId: randomUUID(),
      platform: "android",
      osMajor: 16,
      appVersion: "1.0.0",
      accountId: randomUUID(),
    }).success,
    false,
  );
  for (const version of [0, -1, 1.5, Number.MAX_SAFE_INTEGER + 1, "1", NaN])
    assert.equal(
      syncMetadataSchema.safeParse({ ...metadata, version }).success,
      false,
    );
  assert.equal(
    tombstoneSchema.safeParse({
      id: randomUUID(),
      entity: "diary_entry",
      epoch: 1,
      version: 2,
      revision: 3,
      deletedAt: metadata.updatedAt,
      foodName: "forbidden",
    }).success,
    false,
  );
});
test("invalid finite quantities, goals and snapshot IDs are rejected", () => {
  for (const value of [NaN, Infinity, -1, 100001])
    assert.equal(
      diarySnapshotSchema.safeParse({ ...diary, calories: value }).success,
      false,
    );
  assert.equal(
    diarySnapshotSchema.safeParse({ ...diary, id: "not-a-uuid" }).success,
    false,
  );
  assert.equal(
    fitnessProfileSchema.safeParse({
      ...profile,
      goal: "loseWeight",
      rateKgPerWeek: null,
    }).success,
    false,
  );
  assert.equal(
    fitnessProfileSchema.safeParse({ ...profile, weightKg: 351 }).success,
    false,
  );
  assert.equal(
    profileMutationSchema.safeParse({ baseVersion: -1, profile }).success,
    false,
  );
});
test("job requests contain type only; status is server output", () => {
  jobRequestSchema.parse({ jobType: "export" });
  for (const input of [
    { jobType: "analytics" },
    { jobType: "export", account_id: randomUUID() },
    { jobType: "export", status: "succeeded" },
    { jobType: "export", last_error: "health payload" },
  ])
    assert.equal(jobRequestSchema.safeParse(input).success, false);
  const status = {
    id: randomUUID(),
    jobType: "export",
    status: "pending",
    attempts: 0,
    createdAt: metadata.createdAt,
    completedAt: null,
  };
  jobStatusSchema.parse(status);
  assert.equal(
    jobStatusSchema.safeParse({ ...status, status: "unknown" }).success,
    false,
  );
  assert.equal(
    jobStatusSchema.safeParse({ ...status, attempts: -1 }).success,
    false,
  );
});
