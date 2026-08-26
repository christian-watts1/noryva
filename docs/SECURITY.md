# Security

The Phase 1 trust boundary is the application process and its private local SQLite storage. There is no authentication, remote API, network trust boundary, or required secret. No credentials, signing keys, or environment secrets belong in the repository.

Data minimisation is applied: no name, device identifier, advertising identifier, permissions, or unrelated health signal is collected. Input ranges are validated, database success precedes UI success, errors shown to users omit stack traces, and deletion is confirmation-gated.

Future authentication would establish identity/session and account-migration boundaries. Future cloud sync would establish transport, API authorisation, conflict, encryption, and server-storage boundaries. Those boundaries are documented only and are not implemented.
