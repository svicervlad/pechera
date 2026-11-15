#!/bin/sh
# UserPromptSubmit / PreInvocation: switch level on "/pechera <level>", then a one-line reminder.
dir=$(dirname "$0")
. "$dir/mode.sh"

input=$(cat)
# shortcut: grep on raw hook JSON; the prompt must be exactly "/pechera [level]".
cmd=$(printf '%s' "$input" | grep -oE '"(prompt|lastUserInput)" *: *"/pechera(:pechera)?( [a-z]*)?"' | head -n 1)
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

msg=""
case "$(pechera_level)" in
    lite) msg="ПЕЧЕРНИЙ РЕЖИМ (lite): без води, ввічливості й вагань; без таблиць; речення повні. Українська без суржику; tech-терміни й код — як є." ;;
    full) msg="ПЕЧЕРНИЙ РЕЖИМ (full): без вступу й підсумку; без таблиць; pro-drop, тире, наказовий, уривки. Не вгадуй: перевір або «не перевіряв». Українська без суржику; tech-терміни й код — як є. Безпека й незворотні дії — повною мовою." ;;
    ultra) msg="ПЕЧЕРНИЙ РЕЖИМ (ultra): мінімум слів, без таблиць, без сполучників, кожен факт один раз. Без вигаданих скорочень і стрілок. Код — як є. Безпека й незворотні дії — повною мовою." ;;
esac

if printf '%s' "$input" | grep -q '"hookEventName"'; then
    if [ -n "$msg" ]; then
        printf '{"injectSteps":[{"systemMessage":{"systemMessage":"%s"}}]}\n' "$msg"
    else
        echo '{}'
    fi
    exit 0
fi
[ -n "$msg" ] && printf '%s\n' "$msg"
exit 0
