#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_skills=(
  apple-platform-router
  oslog-debugging
  swiftui-accessibility-identifiers
  mvvm-c-architecture
)

for skill in "${required_skills[@]}"; do
  file="skills/$skill/SKILL.md"
  test -f "$file" || { echo "Missing $file" >&2; exit 1; }
  grep -q '^---$' "$file" || { echo "Missing YAML fence in $file" >&2; exit 1; }
  grep -q "^name: $skill$" "$file" || { echo "Missing exact name for $skill" >&2; exit 1; }
  grep -q '^description: Use when' "$file" || { echo "Description must start with Use when in $file" >&2; exit 1; }
  grep -q '^## Overview' "$file" || { echo "Missing Overview in $file" >&2; exit 1; }
  grep -q '^## When to Use' "$file" || { echo "Missing When to Use in $file" >&2; exit 1; }
  grep -q '^## Quick Reference' "$file" || { echo "Missing Quick Reference in $file" >&2; exit 1; }
  grep -q '^## Common Mistakes' "$file" || { echo "Missing Common Mistakes in $file" >&2; exit 1; }
done

for required in README.md LICENSE references/install-recipes.md references/recommended-external-skills.md quality/skill-scenarios.md tests/install-selected-test.sh; do
  test -f "$required" || { echo "Missing $required" >&2; exit 1; }
done

test -x scripts/install-selected.sh || { echo "scripts/install-selected.sh must be executable" >&2; exit 1; }
test -x tests/install-selected-test.sh || { echo "tests/install-selected-test.sh must be executable" >&2; exit 1; }

grep -q 'npx skills add mstroshin/agent-skills --skill apple-platform-router' README.md
grep -q 'npx skills add mstroshin/agent-skills --skill oslog-debugging' README.md
grep -q 'npx skills add mstroshin/agent-skills --skill swiftui-accessibility-identifiers' README.md
grep -q 'npx skills add mstroshin/agent-skills --skill mvvm-c-architecture' README.md
grep -q 'npx skills add hmlongco/Factory --skill factory-dependency-injection --full-depth' README.md
grep -q 'scripts/install-selected.sh' README.md
grep -q 'scripts/install-selected.sh' references/install-recipes.md

bash -n scripts/install-selected.sh
bash -n tests/install-selected-test.sh

test ! -d .agents || { echo "Do not vendor local .agents skills" >&2; exit 1; }
test ! -d .claude || { echo "Do not vendor local .claude skills" >&2; exit 1; }

echo "Validation passed"
