#!/bin/sh
set -eu

CODEX_CONFIG="${CODEX_CONFIG:-$HOME/.codex/config.toml}"

mkdir -p "$(dirname "$CODEX_CONFIG")"
touch "$CODEX_CONFIG"

tmp=$(mktemp "${TMPDIR:-/tmp}/codex-config.XXXXXX")

awk '
BEGIN {
  in_tui = 0
  seen_tui = 0
  wrote_managed = 0
  skip_value = 0
}

function is_section(line) {
  return line ~ /^\[[^]]+\][[:space:]]*$/
}

function print_managed() {
  print "# Managed by tomkenta/dotfiles. Keep local Codex state, MCP, and plugin settings elsewhere in this file."
  print "status_line = [\"model-with-reasoning\", \"context-remaining\", \"current-dir\", \"git-branch\"]"
  print "terminal_title = [\"project\", \"git-branch\", \"status\"]"
  wrote_managed = 1
}

{
  if (skip_value) {
    if ($0 ~ /\]/) {
      skip_value = 0
    }
    next
  }

  if ($0 ~ /^\[tui\][[:space:]]*$/) {
    print
    in_tui = 1
    seen_tui = 1
    wrote_managed = 0
    next
  }

  if (in_tui && is_section($0)) {
    if (!wrote_managed) {
      print_managed()
    }
    in_tui = 0
  }

  if (in_tui && $0 ~ /^[[:space:]]*# Managed by tomkenta\/dotfiles\./) {
    next
  }

  if (in_tui && $0 ~ /^[[:space:]]*(status_line|terminal_title)[[:space:]]*=/) {
    if ($0 ~ /\[[[:space:]]*$/ && $0 !~ /\]/) {
      skip_value = 1
    }
    next
  }

  print
}

END {
  if (in_tui && !wrote_managed) {
    print_managed()
  }

  if (!seen_tui) {
    print ""
    print "[tui]"
    print_managed()
  }
}
' "$CODEX_CONFIG" > "$tmp"

mv "$tmp" "$CODEX_CONFIG"
echo "Updated $CODEX_CONFIG"
