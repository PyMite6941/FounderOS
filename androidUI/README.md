# androidUI
The Android client.

## Status
Kotlin source files are present under `app/src/main/java`. This directory is a buildable Android app:
- AndroidManifest.xml added with package `com.founderos.androidui`
- Resource values added (strings, colors, dimensions)
- MainActivity.kt added as Compose entry point
- Debug APK can be built with `./gradlew assembleDebug`

The analysis service posts to the shared backend and labels requests as `android`; the backend
persists the prompt and analysis together. Its default host, `10.0.2.2:8000`, is for the Android
emulator talking to a backend running on the development computer.

## Build & Run
- Build debug APK: `cd androidUI && ./gradlew assembleDebug`
- APK output: `androidUI/app/build/outputs/apk/debug/app-debug.apk`
- Run emulator: `cd emulators/android-ui && .\start-emulator.ps1` (Windows) or `bash ./start-emulator.sh` (macOS/Linux)
- Emulator AVD: `Medium_Phone_API_36.1` (or first AVD listed by SDK)

## Rules
- Talk to the backend only through the contract in `backend/README.md`.
- No business logic here that `appleUI/` would also need — that belongs in the backend.
- Secrets never get compiled into the app; they live server-side.

## CI/CD
The workflow at `.github/workflows/android-ci.yml` is not currently wired to this source tree: it
expects a root-level Gradle project and wrapper that are not present. Its artifact upload action is
also deprecated. It has not produced an installable APK release. To build and publish an APK:
1. Create a GitHub Release with an `.apk` asset from the debug build
2. Set `IOS_DISTRIBUTION_URL` in the backend `.env` for iOS TestFlight
3. Update the web UI `loadReleaseCatalog()` to fetch and display the releases