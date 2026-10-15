param(
    [string]$DeviceName = ""
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$androidSdkRoot = $env:ANDROID_HOME

if (-not $androidSdkRoot) {
    $androidSdkRoot = Join-Path $env:LOCALAPPDATA "Android\Sdk"
}

$emulatorExe = Join-Path $androidSdkRoot "emulator\emulator.exe"

if (-not (Test-Path $emulatorExe)) {
    Write-Error "Android emulator not found. Install Android Studio + Android SDK and try again. Expected: $emulatorExe"
    exit 1
}

$avdList = & $emulatorExe -list-avds 2>$null
if (-not $avdList -or $avdList.Count -eq 0) {
    Write-Warning "No Android Virtual Devices were found. Create one in Android Studio first."
    Write-Host "Example: avdmanager create avd -n 'FounderOS' -k 'system-images;android-34;google_apis;x86_64' -d 'pixel_6'"
    exit 1
}

if (-not $DeviceName) {
    $DeviceName = $avdList[0].ToString().Trim()
    Write-Host "No AVD specified; using the first available device: $DeviceName"
}

if ($avdList -notcontains $DeviceName) {
    Write-Host "Requested device '$DeviceName' was not found. Available AVDs:"
    $avdList | ForEach-Object { Write-Host "  - $_" }
    exit 1
}

Write-Host "Launching Android emulator: $DeviceName"
& $emulatorExe -avd $DeviceName
