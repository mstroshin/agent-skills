#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/install-selected.sh"

assert_contains() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq "$expected" "$file"; then
    echo "Expected to find: $expected" >&2
    echo "Actual file:" >&2
    cat "$file" >&2
    exit 1
  fi
}

run_installer() {
  local input="$1"
  local log_file="$2"
  local tmpdir
  tmpdir="$(mktemp -d)"
  cat > "$tmpdir/npx" <<'NPX'
#!/usr/bin/env bash
{
  for arg in "$@"; do
    printf '<%s>' "$arg"
  done
  printf '\n'
} >> "$NPX_LOG"
NPX
  chmod +x "$tmpdir/npx"
  PATH="$tmpdir:$PATH" NPX_LOG="$log_file" bash "$SCRIPT" <<< "$input" >/tmp/install-selected-test-output.txt 2>/tmp/install-selected-test-error.txt
}

test_own_global_all_agents() {
  local log
  log="$(mktemp)"
  run_installer $'own\n2\n2\ny\n' "$log"

  assert_contains "$log" '<skills><add><mstroshin/agent-skills><--skill><apple-platform-router><-g><-a><*><-y>'
  assert_contains "$log" '<skills><add><mstroshin/agent-skills><--skill><oslog-debugging><-g><-a><*><-y>'
  assert_contains "$log" '<skills><add><mstroshin/agent-skills><--skill><swiftui-accessibility-identifiers><-g><-a><*><-y>'
  assert_contains "$log" '<skills><add><mstroshin/agent-skills><--skill><mvvm-c-architecture><-g><-a><*><-y>'
}

test_specific_external_project_custom_agents() {
  local log
  log="$(mktemp)"
  run_installer $'5 8\n1\n3\nclaude-code cursor\ny\n' "$log"

  assert_contains "$log" '<skills><add><avdlee/swiftui-agent-skill><--skill><swiftui-expert-skill><-a><claude-code><cursor><-y>'
  assert_contains "$log" '<skills><add><hmlongco/Factory><--skill><factory-dependency-injection><--full-depth><-a><claude-code><cursor><-y>'
}

test_cancel_does_not_install() {
  local log
  log="$(mktemp)"
  run_installer $'all\n1\n1\nn\n' "$log"

  if [ -s "$log" ]; then
    echo "Expected no commands after cancellation" >&2
    cat "$log" >&2
    exit 1
  fi
}

test_invalid_selection_fails() {
  local log
  log="$(mktemp)"
  if run_installer $'99\n1\n1\ny\n' "$log"; then
    echo "Expected invalid selection to fail" >&2
    exit 1
  fi
}

test_own_global_all_agents
test_specific_external_project_custom_agents
test_cancel_does_not_install
test_invalid_selection_fails

echo "install-selected tests passed"
