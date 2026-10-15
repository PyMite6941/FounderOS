# androidUI
The Android client.

## Status

Android CI/CD pipeline configured. Backend API (`POST /v1/analyze`) is operational. Android app skeleton ready for Compose implementation.

## Open questions

- Native Kotlin + Jetpack Compose, or a cross-platform layer shared with `appleUI/`? → Will evaluate after initial Android MVP
- Minimum SDK level? → Targeting API 21 (Android 5.0) and up
- Phone only, or tablet layouts too? → Phone first, tablet adaptive layouts later
- Play Store distribution, or APK sideload for now? → Sideload for now, Play Store later

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `appleUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.

## CI/CD

GitHub Actions workflow at `.github/workflows/android-ci.yml` handles:
- CI: Build debug APK, run unit tests, lint checks, upload debug APK artifact
- CD: Build signed AAB for release, upload AAB artifact (requires keystore secrets)