<#
.SYNOPSIS
    Installe la chaîne d'agents de cadrage SI dans le profil utilisateur (~/.claude),
    pour qu'elle soit disponible dans TOUS les dépôts (pas seulement ce repo).

.DESCRIPTION
    Copie les sous-agents (.claude/agents), les commandes (.claude/commands) et le script
    Convert-Docx.ps1 vers $HOME/.claude. Rend le chemin du script **absolu et propre à
    l'utilisateur courant** (remplace la référence relative ./scripts/Convert-Docx.ps1).
    Idempotent : relancer met simplement à jour. Aucun secret, aucune action réseau.

.EXAMPLE
    pwsh ./scripts/Install-Agents.ps1
#>
[CmdletBinding()]
param(
    [string]$Destination = (Join-Path $env:USERPROFILE '.claude')
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$srcAgents   = Join-Path $repoRoot '.claude\agents'
$srcCommands = Join-Path $repoRoot '.claude\commands'
$srcScript   = Join-Path $repoRoot 'scripts\Convert-Docx.ps1'

$dstAgents   = Join-Path $Destination 'agents'
$dstCommands = Join-Path $Destination 'commands'
$dstScripts  = Join-Path $Destination 'scripts'
$globalScript = Join-Path $dstScripts 'Convert-Docx.ps1'

New-Item -ItemType Directory -Force -Path $dstAgents, $dstCommands, $dstScripts | Out-Null

# 1) Script d'extraction docx
Copy-Item -LiteralPath $srcScript -Destination $globalScript -Force
Write-Host "Script   : $globalScript"

# 2) Agents + commandes, avec réécriture du chemin du script (relatif -> absolu utilisateur)
function Install-MdFolder($src, $dst) {
    $count = 0
    Get-ChildItem -LiteralPath $src -Filter *.md | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        # ./scripts/Convert-Docx.ps1  ->  "<home>\.claude\scripts\Convert-Docx.ps1"
        $content = $content -replace '\./scripts/Convert-Docx\.ps1', ('"' + $globalScript + '"')
        # (sécurité) toute référence absolue d'un autre profil -> profil courant
        $content = $content -replace '"[A-Za-z]:\\Users\\[^\\"]+\\\.claude\\scripts\\Convert-Docx\.ps1"', ('"' + $globalScript + '"')
        Set-Content -LiteralPath (Join-Path $dst $_.Name) -Value $content -Encoding utf8
        $count++
    }
    return $count
}

$nA = Install-MdFolder $srcAgents   $dstAgents
$nC = Install-MdFolder $srcCommands $dstCommands

Write-Host "Agents   : $nA installés dans $dstAgents"
Write-Host "Commandes: $nC installées dans $dstCommands"
Write-Host ""
Write-Host "✅ Installation terminée. Étapes suivantes :" -ForegroundColor Green
Write-Host "   1. Redémarre ta session Claude Code (les agents/commandes sont chargés au démarrage)."
Write-Host "   2. Pour le pilotage GitHub Project : gh auth refresh -s project --hostname github.com"
Write-Host "   3. Vérifie avec /agents (tu dois voir les agents cdc-* et autres)."
