#!/bin/sh
# Shared: path of the level flag and the current level (default: full).
PECHERA_FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.pechera-mode"

pechera_level() {
    lvl=$(cat "$PECHERA_FLAG" 2>/dev/null)
    case "$lvl" in
        lite | full | ultra | off) printf '%s' "$lvl" ;;
        *) printf 'full' ;;
    esac
}
