#!/usr/bin/env bash
set -euo pipefail

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but was not found on PATH." >&2
  exit 1
fi

skill_names=(
  apple-platform-router
  oslog-debugging
  swiftui-accessibility-identifiers
  mvvm-c-architecture
  swiftui-expert-skill
  swift-concurrency
  swift-testing-expert
  factory-dependency-injection
  swiftui-pro
  swiftui-performance-audit
)

skill_sources=(
  mstroshin/agent-skills
  mstroshin/agent-skills
  mstroshin/agent-skills
  mstroshin/agent-skills
  avdlee/swiftui-agent-skill
  avdlee/swift-concurrency-agent-skill
  avdlee/swift-testing-agent-skill
  hmlongco/Factory
  twostraws/swiftui-agent-skill
  dimillian/skills
)

skill_groups=(
  own
  own
  own
  own
  recommended
  recommended
  recommended
  recommended
  optional
  optional
)

skill_full_depth=(
  false
  false
  false
  false
  false
  false
  false
  true
  false
  false
)

print_menu() {
  cat <<'MENU'
Select skills to install.

Own skills:
  1) apple-platform-router
  2) oslog-debugging
  3) swiftui-accessibility-identifiers
  4) mvvm-c-architecture

Recommended external skills:
  5) swiftui-expert-skill
  6) swift-concurrency
  7) swift-testing-expert
  8) factory-dependency-injection

Optional external skills:
  9) swiftui-pro
  10) swiftui-performance-audit

Shortcuts: all, own, external, recommended, optional
Example: 1 2 5 8
MENU
}

add_index_once() {
  local idx="$1"
  local existing
  for existing in "${selected_indices[@]:-}"; do
    if [[ "$existing" == "$idx" ]]; then
      return 0
    fi
  done
  selected_indices+=("$idx")
}

select_group() {
  local group="$1"
  local i
  for i in "${!skill_names[@]}"; do
    case "$group" in
      all)
        add_index_once "$i"
        ;;
      external)
        if [[ "${skill_groups[$i]}" != "own" ]]; then
          add_index_once "$i"
        fi
        ;;
      *)
        if [[ "${skill_groups[$i]}" == "$group" ]]; then
          add_index_once "$i"
        fi
        ;;
    esac
  done
}

parse_selection() {
  local selection="$1"
  local token idx
  selected_indices=()

  for token in $selection; do
    case "$token" in
      all|own|external|recommended|optional)
        select_group "$token"
        ;;
      ''|*[!0-9]*)
        echo "Error: unknown selection token '$token'." >&2
        exit 1
        ;;
      *)
        if (( token < 1 || token > ${#skill_names[@]} )); then
          echo "Error: selection number '$token' is out of range." >&2
          exit 1
        fi
        idx=$((token - 1))
        add_index_once "$idx"
        ;;
    esac
  done

  if (( ${#selected_indices[@]} == 0 )); then
    echo "Error: no skills selected." >&2
    exit 1
  fi
}

print_command() {
  local arg
  for arg in "$@"; do
    printf '%q ' "$arg"
  done
  printf '\n'
}

build_command() {
  local idx="$1"
  command_args=(npx skills add "${skill_sources[$idx]}" --skill "${skill_names[$idx]}")

  if [[ "${skill_full_depth[$idx]}" == true ]]; then
    command_args+=(--full-depth)
  fi

  if [[ "$scope" == global ]]; then
    command_args+=(-g)
  fi

  if (( ${#agent_args[@]} > 0 )); then
    command_args+=(-a "${agent_args[@]}")
  fi

  command_args+=(-y)
}

print_menu
printf '\nSelect skills by number, or use shortcuts: '
IFS= read -r selection
parse_selection "$selection"

cat <<'SCOPE'

Install scope:
  1) Project
  2) Global
SCOPE
printf 'Scope: '
IFS= read -r scope_choice
case "$scope_choice" in
  1) scope=project ;;
  2) scope=global ;;
  *) echo "Error: invalid scope '$scope_choice'." >&2; exit 1 ;;
esac

cat <<'AGENTS'

Agent selection:
  1) Default
  2) All agents (--agent '*')
  3) Custom agents
AGENTS
printf 'Agent selection: '
IFS= read -r agent_choice
agent_args=()
case "$agent_choice" in
  1)
    ;;
  2)
    agent_args=("*")
    ;;
  3)
    printf 'Enter agents separated by spaces, e.g. claude-code cursor: '
    IFS= read -r custom_agents
    if [[ -z "${custom_agents// }" ]]; then
      echo "Error: custom agent selection cannot be empty." >&2
      exit 1
    fi
    read -r -a agent_args <<< "$custom_agents"
    ;;
  *)
    echo "Error: invalid agent selection '$agent_choice'." >&2
    exit 1
    ;;
esac

printf '\nCommands to run:\n'
for idx in "${selected_indices[@]}"; do
  build_command "$idx"
  print_command "${command_args[@]}"
done

printf '\nProceed? [y/N] '
IFS= read -r confirm
case "$confirm" in
  y|Y|yes|YES)
    ;;
  *)
    echo "Cancelled."
    exit 0
    ;;
esac

for idx in "${selected_indices[@]}"; do
  build_command "$idx"
  "${command_args[@]}"
done

echo "Selected skills installed."
