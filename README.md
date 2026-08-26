# Noryva

**Track less. Know more.** Noryva is a local-first nutrition and fitness mobile application. Phase 1 implements anonymous, account-free onboarding, explainable energy targets, local food search, and a persistent nutrition diary.

## Repository

- `apps/mobile` — Flutter application
- `docs` — product, architecture, privacy, security, data, decisions, and testing notes
- `.github/workflows` — analysis and test CI

## Setup

Install a current stable Flutter SDK, then:

```sh
cd apps/mobile
flutter pub get
flutter run
```

No code generation is required. Validate with:

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Phase 1 has no account, backend, cloud sync, integrations, AI, analytics, advertising, payments, or web application. See [PRODUCT.md](docs/PRODUCT.md) for the complete boundary.

Licensing is undecided, so this repository intentionally has no `LICENSE` file.
