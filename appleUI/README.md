# appleUI

The Apple-platform client (iOS first; iPadOS/macOS if the design allows).

## Status

Empty. Stack not chosen (see the decisions table in the root `README.md`).

## Open questions

- Native SwiftUI, or a cross-platform layer shared with `androidUI/`?
- Minimum iOS version?
- iPhone only, or iPad/Mac too?
- Does a Mac with Xcode exist for builds, or does this need a cloud build path?
- App Store distribution, or TestFlight/sideload for now?

## Rules

- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `androidUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.
