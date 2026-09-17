# androidUI

The Android client.

## Status

Empty. Stack not chosen (see the decisions table in the root `README.md`).

## Open questions

- Native Kotlin + Jetpack Compose, or a cross-platform layer shared with `appleUI/`?
- Minimum SDK level?
- Phone only, or tablet layouts too?
- Play Store distribution, or APK sideload for now?

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `appleUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.
