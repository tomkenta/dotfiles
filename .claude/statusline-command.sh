#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
[ -n "$cwd" ] && printf "%s" "$cwd"
