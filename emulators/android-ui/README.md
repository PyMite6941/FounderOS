# Android emulator

Use this folder to start an Android emulator for the `androidUI/` app.

## Prerequisites

- Android Studio installed
- Android SDK with platform tools + emulator
- At least one Android Virtual Device (AVD) created

## Start the emulator

From PowerShell:

```powershell
.\start-emulator.ps1
```

Without an argument, the script starts the first AVD listed by the Android SDK.
Pass a device name to select a specific AVD.

```powershell
.\start-emulator.ps1 -DeviceName "Pixel_6_API_34"
```

From macOS or Linux with Bash:

```bash
bash ./start-emulator.sh
```

Without an argument, the script starts the first AVD listed by the Android SDK.
Pass an AVD name as the first argument to select a specific one.

```bash
bash ./start-emulator.sh "Pixel_6_API_34"
```

## Common setup

If you do not have an AVD yet, create one with Android Studio or use:

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n "FounderOS" -k "system-images;android-34;google_apis;x86_64" -d "pixel_6"
```

Then launch the emulator with either script in this folder.
