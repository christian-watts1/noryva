# Testing

- Unit tests assert exact BMR, activity, goal adjustment, safety floor, macros, invalid inputs, and serving scaling.
- Database tests use a real temporary SQLite file and reopen it to prove identity, partial/completed onboarding, target, diary create/edit/delete, snapshot stability, reset, and seed persistence.
- The persistence test exercises the journey's domain/data path from a fresh database through weight-loss state, calculated target persistence, chicken lookup, 150 g lunch logging, totals, and reopen.
- Widget/platform integration is intentionally kept separate from durable database assertions. A platform integration test should be added when Flutter device tooling is available.

Commands:

```sh
cd apps/mobile
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```
