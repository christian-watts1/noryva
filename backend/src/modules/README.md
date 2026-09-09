# Future module boundaries

Reserved for identity mapping, profiles, sync, privacy, analytics and audit. No routes, tables, auth flows or implementations exist yet. Modules will use explicit DTO schemas and ownership checks, not expose generic CRUD. Identity maps verified provider subjects to internal UUIDs; email and local install IDs are not relational identifiers. Fitness DTOs must not require DOB. Excluding DOB does not prevent age inference from exact BMR/body inputs. Analytics will have a separate opt-in identity and strict property allow-list, never a join to authentication identity.
