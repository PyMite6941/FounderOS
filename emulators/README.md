# Emulators
This folder keeps the local device runners for both app clients.

- `android-ui/` starts the Android emulator for `androidUI/`
- `ios-ui/` starts the iOS Simulator for `appleUI/`

## Android Emulator
### Platform
Windows PowerShell or macOS/Linux with Bash.

### Prerequisites
- Android Studio installed
- Android SDK with platform tools + emulator
- At least one Android Virtual Device (AVD) created

### Start the emulator
From PowerShell:
```powershell
.\start-emulator.ps1
```
Without an argument, the script starts the first AVD listed by the Android SDK.
Pass a device name to select a specific AVD:
```powershell
.\start-emulator.ps1 -DeviceName "Pixel_6_API_34"
```

From macOS or Linux with Bash:
```bash
bash ./start-emulator.sh
```
Without an argument, the script starts the first AVD listed by the Android SDK.
Pass an AVD name as the first argument to select a specific one:
```bash
bash ./start-emulator.sh "Pixel_6_API_34"
```

### Common setup
If you do not have an AVD yet, create one with Android Studio or use:
```powershell
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n "FounderOS" -k "system-images;android-34;google_apis;x86_64" -d "pixel_6"
```
Then launch the emulator with either script in this folder.

The Android emulator was successfully tested and launched `Medium_Phone_API_36.1` AVD.

---

### iOS Simulator
#### Platform
macOS with Xcode installed only. iOS Simulator cannot run on Windows or Linux.

##### From macOS PowerShell:
```powershell
.\start-simulator.ps1
```
Optional: pass a simulator name explicitly.
```powershell
.\start-simulator.ps1 -DeviceName "iPhone 15"
```

##### From macOS Terminal with Bash:
```bash
bash ./start-simulator.sh
```
Optional: pass a simulator name as the first argument.
```bash
bash ./start-simulator.sh "iPhone 15"
```

##### List available simulators:
```powershell
xcrun simctl list devices available
```

##### Common setup
iOS Simulator cannot run on Windows or Linux; a Mac with Xcode is required.

#### Install script
`emulators/ios-ui/install-on-ios.sh` - A runnable script that:
- Lists available iOS simulators via `xcrun simctl list devices available`
- Boots the first available iPhone 15 simulator (or specified device)
- Opens the Simulator app
- Provides instructions for TestFlight installation and emulator usage

The script was created to enable installing/testing on iOS from the web UI download buttons.