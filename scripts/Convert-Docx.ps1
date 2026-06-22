<#
.SYNOPSIS
    Convertit un fichier .docx en texte Markdown lisible par un agent Claude.

.DESCRIPTION
    Un .docx est une archive ZIP contenant du XML. Ce script lit word/document.xml,
    convertit les tableaux Word en tableaux Markdown, transforme les paragraphes/
    tabulations/sauts de ligne en texte, retire les balises et décode les entités.
    Aucune dépendance externe (Word, Python, pandoc) requise.

.PARAMETER Path
    Chemin du fichier .docx source.

.PARAMETER OutFile
    Chemin de sortie. Si omis, le texte est renvoyé sur la sortie standard.

.EXAMPLE
    pwsh ./scripts/Convert-Docx.ps1 -Path "C:\dossier\cdc.docx" -OutFile "./cadrage/cdc-extrait.md"

.NOTES
    Les tableaux imbriqués (rares) ne sont pas gérés (le tableau interne est aplati).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [string]$OutFile
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

# --- Helpers tableaux ---------------------------------------------------------
function Get-CellText([string]$tc) {
    # Texte d'une cellule, sur une seule ligne (les entités sont décodées plus tard, globalement)
    $t = $tc -replace '<w:tab[^>]*/>', ' '
    $t = $t -replace '<w:br[^>]*/>', ' '
    $t = $t -replace '</w:p>', ' '
    $t = [regex]::Replace($t, '<[^>]+>', '')
    $t = ($t -replace '\s+', ' ').Trim()
    $t = $t -replace '\|', '\|'   # échappe les pipes pour ne pas casser le tableau Markdown
    return $t
}

function Convert-DocxTable([string]$tbl) {
    $rows = [regex]::Matches($tbl, '(?s)<w:tr\b.*?</w:tr>')
    if ($rows.Count -eq 0) { return '' }
    $matrix = foreach ($row in $rows) {
        $cells = [regex]::Matches($row.Value, '(?s)<w:tc\b.*?</w:tc>')
        ,@(foreach ($cell in $cells) { Get-CellText $cell.Value })
    }
    $colCount = ($matrix | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
    if (-not $colCount) { return '' }

    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine(); [void]$sb.AppendLine()
    for ($i = 0; $i -lt $matrix.Count; $i++) {
        $cells = @($matrix[$i])
        $padded = for ($c = 0; $c -lt $colCount; $c++) {
            if ($c -lt $cells.Count -and -not [string]::IsNullOrWhiteSpace($cells[$c])) { $cells[$c] } else { ' ' }
        }
        [void]$sb.AppendLine('| ' + ($padded -join ' | ') + ' |')
        if ($i -eq 0) {
            $sep = (1..$colCount | ForEach-Object { '---' }) -join ' | '
            [void]$sb.AppendLine('| ' + $sep + ' |')
        }
    }
    [void]$sb.AppendLine()
    return $sb.ToString()
}
# -----------------------------------------------------------------------------

if (-not (Test-Path -LiteralPath $Path)) { throw "Fichier introuvable : $Path" }
$full = (Resolve-Path -LiteralPath $Path).Path

$zip = [System.IO.Compression.ZipFile]::OpenRead($full)
try {
    $entry = $zip.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
    if (-not $entry) { throw "word/document.xml introuvable — le fichier n'est pas un .docx valide." }
    $reader = New-Object System.IO.StreamReader($entry.Open(), [System.Text.Encoding]::UTF8)
    $xml = $reader.ReadToEnd()
    $reader.Dispose()
}
finally {
    $zip.Dispose()
}

# 1) Tableaux Word -> tableaux Markdown (AVANT le traitement des paragraphes)
$tableEvaluator = [System.Text.RegularExpressions.MatchEvaluator] { param($m) Convert-DocxTable $m.Value }
$xml = [regex]::Replace($xml, '(?s)<w:tbl>.*?</w:tbl>', $tableEvaluator)

# 2) Préserver la structure : tabulations, fins de paragraphe, sauts de ligne
$xml = $xml -replace '<w:tab[^>]*/>', "`t"
$xml = $xml -replace '</w:p>', "`n"
$xml = $xml -replace '<w:br[^>]*/>', "`n"

# 3) Retirer toutes les balises XML restantes, puis décoder les entités (&amp;, &lt;, ...)
$text = [System.Text.RegularExpressions.Regex]::Replace($xml, '<[^>]+>', '')
$text = [System.Net.WebUtility]::HtmlDecode($text)

# 4) Normaliser : retirer espaces de fin de ligne, compresser les lignes vides consécutives
$out = New-Object System.Collections.Generic.List[string]
$prevBlank = $false
foreach ($line in ($text -split "`n")) {
    $trimmed = $line.TrimEnd()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        if (-not $prevBlank) { $out.Add('') }
        $prevBlank = $true
    }
    else {
        $out.Add($trimmed)
        $prevBlank = $false
    }
}
$result = ($out -join "`n").Trim()

if ($OutFile) {
    $dir = Split-Path -Parent $OutFile
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Set-Content -LiteralPath $OutFile -Value $result -Encoding utf8
    Write-Host "OK -> $OutFile ($($out.Count) lignes)"
}
else {
    $result
}
