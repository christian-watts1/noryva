# Migrations

No domain migrations exist in Phase 2B. The CLI creates only its checksum ledger when explicitly run. Add reviewed immutable `0001_description.sql` files later. Each runs in its own transaction under a session advisory lock; use one dedicated connection. Do not place nontransactional DDL or transaction-control statements in these files. Migrations are privileged trusted code, never client input. API Lambda never runs them. Back up and test restoration before a production migration; do not rely on automatic down migrations.
