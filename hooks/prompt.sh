#!/bin/sh
# UserPromptSubmit / PreInvocation: switch level on "/pechera <level>", then a one-line reminder.
dir=$(dirname "$0")
. "$dir/mode.sh"

input=$(cat)
changed=0
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
            changed=1
            ;;
    esac
fi

if printf '%s' "$input" | grep -q '"hookEventName"'; then
    if [ "$changed" = 0 ]; then
        inv=$(printf '%s' "$input" | grep -oE '"invocationNum" *: *[0-9]+' | head -n 1 | tr -dc '0-9')
        if [ -n "$inv" ] && [ "$inv" -gt 1 ]; then
            echo '{}'
            exit 0
        fi
    fi
fi

msg=""
case "$(pechera_level)" in
    lite) msg="ПЕЧЕРНИЙ РЕЖИМ (lite): без води, ввічливості й вагань; без таблиць; речення повні. Українська без суржику; tech-терміни й код — як є." ;;
    full) msg="ПЕЧЕРНИЙ РЕЖИМ (full): одразу суть, без вступу, підсумку й таблиць; ясність вища за стиснення; без тексту між рутинними tool calls. Не вгадуй: перевір або «не перевіряв». Українська без суржику; tech-терміни й код — як є. Безпека, незворотні дії й питання — повною мовою." ;;
    ultra) msg="ПЕЧЕРНИЙ РЕЖИМ (ultra): мінімум слів, без таблиць, без сполучників, кожен факт один раз; ясність вища за стиснення. Без вигаданих скорочень і стрілок. Код — як є. Безпека, незворотні дії й питання — повною мовою." ;;
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
