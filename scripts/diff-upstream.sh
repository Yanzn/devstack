#!/usr/bin/env bash
# diff-upstream.sh — compare current upstream pins (docs/origins.md) against
# latest upstream releases. Flags new commits and changed skill files so you
# can decide what to port into devstack.
#
# Usage:
#   scripts/diff-upstream.sh              # markdown report to stdout
#   scripts/diff-upstream.sh --json       # machine-readable JSON
#   scripts/diff-upstream.sh --quiet      # exit 0 if up-to-date, 1 if drift
#
# Requires: gh (authenticated), jq

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MODE="markdown"
QUIET=0
for arg in "$@"; do
  case "$arg" in
    --json)  MODE="json" ;;
    --quiet) QUIET=1 ;;
    -h|--help)
      sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

command -v gh >/dev/null || { echo "gh required" >&2; exit 2; }
command -v jq >/dev/null || { echo "jq required" >&2; exit 2; }

# upstream token → "owner/repo" (parallel arrays for bash 3.2 compat)
UPSTREAM_NAMES=("Superpowers" "agent-skills")
UPSTREAM_REPOS=("obra/superpowers" "addyosmani/agent-skills")

# Parse pinned version from docs/origins.md table.
# Row format: | <Upstream> | <Version> | <Date> | <URL> |
parse_pin() {
  local name="$1"
  awk -v k="$name" -F'|' '
    /^\| *'"$name"' *\|/ {
      gsub(/^ +| +$/, "", $3); print $3; exit
    }
  ' docs/origins.md
}

# Default branch name.
default_branch() {
  gh api "repos/$1" --jq .default_branch 2>/dev/null || echo ""
}

# Latest release tag (informational; may lag the default branch).
latest_release() {
  local t
  t=$(gh api "repos/$1/releases/latest" --jq .tag_name 2>/dev/null || true)
  [[ -z "$t" || "$t" == "null" ]] && t=$(gh api "repos/$1/tags?per_page=1" --jq '.[0].name' 2>/dev/null || true)
  [[ "$t" == "null" ]] && t=""
  echo "$t"
}

# Compare two refs on a repo → JSON with ahead_by, commits, files.
# Returns '{}' if the compare call fails (e.g. pin ref does not exist).
compare_refs() {
  local out
  if out=$(gh api "repos/$1/compare/$2...$3" 2>/dev/null); then
    echo "$out"
  else
    echo '{}'
  fi
}

# Per-skill pins from SKILL.md `<upstream>:<name> @ <version>` lines.
skill_pins() {
  local upstream="$1"
  grep -rHn -E "^[[:space:]]*-[[:space:]]+${upstream}:[A-Za-z0-9_-]+[[:space:]]+@[[:space:]]+[^[:space:]]+" \
    skills/ 2>/dev/null \
    | sed -E "s|:[[:space:]]*-[[:space:]]+${upstream}:([A-Za-z0-9_-]+)[[:space:]]+@[[:space:]]+([^[:space:]]+).*|\t\1\t\2|" \
    || true
}

drift=0
json_upstreams='[]'

for i in "${!UPSTREAM_NAMES[@]}"; do
  name="${UPSTREAM_NAMES[$i]}"
  repo="${UPSTREAM_REPOS[$i]}"
  pin=$(parse_pin "$name")
  branch=$(default_branch "$repo")
  release=$(latest_release "$repo")

  if [[ -z "$pin" ]]; then
    echo "WARN: no pin found for $name in docs/origins.md" >&2
    continue
  fi
  if [[ -z "$branch" ]]; then
    echo "WARN: could not resolve default branch for $repo" >&2
    continue
  fi

  cmp_json=$(compare_refs "$repo" "$pin" "$branch")
  # Fallback: try with 'v' prefix if the bare version didn't resolve.
  if [[ "$cmp_json" == "{}" && "$pin" != v* ]]; then
    cmp_json=$(compare_refs "$repo" "v$pin" "$branch")
    [[ "$cmp_json" != "{}" ]] && pin="v$pin"
  fi
  ahead=$(jq -r '.ahead_by // 0' <<<"$cmp_json")
  behind=$(jq -r '.behind_by // 0' <<<"$cmp_json")
  files_json=$(jq '[.files[]? | {path: .filename, status, changes}]' <<<"$cmp_json")

  if [[ "$ahead" == "0" && "$behind" == "0" && "$cmp_json" != "{}" ]]; then
    status="up-to-date"
  elif [[ "$cmp_json" == "{}" ]]; then
    status="pin-unresolved"
    drift=1
  else
    status="drift"
    drift=1
  fi
  latest="$release"

  # Per-skill pins for this upstream.
  pins_tsv=$(skill_pins "$name")
  if [[ -n "$pins_tsv" ]]; then
    pins_json=$(jq -Rn --arg tsv "$pins_tsv" '
      [ $tsv | split("\n") | .[] | select(length>0) | split("\t")
        | {file: .[0], skill: .[1], pin: .[2]} ]')
  else
    pins_json='[]'
  fi

  entry=$(jq -n \
    --arg name "$name" --arg repo "$repo" --arg branch "$branch" \
    --arg pin "$pin" --arg latest "$latest" --arg status "$status" \
    --argjson ahead "$ahead" --argjson behind "$behind" \
    --argjson files "$files_json" --argjson skill_pins "$pins_json" \
    '{name:$name, repo:$repo, default_branch:$branch, pin:$pin, latest_release:$latest, status:$status, ahead_by:$ahead, behind_by:$behind, changed_files:$files, skill_pins:$skill_pins}')
  json_upstreams=$(jq --argjson e "$entry" '. + [$e]' <<<"$json_upstreams")
done

if [[ "$MODE" == "json" ]]; then
  jq -n --argjson u "$json_upstreams" --argjson drift "$drift" \
    '{generated_at: now | todate, drift: ($drift == 1), upstreams: $u}'
  exit $drift
fi

if [[ "$QUIET" == "1" ]]; then
  exit $drift
fi

# Markdown report
printf "# Upstream Diff Report\n\n"
printf "_Generated %s_\n\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if [[ "$drift" == "0" ]]; then
  printf "All upstreams up-to-date.\n\n"
fi

jq -r '.[] |
  "## \(.name) (\(.repo))\n\n" +
  "- pinned: `\(.pin)`\n" +
  "- latest release: `\(.latest_release // "—")`\n" +
  "- default branch: `\(.default_branch)` (ahead \(.ahead_by), behind \(.behind_by))\n" +
  "- status: **\(.status)**\n" +
  (if (.changed_files | length) > 0 then
    "\n### Changed files\n\n" +
    (["| file | status | changes |", "|---|---|---|"] +
     (.changed_files | map("| `\(.path)` | \(.status) | \(.changes) |")) | join("\n")) + "\n"
  elif .status == "pin-unresolved" then
    "\n> Pin ref could not be resolved on upstream. Check spelling in `docs/origins.md` or that the tag still exists.\n"
  else "" end)
' <<<"$json_upstreams"

# Per-skill pin table
printf "\n## Per-skill pins\n\n"
printf "| upstream | skill | pinned @ | file |\n|---|---|---|---|\n"
jq -r '.[] | . as $u | .skill_pins[]? | "| \($u.name) | \(.skill) | \(.pin) | \(.file) |"' <<<"$json_upstreams"

exit $drift
