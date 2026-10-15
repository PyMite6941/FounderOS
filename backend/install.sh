#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

if command -v python3.11 >/dev/null 2>&1; then
    PYTHON=python3.11
elif command -v python3 >/dev/null 2>&1; then
    PYTHON=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON=python
else
    echo "Python 3.11 or newer is required. Install Python and rerun this script." >&2
    exit 1
fi

if ! "$PYTHON" -c 'import sys; raise SystemExit(sys.version_info < (3, 11))'; then
    echo "Python 3.11 or newer is required." >&2
    exit 1
fi

"$PYTHON" -m venv .venv
.venv/bin/python -m pip install -r requirements-dev.txt

echo "Backend dependencies installed. Start the API with: .venv/bin/python -m uvicorn app.main:app --reload --port 8000"