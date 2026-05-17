# build-index.ps1 — собирает test/index.html из разделов 01–09 в горизонтальную ленту (без TOC / page-head).
# Запуск из test/:  powershell -ExecutionPolicy Bypass -File .\build-index.ps1

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$Sections = @(
    @{ file = '01-design-system.html';      colClass = '' }
    @{ file = '02-entry-home.html';         colClass = '' }
    @{ file = '03-my-processes.html';       colClass = '' }
    @{ file = '04-document-issuance.html';  colClass = 'flat-ui' }
    @{ file = '05-document-approval.html'; colClass = 'page-approval' }
    @{ file = '06-analytics.html';          colClass = '' }
    @{ file = '07-process-monitoring.html'; colClass = '' }
    @{ file = '08-logout.html';             colClass = '' }
    @{ file = '09-statuses-reference.html'; colClass = '' }
)

function Strip-PageChrome([string]$html) {
    $s = $html
    $s = [regex]::Replace($s, '(?s)<nav class="toc">.*?</nav>\s*', '')
    $s = [regex]::Replace($s, '(?s)<header class="page-head">.*?</header>\s*', '')
    $s = [regex]::Replace($s, '(?s)<nav class="ds-nav">.*?</nav>\s*', '')
    $s = [regex]::Replace($s, '(?s)<div class="fn">[\s\S]*$', '')
    return $s.Trim()
}

function Get-ColumnBody([string]$path) {
    if (-not (Test-Path $path)) {
        Write-Warning "Skip missing: $path"
        return $null
    }
    $raw = Get-Content -Path $path -Raw -Encoding UTF8
    if ($raw -notmatch '(?s)<div class="pg">\s*(.*)\s*</div>\s*</body>') {
        throw "Cannot parse .pg in $path"
    }
    return (Strip-PageChrome $matches[1])
}

$colParts = [System.Collections.Generic.List[string]]::new()
foreach ($sec in $Sections) {
    $body = Get-ColumnBody $sec.file
    if ($null -eq $body) { continue }
    $id = [System.IO.Path]::GetFileNameWithoutExtension($sec.file)
    $cls = 'index-col'
    if ($sec.colClass) { $cls += " $($sec.colClass)" }
    $colParts.Add(@"
<div class="$cls" id="col-$id" data-src="$($sec.file)">
$body
</div>
"@)
}

$strip = $colParts -join "`n`n"

$index = @"
<!doctype html>
<html lang="ru">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>АССКД · Все экраны · лента</title>
<meta name="description" content="Все разделы модуля КД в одной горизонтальной ленте для обзора и Figma."/>
<link rel="stylesheet" href="assets/tokens.css"/>
<link rel="stylesheet" href="assets/base.css"/>
<link rel="stylesheet" href="assets/components.css"/>
<link rel="stylesheet" href="assets/shell.css"/>
<link rel="stylesheet" href="assets/pages.css"/>
</head>
<body class="index-gallery">
<div class="index-strip">
$strip
</div>
</body>
</html>
"@

$outPath = Join-Path $PSScriptRoot 'index.html'
[System.IO.File]::WriteAllText($outPath, $index, [System.Text.UTF8Encoding]::new($true))
Write-Host ("[OK] index.html  ({0:N0} bytes, {1} columns)" -f (Get-Item $outPath).Length, $colParts.Count)
