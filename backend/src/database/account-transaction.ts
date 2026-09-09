import type pg from "pg";
import {
  verifiedPrincipalSchema,
  type VerifiedPrincipal,
} from "../contracts/domain.js";
import type { QueryExecutor } from "./client.js";
export async function withAccountTransaction<T>(
  pool: pg.Pool,
  principal: VerifiedPrincipal,
  callback: (client: QueryExecutor) => Promise<T>,
): Promise<T> {
  const context = verifiedPrincipalSchema.parse(principal);
  const client = await pool.connect();
  let destroy = false;
  try {
    await client.query("BEGIN");
    await client.query("SELECT set_config('app.account_id', $1, true)", [
      context.accountId,
    ]);
    // The common gate gives future mutations a consistent lock order.
    const gate = await client.query(
      "SELECT account_id FROM public.sync_state WHERE account_id = $1 FOR UPDATE",
      [context.accountId],
    );
    const active = await client.query(
      "SELECT a.id FROM public.accounts a JOIN public.devices d ON d.account_id = a.id WHERE a.id = $1 AND d.id = $2 AND a.status = 'active' AND a.deleted_at IS NULL AND d.revoked_at IS NULL",
      [context.accountId, context.deviceId],
    );
    if (gate.rowCount !== 1 || active.rowCount !== 1)
      throw new Error("Account context unavailable");
    const result = await callback(client);
    await client.query("COMMIT");
    return result;
  } catch (error) {
    try {
      await client.query("ROLLBACK");
    } catch {
      destroy = true;
    }
    throw error;
  } finally {
    // SET LOCAL expires on commit/rollback. Also erase any accidental session GUC
    // written by trusted callback code; discard the connection if cleanup fails.
    try {
      await client.query("RESET app.account_id");
    } catch {
      destroy = true;
    }
    client.release(destroy);
  }
}
