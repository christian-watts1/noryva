export type ErrorCode =
  | "unauthorized"
  | "bad_request"
  | "unsupported_media_type"
  | "payload_too_large"
  | "not_found"
  | "unavailable"
  | "internal_error";
const status: Record<ErrorCode, number> = {
  unauthorized: 401,
  bad_request: 400,
  unsupported_media_type: 415,
  payload_too_large: 413,
  not_found: 404,
  unavailable: 503,
  internal_error: 500,
};
export class AppError extends Error {
  constructor(public readonly code: ErrorCode) {
    super(code);
  }
  get status(): number {
    return status[this.code];
  }
}
export function safeError(error: unknown): AppError {
  return error instanceof AppError ? error : new AppError("internal_error");
}
