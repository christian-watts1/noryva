# Decisions

1. **No licence guessed.** Licensing remains undecided; `LICENSE` is omitted as required.
2. **No generated Drift model.** Phase 1 uses Drift's `NativeDatabase` executor with explicit, parameterised SQL. This retains Drift/SQLite, removes a build-runner step, and keeps schema/migrations legible for the small schema.
3. **Canonical units.** Height, body weight, food quantity, and goal rate are stored as centimetres, kilograms, grams, and kilograms/week. Imperial display can be added without rewriting stored values.
4. **Energy safety.** Mifflin–St Jeor uses activity multipliers 1.2, 1.375, 1.55, and 1.725. Weight change uses 7,700 kcal/kg divided across seven days; muscle building uses a modest 200 kcal/day surplus. Daily targets floor at 1,500 kcal for male calculation sex and 1,200 kcal for female calculation sex and expose the clamp reason. These are estimates, not medical advice.
5. **Macros.** Protein is 1.6 g/kg (1.8 for gain/build-muscle), fat is 0.8 g/kg, and carbohydrate receives remaining calories at 4 kcal/g. Values retain precision and presentation rounds them.
6. **Local date query.** Phase 1 records UTC timestamps and constructs day bounds from the selected local calendar date. This is simple and maintainable, but travel/time-zone history may need an explicit local-date column in a later migration.
7. **Food verification wording.** Seed foods use `source=noryva_demo_seed_v1` and `verified` to demonstrate the state; UI and documentation explicitly identify them as development data rather than certified records.
