# build-sections.ps1
# Splits asskd_unified_v4.html into per-section HTML files
# All files share assets/asskd-design-system.css (the unified design system).
#
# Run from repo root:  powershell -ExecutionPolicy Bypass -File .\build-sections.ps1

$ErrorActionPreference = 'Stop'
$Source = 'asskd_unified_v4.html'
$lines  = Get-Content -Path $Source -Encoding UTF8

# 1-based source line ranges (inclusive). Confirmed by mapping <section ...>...</section> blocks.
# Each section is one logical "type" from the design system / user-guide.
$Sections = @(
    @{ id='01-design-system';      title='1. Дизайн-система · Справочники интерфейса';                section='Foundation';                               start=873;  end=1282 ; intro='Палитра, типографика, токены, компоненты, бейджи, поля, кнопки + справочные экраны 7.2.1 / 7.2.2.' },
    @{ id='02-entry-home';         title='3. Вход в систему · Главная страница';                       section='Экраны 1 · 5';                             start=1286; end=1311 ; intro='Экран авторизации и плиточный выбор модуля АССКД.' },
    @{ id='03-my-processes';       title='4. Раздел «Мои процессы»';                                    section='13 экранов · Раздел 6';                    start=1313; end=1628 ; intro='Личный раздел пользователя: 6 вкладок (общая информация, проверка задач, выпуск, согласование, распределение, ожидающие запуска) и их состояния.' },
    @{ id='04-document-issuance';  title='5. Раздел «Выпуск документов»';                              section='15 экранов · Раздел 7';                    start=1629; end=2241 ; intro='Выпускающий процесс: список, карточки, граф, кнопки управления статусом и редактированием.' },
    @{ id='05-document-approval';  title='6. Раздел «Согласование документов»';                        section='16 экранов · Раздел 8';                    start=2242; end=3493 ; intro='Согласование, замечания, задачи, фокус-режим панелей, модальные окна.' },
    @{ id='06-analytics';          title='7. Раздел «Аналитика»';                                       section='22 экрана · Раздел 9';                     start=3494; end=4234 ; intro='5 вкладок, фильтры, диаграммы, отчёты — для аналитики процессов согласования.' },
    @{ id='07-process-monitoring'; title='8. Раздел «Наблюдение за процессами»';                       section='17 экранов · Раздел 10';                   start=4235; end=4726 ; intro='Раздел для наблюдающих пользователей: процессы подразделения, приоритетные, ВП, все процессы.' },
    @{ id='08-logout';             title='9. Выход из системы';                                          section='1 экран · Раздел 11';                      start=4727; end=4799 ; intro='Меню пользователя в нижнем левом углу интерфейса.' },
    @{ id='09-statuses-reference'; title='10. Справочник статусов (Прил. 3 / 4 / 5)';                  section='Reference';                                start=4801; end=4871 ; intro='Полный перечень статусов процессов, этапов и задач из Приложений 3, 4, 5 руководства пользователя АССКД.' }
)

function Get-NavLinks($currentId) {
@"
<nav class="toc">
  <a href="index.html">← Каталог</a>
$(($Sections | ForEach-Object {
    $cls = if ($_.id -eq $currentId) { ' class="a"' } else { '' }
    "  <a href=`"$($_.id).html`"$cls>$($_.title)</a>"
}) -join "`r`n")
  <a href="design-system.html">DS · v1.0 (канон)</a>
</nav>
"@
}

function Build-Section($cfg) {
    $bodyLines = $lines[($cfg.start - 1) .. ($cfg.end - 1)]
    $body = ($bodyLines -join "`r`n")

    $nav = Get-NavLinks $cfg.id

    $html = @"
<!doctype html>
<html lang="ru">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>АССКД · $($cfg.title)</title>
<meta name="description" content="$($cfg.intro)"/>
<link rel="stylesheet" href="assets/asskd-design-system.css"/>
<style>
/* Локальные надстройки страницы — только верхняя навигация и хлебная крошка.
   Все цвета/токены берутся ТОЛЬКО из общей дизайн-системы. */
.toc{position:sticky;top:0;background:rgba(240,243,248,.92);backdrop-filter:blur(10px);
  padding:10px 22px;border-bottom:1px solid var(--line2);z-index:100;
  display:flex;gap:4px;flex-wrap:wrap;align-items:center;margin:0 -24px 24px -24px}
.toc a{font-size:11px;font-weight:700;color:var(--muted);padding:5px 10px;border-radius:999px;border:1px solid transparent;transition:all var(--tr);text-decoration:none}
.toc a:hover{background:#fff;border-color:var(--line2);color:var(--yak-dark)}
.toc a.a{background:var(--yak-blue);color:#fff;border-color:var(--yak-blue)}
.page-head{margin:0 0 18px;display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap}
.page-head .crumbs{font-size:11px;color:var(--muted)}
.page-head .crumbs a{color:var(--muted);text-decoration:none}
.page-head .crumbs a:hover{color:var(--yak-blue)}
.page-head .meta{display:flex;align-items:center;gap:8px}
.page-head .meta .pill{display:inline-flex;align-items:center;height:24px;padding:0 10px;border-radius:999px;border:1px solid var(--blue-l);background:var(--blue-ll);color:var(--yak-blue);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.fn{margin-top:60px;color:var(--muted);font-size:11.5px;line-height:1.6;padding-top:24px;border-top:1px solid var(--line2)}
.fn strong{color:var(--yak-dark);font-weight:700}
</style>
</head>
<body>
<div class="pg">
$nav

<header class="page-head">
  <div class="crumbs"><a href="index.html">АССКД · Каталог разделов</a> &nbsp;/&nbsp; <span style="color:var(--txt);font-weight:700">$($cfg.title)</span></div>
  <div class="meta"><span class="pill">$($cfg.section)</span></div>
</header>

$body

<div class="fn">
  <strong>АССКД — модуль КД.</strong> Этот файл — отдельный документ раздела, использует общую <a href="design-system.html">дизайн-систему&nbsp;v1.0</a> через <code>assets/asskd-design-system.css</code>.
  Менять оформление компонентов нужно только в общей таблице стилей — изменения автоматически распространяются на все разделы.
</div>

</div>
</body>
</html>
"@

    $out = "$($cfg.id).html"
    $html | Set-Content -Path $out -Encoding UTF8
    Write-Host ("  [OK] {0,-32}  ({1,5} bytes from src lines {2}-{3})" -f $out, (Get-Item $out).Length, $cfg.start, $cfg.end)
}

Write-Host "Building per-section files..."
foreach ($s in $Sections) { Build-Section $s }

# ───────────────────── INDEX.HTML hub ─────────────────────
$cards = ($Sections | ForEach-Object {
    $stat = $_.section
@"
  <a class="hub-card" href="$($_.id).html">
    <div class="hub-card-h">
      <div class="hub-card-num">$($_.id.Split('-')[0])</div>
      <span class="bg bi"><span class="dt"></span>$stat</span>
    </div>
    <div class="hub-card-title">$($_.title)</div>
    <div class="hub-card-desc">$($_.intro)</div>
    <div class="hub-card-foot">Открыть раздел  →</div>
  </a>
"@
}) -join "`r`n"

$index = @"
<!doctype html>
<html lang="ru">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>АССКД · Каталог разделов · Модуль КД</title>
<meta name="description" content="Каталог отдельных файлов модуля КД АССКД. Каждый раздел — самостоятельный документ, единая дизайн-система."/>
<link rel="stylesheet" href="assets/asskd-design-system.css"/>
<style>
.hub-hero{background:linear-gradient(135deg,var(--yak-dark) 0%,#0D2F6B 50%,var(--yak-blue) 100%);
  color:#fff;border-radius:var(--rxl);padding:36px 40px;position:relative;overflow:hidden;box-shadow:var(--shm);margin-bottom:32px}
.hub-hero::before{content:'';position:absolute;top:-80px;right:-40px;width:400px;height:400px;
  background:radial-gradient(circle,rgba(135,200,220,.2),transparent 70%);pointer-events:none}
.hub-hero h1{font-size:30px;font-weight:700;line-height:1.18;margin-bottom:12px;position:relative;z-index:1}
.hub-hero h1 b{color:var(--yak-sky);font-weight:700}
.hub-hero p{max-width:720px;color:rgba(255,255,255,.78);font-size:13px;line-height:1.6;position:relative;z-index:1}
.hub-tags{display:flex;flex-wrap:wrap;gap:6px;margin-top:16px;position:relative;z-index:1}
.hub-tag{display:inline-flex;align-items:center;gap:6px;height:26px;padding:0 12px;
  border-radius:999px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);
  font-size:10.5px;font-weight:700;color:rgba(255,255,255,.85);letter-spacing:.04em;text-transform:uppercase}
.hub-tag .dt{width:5px;height:5px;border-radius:50%;background:var(--yak-teal)}

.hub-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-top:8px}
@media(max-width:1100px){.hub-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:720px){.hub-grid{grid-template-columns:1fr}}
.hub-card{display:flex;flex-direction:column;gap:8px;background:var(--panel);border:1px solid var(--line2);
  border-radius:var(--rl);padding:18px 18px 16px;text-decoration:none;color:inherit;transition:all var(--tr);
  box-shadow:0 1px 3px rgba(0,38,100,.05);min-height:180px}
.hub-card:hover{border-color:var(--yak-blue);box-shadow:var(--sh);transform:translateY(-1px)}
.hub-card-h{display:flex;align-items:center;justify-content:space-between;gap:8px}
.hub-card-num{font-family:'JetBrains Mono','SFMono-Regular',Consolas,monospace;font-size:11px;font-weight:800;
  color:var(--yak-blue);background:var(--blue-ll);border:1px solid var(--blue-l);padding:2px 7px;border-radius:4px;letter-spacing:.04em}
.hub-card-title{font-size:14.5px;font-weight:700;color:var(--yak-dark);line-height:1.3;margin-top:2px}
.hub-card-desc{font-size:11.5px;color:var(--muted);line-height:1.5;flex:1}
.hub-card-foot{font-size:10.5px;font-weight:700;color:var(--yak-blue);text-transform:uppercase;letter-spacing:.05em;margin-top:auto;padding-top:8px;border-top:1px solid var(--line3)}

.system-row{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:24px}
@media(max-width:900px){.system-row{grid-template-columns:1fr}}
.system-card{background:var(--panel);border:1px solid var(--line2);border-radius:var(--rl);padding:18px 20px}
.system-card h3{font-size:14px;font-weight:700;color:var(--yak-dark);margin-bottom:10px;display:flex;align-items:center;gap:8px}
.system-card h3 .dot{width:8px;height:8px;border-radius:50%;background:var(--yak-blue)}
.system-card p{font-size:12px;color:var(--muted);line-height:1.55;margin-bottom:10px}
.system-card a.bt{margin-top:6px}

.sec-h{margin:32px 0 14px;padding-bottom:10px;border-bottom:2px solid var(--line2)}
.sec-h .num{font-size:11px;font-weight:800;color:var(--yak-blue);letter-spacing:.18em;text-transform:uppercase;margin-bottom:4px;display:block}
.sec-h h2{font-size:20px;font-weight:700;color:var(--yak-dark)}
.sec-h p{color:var(--muted);font-size:12.5px;margin-top:6px;max-width:820px;line-height:1.55}

.fn{margin-top:60px;color:var(--muted);font-size:11.5px;line-height:1.6;padding-top:24px;border-top:1px solid var(--line2)}
.fn strong{color:var(--yak-dark);font-weight:700}
</style>
</head>
<body>
<div class="pg">

<section class="hub-hero">
  <h1>АССКД · модуль <b>Конструкторские документы</b><br>Каталог документов</h1>
  <p>Большой единый макет был разбит на отдельные файлы по типам разделов руководства пользователя.
     Каждый раздел — самостоятельный документ, готовый к переносу в Figma. Все файлы используют <b>одну общую дизайн-систему</b>
     (<code>assets/asskd-design-system.css</code>) — токены, компоненты и UX-правила едины во всём модуле.</p>
  <div class="hub-tags">
    <span class="hub-tag"><span class="dt"></span>Брендбук Приказ №249</span>
    <span class="hub-tag"><span class="dt"></span>Light theme · Stem / Arial</span>
    <span class="hub-tag"><span class="dt"></span>$($Sections.Count) разделов</span>
    <span class="hub-tag"><span class="dt"></span>Figma-ready</span>
  </div>
</section>

<div class="system-row">
  <div class="system-card">
    <h3><span class="dot"></span>Дизайн-система · v1.0 (каноническая справка)</h3>
    <p>Полный гид: 7 принципов, 32 токена, типографика, справочник статусов, библиотека компонентов, паттерны экранов, правила для разработчиков. Этот документ — <b>единственный источник правды</b>.</p>
    <a class="bt p" href="design-system.html">Открыть дизайн-систему →</a>
  </div>
  <div class="system-card">
    <h3><span class="dot" style="background:var(--yak-teal)"></span>Общая таблица стилей</h3>
    <p>Технический файл, который подключается к каждому разделу через <code>&lt;link rel="stylesheet"&gt;</code>. Изменение токена или компонента здесь автоматически применится во всех файлах ниже.</p>
    <a class="bt s" href="assets/asskd-design-system.css">assets/asskd-design-system.css</a>
  </div>
</div>

<div class="sec-h">
  <span class="num">Sections · 9 файлов</span>
  <h2>Разделы модуля КД</h2>
  <p>Каждая карточка ведёт в отдельный HTML-файл. Внутри файла — все экраны раздела, оформленные по общим правилам дизайн-системы.</p>
</div>

<div class="hub-grid">
$cards
</div>

<div class="fn">
  <strong>АССКД — модуль КД.</strong> Файлы получены из исходного <code>asskd_unified_v4.html</code> разбиением по разделам руководства пользователя (Приказ №249 от 19.08.2024 · Руководство пользователя от 16.03.2026).
  Все файлы ссылаются на единую дизайн-систему — компоненты, цвета, отступы, типографика и UX-правила одинаковы во всех документах.
</div>

</div>
</body>
</html>
"@

$index | Set-Content -Path 'index.html' -Encoding UTF8
Write-Host ""
Write-Host ("  [OK] {0,-32}  ({1,5} bytes)" -f 'index.html', (Get-Item 'index.html').Length)
Write-Host ""
Write-Host "Done."
