param(
    [string]$DeviceName = "iPhone 15"
)

$ErrorActionPreference = "Stop"

if (-not $IsMacOS) {
    Write-Error "iOS Simulator requires macOS with Xcode installed."
    exit 1
}

$simulators = & xcrun simctl list devices available 2>$null
if (-not $simulators) {
    Write-Error "No iOS simulators are available. Install Xcode and at least one simulator runtime."
    exit 1
}

$deviceFound = $false
foreach ($line in ($simulators -split "`n")) {
    if ($line -match "\b$([regex]::Escape($DeviceName))\b") {
        $deviceFound = $true
        break
    }
}

if (-not $deviceFound) {
    Write-Host "Requested simulator '$DeviceName' was not found. Available devices:"
    $simulators | ForEach-Object { Write-Host $_ }
    exit 1
}

Write-Host "Booting iOS simulator: $DeviceName"
& xcrun simctl boot "$DeviceName"
& open -a Simulator
