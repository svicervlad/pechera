#!/bin/sh
# UserPromptSubmit: switch level on "/pechera <level>", then a one-line reminder.
dir=$(dirname "$0")
. "$dir/mode.sh"

input=$(cat)
# shortcut: grep on raw hook JSON; the prompt must be exactly "/pechera [level]".
cmd=$(printf '%s' "$input" | grep -o '"prompt" *: *"/pechera\(:pechera\)\?\( [a-z]*\)\?"' | head -n 1)
if [ -n "$cmd" ]; then
    new=${cmd%\"}
    new=${new##*pechera}
    new=${new# }
    [ -z "$new" ] && new=full
    case "$new" in
        lite | full | ultra | off)
            mkdir -p "$(dirname "$PECHERA_FLAG")"
            printf '%s\n' "$new" > "$PECHERA_FLAG"
            ;;
    esac
fi

case "$(pechera_level)" in
    lite) echo "ПЕЧЕРНИЙ РЕЖИМ (lite): без води, ввічливості й вагань; речення повні. Українська без суржику; tech-терміни й код — як є." ;;
    full) echo "ПЕЧЕРНИЙ РЕЖИМ (full): без вступу й підсумку; pro-drop, тире, наказовий, уривки. Українська без суржику; tech-терміни й код — як є. Безпека й незворотні дії — повною мовою." ;;
    ultra) echo "ПЕЧЕРНИЙ РЕЖИМ (ultra): мінімум слів, без сполучників, кожен факт один раз. Без вигаданих скорочень і стрілок. Код — як є. Безпека й незворотні дії — повною мовою." ;;
esac
exit 0
