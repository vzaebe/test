# АССКД · UI — инструкция для агентов

Цель: **не искать по всему репозиторию** и **не дублировать CSS в HTML**. Один раз открыть нужный файл — править в одном месте.

## Порядок подключения CSS (всегда так)

```html
<link rel="stylesheet" href="assets/tokens.css"/>
<link rel="stylesheet" href="assets/base.css"/>
<link rel="stylesheet" href="assets/components.css"/>
<link rel="stylesheet" href="assets/shell.css"/>
<link rel="stylesheet" href="assets/pages.css"/>
```

Дополнительно:

| Файл | Когда |
|------|--------|
| `assets/canon.css` | только `design-system.html` (hero бренда, DO/DONT, дерево файлов) |
| `body.flat-ui` | только `04-document-issuance.html` |
| `body.page-approval` | только `05-document-approval.html` |

**Запрещено:** блок `<style>` в страницах `01`–`09`, дублирование `:root` в HTML, хардкод цветов (`#0F4DBC` и т.п.) — только `var(--token)`.

## Карта файлов (куда смотреть первым делом)

| Задача | Файл | Не открывать |
|--------|------|----------------|
| Цвет, радиус, тень, отступ | `assets/tokens.css` | `design-system.html` целиком |
| TOC каталога, `.page-head`, `.fn`, сетки `.g2` | `assets/base.css` | inline в HTML |
| Кнопки `.bt`, бейджи `.bg`, таблицы, KPI, статусы `.st-row` | `assets/components.css` | `01-design-system.html` для копипаста |
| App shell: `.scr` + `.app-rail`, `.ws-3`, модалки, граф | `assets/shell.css` | `04`/`05` inline |
| DS-навигация `.ds-*`, flat-ui, approval | `assets/pages.css` | — |
| Канон v1.0 (философия, логотип) | `assets/canon.css` + `design-system.html` body | старый монолит CSS |

## Эталонные HTML-страницы

| № | Файл | Содержание |
|---|------|------------|
| 1 | `01-design-system.html` | Витрина компонентов (кнопки, поля, таблицы, графики) |
| 2 | `02-entry-home.html` | Вход, плитки модулей |
| 3 | `03-my-processes.html` | Мои процессы |
| 4 | `04-document-issuance.html` | Выпуск (`flat-ui`) |
| 5 | `05-document-approval.html` | Согласование (`page-approval`) |
| 6 | `06-analytics.html` | Аналитика |
| 7 | `07-process-monitoring.html` | Наблюдение |
| 8 | `08-logout.html` | Выход / меню пользователя |
| 9 | `09-statuses-reference.html` | Справочник статусов |
| — | `design-system.html` | Полный канон DS v1.0 (документация) |

Папка `test/empty/` — **устаревший срез**, не использовать (`asskd-design-system.css`).

## Частые классы (шпаргалка)

```
Кнопки:     .bt.p .bt.s .bt.ok .bt.d .bt.g .bt.sm
Бейдж:      .bg.bi .bg.bs .bg.bw .bg.bd .bg + .dt
Поле:       .fd .fg label .ta
Статус:     .si + .bg  или  .st-row
Таблица:    .tw2 > table
KPI:        .kpi-g > .kpi
Shell:      .scr > .app-rail + .app-tb + .scr-b
Workspace:  .ws-3 > .ws-panel > .ws-ph + .ws-pb
Модалка:    .mb > .mh + .mbd + .mf
```

Новый повторяющийся блок (≥2 экрана) → добавить в `components.css` или `shell.css`, затем одна строка в `01-design-system.html` как пример.

## Алгоритм для агента (минимум токенов)

1. **Уточнить тип задачи:** токен / компонент / layout / одна страница.
2. **Открыть один CSS-файл** из таблицы выше (не `index.html`, не весь `04` если правка кнопки).
3. **Сверить с витриной:** `01-design-system.html` или секция в `design-system.html` — только нужный `id` якорь (`#ds-buttons` и т.д.).
4. **Править HTML страницы** только разметкой: классы из шпаргалки, без нового CSS.
5. **Не читать** `index.html` (6000+ строк) без явной просьбы пользователя.

## Токены (единственный источник)

Файл: `assets/tokens.css`. Основные:

- Бренд: `--yak-dark`, `--yak-blue`, `--yak-sky`, `--yak-red`, `--yak-coral`, `--yak-teal`
- Поверхности: `--bg`, `--panel`, `--line`, `--line2`, `--line3`
- Текст: `--txt`, `--muted`
- Семантика: `--ok`, `--warn`, `--err`, `--blue-l`, `--blue-ll`
- Радиусы: `--rs`, `--r`, `--rl`, `--rxl`
- Отступы: `--sp1` … `--sp10`

## App shell

Экран в контексте приложения:

```html
<div class="scr">
  <aside class="app-rail">…</aside>
  <div class="app-tb">…хлебные крошки…</div>
  <div class="scr-b">…контент…</div>
</div>
```

Стили задаёт `shell.css` через `.scr:has(> .app-rail)` — **не** копировать grid в HTML.

## Чеклист перед завершением

- [ ] Нет нового `<style>` в `01`–`09`
- [ ] Цвета только через `var(--…)`
- [ ] Повторяющийся UI вынесен в `assets/`
- [ ] `01-design-system.html` обновлён, если добавлен новый компонент
