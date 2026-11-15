#!/bin/sh
# Self-check for the hooks. Run: sh test.sh
set -u
cd "$(dirname "$0")"
export CLAUDE_CONFIG_DIR=$(mktemp -d)
trap 'rm -rf "$CLAUDE_CONFIG_DIR"' EXIT
fail=0
flag="$CLAUDE_CONFIG_DIR/.pechera-mode"

check() { # name, condition result
    if [ "$2" = 0 ]; then echo "ok   $1"; else echo "FAIL $1"; fail=1; fi
}
prompt() { printf '{"session_id":"t","prompt":"%s"}' "$1" | sh hooks/prompt.sh; }

out=$(prompt "привіт"); echo "$out" | grep -q '(full)'; check "default level is full" $?
[ ! -e "$flag" ]; check "plain prompt writes no flag" $?

prompt "/pechera ultra" >/dev/null; [ "$(cat "$flag")" = ultra ]; check "/pechera ultra sets ultra" $?
out=$(prompt "далі"); echo "$out" | grep -q '(ultra)'; check "level persists" $?

prompt "/pechera:pechera lite" >/dev/null; [ "$(cat "$flag")" = lite ]; check "namespaced command works" $?
prompt "/pechera bogus" >/dev/null; [ "$(cat "$flag")" = lite ]; check "unknown level ignored" $?
prompt "скажи що таке /pechera off" >/dev/null; [ "$(cat "$flag")" = lite ]; check "mid-text command ignored" $?
prompt "/pecherax" >/dev/null; [ "$(cat "$flag")" = lite ]; check "/pecherax is not the command" $?
prompt "/pechera" >/dev/null; [ "$(cat "$flag")" = full ]; check "bare /pechera means full" $?

prompt "/pechera off" >/dev/null; out=$(prompt "x"); [ -z "$out" ]; check "off prints no reminder" $?
out=$(sh hooks/session-start.sh </dev/null); [ -z "$out" ]; check "off: session start silent" $?

prompt "/pechera full" >/dev/null
out=$(sh hooks/session-start.sh </dev/null); echo "$out" | grep -q 'АКТИВНИЙ РІВЕНЬ: full'; check "session start injects rules" $?

echo "garbage" > "$flag"; out=$(prompt "x"); echo "$out" | grep -q '(full)'; check "corrupt flag falls back to full" $?

exit $fail
