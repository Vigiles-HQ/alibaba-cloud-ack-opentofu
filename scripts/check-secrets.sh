#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

pattern='LTAI[A-Za-z0-9]{8,}|BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|xox[baprs]-|ghp_[A-Za-z0-9]{20,}'

if rg -n --glob '!.git/**' --glob '!**/.terraform/**' --glob '!scripts/check-secrets.sh' "$pattern" .; then
  echo "secret pattern matched"
  exit 1
fi

echo "secret pattern check passed"
