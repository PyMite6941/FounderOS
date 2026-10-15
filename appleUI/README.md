# appleUI
The Apple-platform client (iOS first; iPadOS/macOS if the design allows).

## Status
This directory contains a native SwiftUI app project, Xcode project, and unit/UI tests. It is source
code, not a phone-installable package. Building and distributing it requires Xcode and Apple's
signing flow; no signed IPA, App Store listing, or TestFlight link is currently published.

The app uses `FOUNDEROS_API_BASE_URL` Xcode build setting to configure the backend origin; the
checked-in project defaults to the local simulator backend at `http://127.0.0.1:8000`.

## Build & Run
- Xcode project: `appleUI/FoundersOS.xcodeproj/`
- SwiftUI app entry: `FoundersOSApp.swift`
- Run iOS simulator: `cd emulators/ios-ui && .\start-simulator.ps1` (macOS PowerShell) or `bash ./start-simulator.sh` (macOS Terminal)
- iOS simulator: `iPhone 15` (or first simulator listed by `xcrun simctl`)
- Build debug: Xcode > Product > Archive, then distribute to App Store/TestFlight

For TestFlight distribution, when you have access to macOS with Xcode:
1. Register the bundle identifier `com.isabellawu.foundersos` in the Apple Developer portal
2. Create a Distribution certificate and Provisioning Profile for App Store/TestFlight
3. Archive the app in Xcode and upload to App Store Connect
4. Add builds to TestFlight for external testing

## Rules
- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `androidUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.

## CI/CD
The Xcode project uses `project.yml` for build configuration:
- Bundle identifier: `com.isabellawu.foundersos`
- Deployment target: iOS 17.0
- Code signing: Automatic style, Development team: `FXNYZLP43Q`
- Swift version: 5.9
- Generate empty directories: enabled

The `.github/workflows` CI workflow runs on `macos-15` and expects Xcode to be installed.