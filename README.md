# pechera

Печерний режим українською для Claude Code: стислі відповіді без води, без суржику.
Особиста заміна [ruslanlap/cavemenko](https://github.com/ruslanlap/cavemenko); ідеї прийомів (pro-drop,
тире, наказовий) звідти.

Що інакше:
- звичайні слова — українською; англійською лише tech-терміни, команди, назви інструментів;
- приклади не порушують власних правил (без `→` і вигаданих скорочень);
- хуки на POSIX `sh` без Node, ~4 мс на виклик; без статистики й телеметрії, без мережі;
- явні винятки: безпека, незворотні дії, багатокрокові інструкції — повною мовою.

## Встановлення

```sh
claude plugin marketplace add ~/Projects/pechera
claude plugin install pechera@pechera
```

## Рівні

`/pechera lite|full|ultra|off` — рівень зберігається в `~/.claude/.pechera-mode`, типовий `full`.
Правила: [rules.md](rules.md).

## Перевірка

```sh
sh test.sh
```
