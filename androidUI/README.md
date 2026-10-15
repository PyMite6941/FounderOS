# androidUI
The Android client.

## Status

Kotlin source files are present under `app/src/main/java`. This directory is currently source code,
not a buildable or installable Android app: it has no Gradle project, wrapper, manifest, or app
entry point. No APK is published yet.

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `appleUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.

## CI/CD

The workflow at `.github/workflows/android-ci.yml` is not currently wired to this source tree: it
expects a root-level Gradle project and wrapper that are not present. Its artifact upload action is
also deprecated. It has not produced an installable APK release.