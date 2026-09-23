#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

"$root/scripts/check-file-length.sh"
"$root/scripts/check-secrets.sh"

forbidden="$(find . \( -path './.git' -o -path '*/.terraform' -o -path '*/.terraform-plugin-cache' \) -prune -o -type f \( \
  -name 'terraform.tfstate' -o -name 'terraform.tfstate.backup' -o \
  -name '*.tfplan' -o -name 'plan.out' -o -name 'plan.json' -o -name 'plan.bin' -o \
  -name 'crash.log' -o -name '*.pem' -o -name '*.key' -o \
  -name 'kubeconfig' -o -name 'kubeconfig.*' -o -name '.env' -o -name '.env.*' \
  \) -print)"

if [ -n "$forbidden" ]; then
  echo "forbidden file present:"
  echo "$forbidden"
  exit 1
fi

tofu fmt -check -recursive

while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts tests -type f -name '*.sh' | sort)

while IFS= read -r dir; do
  echo "validate $dir"
  (
    cd "$dir"
    tofu init -backend=false -input=false
    tofu validate
  )
done < <(find modules examples bootstrap -path '*/.terraform' -prune -o -type f -name '*.tf' -print | while IFS= read -r file; do dirname "$file"; done | sort -u)

if find . -path './.git' -prune -o -type f -name 'tests.tftest.hcl' -print | grep -q .; then
  tofu test
fi

"$root/tests/test-contracts.sh"
echo "validation passed"
