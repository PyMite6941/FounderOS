# appleUI

The Apple-platform client (iOS first; iPadOS/macOS if the design allows).

## Status

This directory contains a native SwiftUI app project, Xcode project, and unit/UI tests. It is source
code, not a phone-installable package. Building and distributing it requires Xcode and Apple's
signing flow; no signed IPA, App Store listing, or TestFlight link is currently published.

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `androidUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.
