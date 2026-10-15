# appleUI

The Apple-platform client (iOS first; iPadOS/macOS if the design allows).

## Status

This directory contains a native SwiftUI app project, Xcode project, and unit/UI tests. It is source
code, not a phone-installable package. Building and distributing it requires Xcode and Apple's
signing flow; no signed IPA, App Store listing, or TestFlight link is currently published.

Analyses are sent to the shared backend with the `ios` client label and saved there with the user
prompt. Set the `FOUNDEROS_API_BASE_URL` Xcode build setting to the backend origin; the checked-in
project defaults to the local simulator backend at `http://127.0.0.1:8000`.

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `androidUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.
