#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
usage:
  phkit.sh sync
  phkit.sh list
  phkit.sh init <template> [target_dir] [--rules a,b] [--claude-pointer] [--force]
EOF
}

cmd_sync() {
  local targets=(
    "$HOME/.codex/AGENTS.md"
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.gemini/GEMINI.md"
    "$HOME/.config/opencode/AGENTS.md"
  )

  for dest in "${targets[@]}"; do
    mkdir -p "$(dirname "$dest")"
    cp "$REPO_ROOT/AGENTS.md" "$dest"
    echo "synced AGENTS.md -> $dest"
  done

  local skill_roots=(
    "$HOME/.agents/skills"
    "$HOME/.claude/skills"
    "$HOME/.codex/skills"
  )

  for root in "${skill_roots[@]}"; do
    mkdir -p "$root"
    for dir in "$REPO_ROOT"/skills/*/; do
      local name
      name="$(basename "$dir")"
      rm -rf "$root/$name"
      cp -R "$dir" "$root/$name"
    done
    echo "synced skills -> $root"
  done
}

cmd_list() {
  echo "templates:"
  for f in "$REPO_ROOT"/templates/*.md; do
    echo "  $(basename "$f" .md)"
  done
  echo "rules:"
  for f in "$REPO_ROOT"/rules/*.md; do
    echo "  $(basename "$f" .md)"
  done
  echo "skills:"
  for d in "$REPO_ROOT"/skills/*/; do
    echo "  $(basename "$d")"
  done
}

cmd_init() {
  local template="${1:-general}"
  shift || true

  local target="."
  local rules=""
  local claude_pointer=0
  local force=0

  if [[ $# -gt 0 && "$1" != --* ]]; then
    target="$1"
    shift
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --rules)
        rules="${2:-}"
        shift 2
        ;;
      --claude-pointer)
        claude_pointer=1
        shift
        ;;
      --force)
        force=1
        shift
        ;;
      *)
        echo "unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  local template_path="$REPO_ROOT/templates/$template.md"
  if [[ ! -f "$template_path" ]]; then
    echo "unknown template '$template'" >&2
    exit 1
  fi

  mkdir -p "$target"
  local out_path="$target/AGENTS.md"
  if [[ -f "$out_path" && "$force" -ne 1 ]]; then
    echo "$out_path already exists. pass --force to overwrite." >&2
    exit 1
  fi

  cp "$template_path" "$out_path"

  if [[ -n "$rules" ]]; then
    IFS=',' read -ra rule_list <<< "$rules"
    for raw in "${rule_list[@]}"; do
      local name
      name="$(echo "$raw" | xargs)"
      [[ -z "$name" ]] && continue
      local rule_path="$REPO_ROOT/rules/$name.md"
      if [[ ! -f "$rule_path" ]]; then
        echo "unknown rule '$name'" >&2
        exit 1
      fi
      printf '\n' >> "$out_path"
      cat "$rule_path" >> "$out_path"
    done
  fi

  echo "wrote $out_path"

  if [[ "$claude_pointer" -eq 1 ]]; then
    local claude_path="$target/CLAUDE.md"
    if [[ -f "$claude_path" && "$force" -ne 1 ]]; then
      echo "$claude_path already exists. pass --force to overwrite." >&2
      exit 1
    fi
    printf '@AGENTS.md\n' > "$claude_path"
    echo "wrote $claude_path"
  fi
}

case "${1:-}" in
  sync) cmd_sync ;;
  list) cmd_list ;;
  init) shift; cmd_init "$@" ;;
  *) usage; exit 1 ;;
esac
