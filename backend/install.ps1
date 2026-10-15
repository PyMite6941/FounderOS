$ErrorActionPreference = "Stop"
$backendPath = $PSScriptRoot
$venvPath = Join-Path $backendPath ".venv"

$pythonCommand = Get-Command py -ErrorAction SilentlyContinue
if ($null -ne $pythonCommand) {
    try {
        & $pythonCommand.Source -3.11 --version *> $null
        if ($LASTEXITCODE -eq 0) {
            $python = $pythonCommand.Source
            $pythonArgs = @("-3.11")
        }
    } catch {
    }
}

if (-not $python) {
    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if ($null -eq $pythonCommand) {
        throw "Python 3.11 or newer is required. Install Python and rerun this script."
    }
    $python = $pythonCommand.Source
    $pythonArgs = @()
}

$pythonVersion = & $python @pythonArgs -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
if ([version]$pythonVersion -lt [version]"3.11") {
    throw "Python 3.11 or newer is required; found Python $pythonVersion."
}

& $python @pythonArgs -m venv $venvPath
if ($LASTEXITCODE -ne 0) { throw "Could not create the virtual environment." }

$venvPython = Join-Path $venvPath "Scripts\python.exe"
& $venvPython -m pip install -r (Join-Path $backendPath "requirements-dev.txt")
if ($LASTEXITCODE -ne 0) { throw "Could not install backend dependencies." }

Write-Host "Backend dependencies installed. Start the API with: .\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000"