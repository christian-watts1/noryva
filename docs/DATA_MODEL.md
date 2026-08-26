# Data model

Schema version: **2**. Dates are UTC ISO-8601 text; canonical body and serving measurements are metric.

- `profile`: generated anonymous UUID, creation time, onboarding completion/progress, goal/body/activity inputs, and the complete calculated target snapshot.
- `foods`: provenance-ready identity, optional brand/barcode, source and verification status, macronutrients plus fibre/sugar/salt per 100 canonical units, mass/volume basis, and timestamps.
- `food_servings`: multiple labels per food with display quantity/unit and conversion to the food's canonical grams or millilitres. Nutrition is derived from `foods`, not duplicated.
- `diary_entries`: user and optional food references, food/brand/serving snapshots, meal, quantity, seven nutrient snapshots, and audit timestamps.

Version 1 → 2 adds `foods.basis_unit` with a safe `g` default and creates `food_servings`; it does not recreate or clear user tables. An automated migration test opens a real version 1 SQLite file and verifies the profile and historical diary snapshot survive.

The initial database seeds 30 original development/demo food records. `verified` means internally reviewed demo data, not legal, regulatory, or manufacturer certification. Nutrients are extensible by adding columns/tables in an explicit future migration; diary snapshots remain authoritative historical values.

Reset deletes profile and diary rows transactionally, creates a new random local identity, and preserves the installed demo catalogue.
