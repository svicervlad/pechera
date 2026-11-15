#!/bin/sh
# SessionStart: inject the full ruleset once (stdout becomes context).
dir=$(dirname "$0")
. "$dir/mode.sh"

lvl=$(pechera_level)
[ "$lvl" = off ] && exit 0
cat "$dir/../rules.md"
printf '\nАКТИВНИЙ РІВЕНЬ: %s\n' "$lvl"
