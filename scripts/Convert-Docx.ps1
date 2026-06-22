<#
.SYNOPSIS
    Convertit un fichier .docx en texte Markdown lisible par un agent Claude.

.DESCRIPTION
    Un .docx est une archive ZIP contenant du XML. Ce script lit word/document.xml,
    transforme les paragraphes/tabulations/sauts de ligne en texte, retire les balises
    et décode les entités. Aucune dépendance externe (Word, Python, pandoc) requise.

.PARAMETER Path
    Chemin du fichier .docx source.

.PARAMETER OutFile
    Chemin de sortie. Si omis, le texte est renvoyé sur la sortie standard.

.EXAMPLE
    pwsh ./scripts/Convert-Docx.ps1 -Path "C:\dossier\cdc.docx" -OutFile "./analyses/cdc-extrait.md"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [string]$OutFile
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

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

# Préserver la structure : tabulations, fins de paragraphe, sauts de ligne
$xml = $xml -replace '<w:tab[^>]*/>', "`t"
$xml = $xml -replace '</w:p>', "`n"
$xml = $xml -replace '<w:br[^>]*/>', "`n"

# Retirer toutes les balises XML restantes, puis décoder les entités (&amp;, &lt;, ...)
$text = [System.Text.RegularExpressions.Regex]::Replace($xml, '<[^>]+>', '')
$text = [System.Net.WebUtility]::HtmlDecode($text)

# Normaliser : retirer espaces de fin de ligne, compresser les lignes vides consécutives
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
