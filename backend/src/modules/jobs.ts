import { randomUUID } from "node:crypto";
import { z } from "zod";
import type { QueryExecutor } from "../database/client.js";
import {
  errorCodeSchema,
  jobRequestSchema,
  uuid,
} from "../contracts/domain.js";
// Use within a trusted account transaction. The DB chooses ownership from context.
export async function enqueueJob(
  db: QueryExecutor,
  request: unknown,
  maxAttempts = 3,
) {
  const input = jobRequestSchema.parse(request);
  z.number().int().min(1).max(10).parse(maxAttempts);
  return (
    await db.query(
      "INSERT INTO public.jobs(id, account_id, job_type, max_attempts) VALUES ($1, public.current_account_id(), $2, $3) RETURNING id",
      [randomUUID(), input.jobType, maxAttempts],
    )
  ).rows[0]!;
}
export async function claimJob(db: QueryExecutor, workerId: string) {
  uuid.parse(workerId);
  return (
    (
      await db.query(
        `WITH candidate AS (
    SELECT id FROM public.jobs WHERE status = 'pending' AND available_at <= clock_timestamp() AND attempts < max_attempts
    ORDER BY available_at, created_at, id FOR UPDATE SKIP LOCKED LIMIT 1
  ) UPDATE public.jobs j SET status = 'running', attempts = attempts + 1,
    locked_at = clock_timestamp(), locked_by = $1, updated_at = clock_timestamp()
    FROM candidate c WHERE j.id = c.id RETURNING j.id, j.attempts, j.locked_by`,
        [workerId],
      )
    ).rows[0] ?? null
  );
}
// attempts is a fencing token: even the same worker UUID cannot finish an old lease.
export async function finishJob(
  db: QueryExecutor,
  id: string,
  workerId: string,
  attempt: number,
  failure?: { code: z.infer<typeof errorCodeSchema>; delaySeconds: number },
) {
  uuid.parse(id);
  uuid.parse(workerId);
  z.number().int().min(1).max(10).parse(attempt);
  if (failure) {
    errorCodeSchema.parse(failure.code);
    z.number().int().min(1).max(86400).parse(failure.delaySeconds);
  }
  return (
    (
      await db.query(
        `UPDATE public.jobs SET
    status = CASE WHEN $4::text IS NULL THEN 'succeeded' WHEN attempts >= max_attempts THEN 'failed' ELSE 'pending' END,
    completed_at = CASE WHEN $4::text IS NULL OR attempts >= max_attempts THEN clock_timestamp() ELSE NULL END,
    available_at = clock_timestamp() + $5 * interval '1 second',
    last_error_code = $4, locked_at = NULL, locked_by = NULL, updated_at = clock_timestamp()
    WHERE id = $1 AND locked_by = $2 AND attempts = $3 AND status = 'running' RETURNING id, status`,
        [
          id,
          workerId,
          attempt,
          failure?.code ?? null,
          failure?.delaySeconds ?? 0,
        ],
      )
    ).rows[0] ?? null
  );
}
// Crashed leases are retried with a bounded attempt count. Future external effects
// must be idempotent; a lease is not an exactly-once side-effect guarantee.
export async function recoverExpiredJobs(
  db: QueryExecutor,
  leaseSeconds = 300,
) {
  z.number().int().min(30).max(3600).parse(leaseSeconds);
  return db.query(
    `UPDATE public.jobs SET status = CASE WHEN attempts >= max_attempts THEN 'failed' ELSE 'pending' END,
    completed_at = CASE WHEN attempts >= max_attempts THEN clock_timestamp() ELSE NULL END,
    last_error_code = 'dependency_unavailable', locked_at = NULL, locked_by = NULL,
    available_at = clock_timestamp(), updated_at = clock_timestamp()
    WHERE status = 'running' AND locked_at < clock_timestamp() - $1 * interval '1 second' RETURNING id`,
    [leaseSeconds],
  );
}
