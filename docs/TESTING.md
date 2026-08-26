# Testing

- Unit tests assert exact BMR, activity, goal adjustment, safety floor, macros, invalid inputs, mass serving scaling, unit servings, and volume servings.
- Database tests use a real temporary SQLite file and reopen it to prove identity, partial/completed onboarding, targets, diary create/edit/delete, snapshot stability, reset, seed/serving persistence, case-insensitive search, and real recent-food ranking.
- A migration test builds a version 1 SQLite database and verifies its profile and diary snapshot after the supported version 2 migration.
- The persistence test exercises the journey's domain/data path from a fresh database through weight-loss state, calculated target persistence, chicken lookup, 150 g lunch logging, totals, and reopen.
- A Flutter widget journey completes onboarding, logs 150 g chicken to lunch, verifies the rounded UI and precise database value, closes/reopens the real SQLite file, rebuilds the provider/application tree, and verifies onboarding bypass and diary persistence.
- Accessibility smoke coverage enables semantics and 160% text scaling. Physical-device screen-reader, switch-control, and very-large-font testing remain device QA work.

Commands:

```sh
cd apps/mobile
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```
