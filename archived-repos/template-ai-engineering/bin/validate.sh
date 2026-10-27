#!/usr/bin/env bash
#
# validate.sh — read-only sanity checks for the canonical sources.
#
# Catches the mistakes the generator can't, before they reach a harness:
#   - an agent references a skill/connection that doesn't exist
#   - a skill is missing its name/description frontmatter (so no agent would load it)
#   - an eval is missing a required field
#
# It changes nothing. Run it locally before a PR; CI runs it as a gate.
# Usage: bin/validate.sh

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
err() { echo "  ✗ $1" >&2; fail=1; }

# Print each item of a frontmatter list block, one per line. (Same parser the
# generator uses, kept in sync deliberately so validation matches projection.)
parse_list() {
  awk -v key="$2" '
    /^---[[:space:]]*$/ { fm = !fm; next }
    fm && $0 ~ "^" key ":[[:space:]]*$" { inlist = 1; next }
    fm && inlist {
      if ($0 ~ /^[[:space:]]+-[[:space:]]+/) {
        line = $0
        sub(/^[[:space:]]+-[[:space:]]+/, "", line)
        sub(/[[:space:]]*#.*$/, "", line)
        sub(/[[:space:]]+$/, "", line)
        if (line != "") print line
      } else if ($0 ~ /^[^[:space:]]/) { inlist = 0 }
    }
  ' "$1"
}

# Does a YAML frontmatter / file contain a top-level `key:` with a value?
has_key() { grep -Eq "^${2}:[[:space:]]*[^[:space:]]" "$1"; }

echo "Validating agents…"
for agent_md in "$REPO_ROOT"/agents/*/AGENT.md; do
  [ -e "$agent_md" ] || continue
  name="$(basename "$(dirname "$agent_md")")"
  has_key "$agent_md" name || err "agent '$name': missing 'name' in frontmatter"
  has_key "$agent_md" role || err "agent '$name': missing 'role' in frontmatter"
  while IFS= read -r skill; do
    [ -n "$skill" ] || continue
    [ -f "$REPO_ROOT/skills/$skill/SKILL.md" ] || err "agent '$name': references missing skill '$skill'"
  done < <(parse_list "$agent_md" skills)
  while IFS= read -r conn; do
    [ -n "$conn" ] || continue
    [ -f "$REPO_ROOT/connections/$conn.md" ] || err "agent '$name': references missing connection '$conn'"
  done < <(parse_list "$agent_md" connections)
done

echo "Validating skills…"
for skill_md in "$REPO_ROOT"/skills/*/SKILL.md; do
  [ -e "$skill_md" ] || continue
  name="$(basename "$(dirname "$skill_md")")"
  has_key "$skill_md" name || err "skill '$name': missing 'name' in frontmatter"
  has_key "$skill_md" description || err "skill '$name': missing 'description' in frontmatter"
done

echo "Validating connections…"
for conn_md in "$REPO_ROOT"/connections/*.md; do
  [ -e "$conn_md" ] || continue
  name="$(basename "$conn_md" .md)"
  has_key "$conn_md" name || err "connection '$name': missing 'name' in frontmatter"
  has_key "$conn_md" kind || err "connection '$name': missing 'kind' in frontmatter"
done

echo "Validating evals…"
for eval_yaml in "$REPO_ROOT"/agents/*/eval/*.eval.yaml; do
  [ -e "$eval_yaml" ] || continue
  rel="${eval_yaml#"$REPO_ROOT"/}"
  for field in name description prompt; do
    has_key "$eval_yaml" "$field" || err "eval '$rel': missing '$field'"
  done
  # `expect` is a list block (no value on the same line). Eval files have no `---`
  # frontmatter, so scan for the key and count the indented list items beneath it.
  grep -Eq '^expect:[[:space:]]*$' "$eval_yaml" || err "eval '$rel': missing 'expect:' block"
  items="$(awk '
    /^expect:[[:space:]]*$/ { inlist = 1; next }
    inlist && /^[[:space:]]+-[[:space:]]+/ { n++ }
    inlist && /^[^[:space:]]/ { inlist = 0 }
    END { print n + 0 }
  ' "$eval_yaml")"
  [ "$items" -gt 0 ] || err "eval '$rel': 'expect' has no assertions"
done

if [ "$fail" -ne 0 ]; then
  echo "validate: FAILED" >&2
  exit 1
fi
echo "validate: OK"
