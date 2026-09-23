#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

fail=0
while IFS= read -r file; do
  case "$file" in
    *.terraform.lock.hcl) continue ;;
  esac
  lines="$(wc -l < "$file" | tr -d ' ')"
  if [ "$lines" -ge 200 ]; then
    echo "$file has $lines lines (limit 199)"
    fail=1
  fi
done < <(find . \( -path './.git' -o -path '*/.terraform' -o -path '*/.terraform-plugin-cache' \) -prune -o -type f \( \
  -name '*.tf' -o -name '*.hcl' -o -name '*.sh' -o \
  -name '*.yml' -o -name '*.yaml' -o -name '*.md' \
  \) -print)

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "file length check passed"
