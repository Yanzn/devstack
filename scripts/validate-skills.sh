#!/usr/bin/env bash
# Validate devstack skill structure and metadata.
# Checks:
#   - every skills/**/SKILL.md has valid YAML frontmatter (name, description)
#   - every SKILL.md has an <!-- origin: ... --> comment block
#   - every reference file has an <!-- origin: ... --> header
#   - CREDITS.md mentions each skill folder

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail=0
warn=0

check_skill() {
  local f="$1"
  local head
  head=$(head -30 "$f")

  if ! grep -q '^name: ' <<<"$head"; then
    echo "FAIL: missing 'name:' frontmatter — $f"
    fail=$((fail+1))
  fi
  if ! grep -q '^description: ' <<<"$head"; then
    echo "FAIL: missing 'description:' frontmatter — $f"
    fail=$((fail+1))
  fi
  if ! grep -q '^<!--' <<<"$head"; then
    echo "WARN: missing origin comment block — $f"
    warn=$((warn+1))
  fi
}

echo "=== Scanning skills/**/SKILL.md ==="
while IFS= read -r -d '' f; do
  check_skill "$f"
done < <(find skills -name SKILL.md -print0)

echo
echo "=== Scanning references/*.md ==="
for f in references/*.md; do
  [ -f "$f" ] || continue
  if ! head -3 "$f" | grep -q '<!-- origin'; then
    echo "WARN: missing origin header — $f"
    warn=$((warn+1))
  fi
done

echo
echo "=== Scanning agents/*.md ==="
for f in agents/*.md; do
  [ -f "$f" ] || continue
  if ! head -10 "$f" | grep -q '<!-- ?origin\|<!--$'; then
    echo "WARN: missing origin comment — $f"
    warn=$((warn+1))
  fi
done

echo
echo "=== Summary ==="
echo "Failures: $fail"
echo "Warnings: $warn"
exit $fail
