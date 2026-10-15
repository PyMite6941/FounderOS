# iOS simulator

Use this folder to start an iOS simulator for the `appleUI/` app.

## Prerequisites

- Xcode installed
- An iPhone or iPad simulator available in Xcode

## Start the simulator

From macOS PowerShell:

```powershell
.\start-simulator.ps1
```

Optional: pass a simulator name explicitly.

```powershell
.\start-simulator.ps1 -DeviceName "iPhone 15"
```

From macOS Terminal with Bash:

```bash
bash ./start-simulator.sh
```

Optional: pass a simulator name as the first argument.

```bash
bash ./start-simulator.sh "iPhone 15"
```

## Common setup

List available simulators:

```powershell
xcrun simctl list devices available
```

iOS Simulator cannot run on Windows or Linux; a Mac with Xcode is required.
