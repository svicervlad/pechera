#!/bin/sh
# SessionStart: inject the full ruleset once (stdout becomes context).
dir=$(dirname "$0")
. "$dir/mode.sh"

input=$(cat)
lvl=$(pechera_level)
if printf '%s' "$input" | grep -q '"hookEventName"'; then
    [ "$lvl" = off ] && { echo '{}'; exit 0; }
    { cat "$dir/../rules.md"; printf '\nАКТИВНИЙ РІВЕНЬ: %s\n' "$lvl"; } |
        jq -Rs '{injectSteps:[{systemMessage:{systemMessage:.}}]}'
    exit 0
fi
[ "$lvl" = off ] && exit 0
cat "$dir/../rules.md"
printf '\nАКТИВНИЙ РІВЕНЬ: %s\n' "$lvl"
