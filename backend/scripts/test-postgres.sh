#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# PostgreSQL 17 is the same supported major as the planned RDS engine.
# Patch updates intentionally follow the official 17 image; never use latest.
engine="${CONTAINER_ENGINE:-}"
if [[ -z "$engine" ]]; then
  if command -v podman >/dev/null; then engine=podman; else engine=docker; fi
fi
container="noryva-pg-test-$$-$RANDOM"
cleanup() { "$engine" rm -f -v "$container" >/dev/null 2>&1 || true; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
"$engine" run --detach --rm --name "$container" --publish 127.0.0.1::5432 \
  --tmpfs /var/lib/postgresql/data:rw \
  -e POSTGRES_PASSWORD=noryva-disposable-only -e POSTGRES_DB=noryva_test \
  docker.io/library/postgres:17 \
  -c log_statement=none -c log_min_error_statement=panic -c log_parameter_max_length_on_error=0 >/dev/null
ready=false
for _ in {1..60}; do
  if "$engine" exec "$container" pg_isready -h 127.0.0.1 -U postgres -d noryva_test >/dev/null 2>&1; then ready=true; break; fi
  sleep 1
done
if [[ "$ready" != true ]]; then echo 'Disposable PostgreSQL failed readiness check' >&2; exit 1; fi
port="$("$engine" port "$container" 5432/tcp)"
export PG_TEST_PORT="${port##*:}"
export PG_TEST_PASSWORD=noryva-disposable-only
timeout 180s npm run test:integration:run
