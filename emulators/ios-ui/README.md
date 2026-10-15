# iOS simulator

Use this folder to start an iOS simulator for the `appleUI/` app.

## Prerequisites

- Xcode installed
- An iPhone or iPad simulator available in Xcode

## Start the simulator

From PowerShell:

```powershell
cd "<repo>/emulators/ios-ui"
./start-simulator.ps1
```

Optional: pass a simulator name explicitly.

```powershell
./start-simulator.ps1 -DeviceName "iPhone 15"
```

## Common setup

List available simulators:

```powershell
xcrun simctl list devices available
```
