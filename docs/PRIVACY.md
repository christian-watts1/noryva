# Phase 1 technical privacy notes

Phase 1 creates one random anonymous UUID locally. It stores onboarding body/goal/activity information, calculated targets, and nutrition diary entries in the application's on-device SQLite database.

No Phase 1 health or nutrition data is transmitted remotely. The application has no API, cloud sync, analytics SDK, advertising SDK or identifier, IP collection, device fingerprinting, location, contacts, microphone, camera, or health-platform access.

`Reset local data` deletes the local profile and diary and creates a fresh anonymous identity. The bundled development food catalogue remains. This document describes technical behaviour and is not a production legal privacy policy.
