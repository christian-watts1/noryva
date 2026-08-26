# Data model

Schema version: **1**. Dates are UTC ISO-8601 text; canonical body and serving measurements are metric.

- `profile`: generated anonymous UUID, creation time, onboarding completion/progress, goal/body/activity inputs, and the complete calculated target snapshot.
- `foods`: provenance-ready identity, optional brand/barcode, source and verification status, macronutrients plus fibre/sugar/salt per 100 g, optional serving metadata, and timestamps.
- `diary_entries`: user and optional food references, food/brand/serving snapshots, meal, quantity, seven nutrient snapshots, and audit timestamps.

The initial database seeds 30 original development/demo food records. `verified` means internally reviewed demo data, not legal, regulatory, or manufacturer certification. Nutrients are extensible by adding columns/tables in an explicit future migration; diary snapshots remain authoritative historical values.

Reset deletes profile and diary rows transactionally, creates a new random local identity, and preserves the installed demo catalogue.
