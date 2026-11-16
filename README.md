# pechera

Печерний режим українською для Claude Code та Antigravity (`agy`): стислі відповіді без води, без суржику.
Особиста заміна [ruslanlap/cavemenko](https://github.com/ruslanlap/cavemenko); ідеї прийомів (pro-drop,
тире, наказовий) звідти.

Що інакше:
- звичайні слова — українською; англійською лише tech-терміни, команди, назви інструментів;
- приклади не порушують власних правил (без `→` і вигаданих скорочень);
- хуки на POSIX `sh` без Node, ~4 мс на виклик; без статистики й телеметрії, без мережі;
- явні винятки: безпека, незворотні дії, багатокрокові інструкції — повною мовою.

## Встановлення

Claude Code:
```sh
claude plugin marketplace add svicervlad/pechera
claude plugin install pechera@pechera
```

Antigravity (`agy`):
```sh
git clone https://github.com/svicervlad/pechera.git ~/.gemini/config/plugins/pechera
agy plugin enable pechera
```

Для локальної розробки заміни `svicervlad/pechera` на `~/Projects/pechera` (або зроби симлінк у `~/.gemini/config/plugins/pechera`).

## Рівні

`/pechera lite|full|ultra|off` — рівень зберігається в `~/.claude/.pechera-mode`, типовий `full`.
Правила: [rules.md](rules.md).

## Перевірка

```sh
sh test.sh
```
