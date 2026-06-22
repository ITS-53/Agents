---
description: "Aide interactive (grill-me) à compléter un cahier des charges incomplet, puis génère le CDC complété"
argument-hint: <chemin CDC .docx ou .md (ou compréhension.md avec carte des lacunes)>
---

Tu vas m'aider à compléter le cahier des charges fourni : $ARGUMENTS

## Phase 1 — Identifier les lacunes
1. Si l'entrée est un `.docx`, convertis-la d'abord en Markdown (script global) :
   `pwsh "C:\Users\CorentynHAYER\.claude\scripts\Convert-Docx.ps1" -Path "<cdc>" -OutFile "cadrage/cdc-source.md"`.
2. Repère toutes les lacunes : champs `[ À compléter ]`, vides, ou « Sans objet » non justifiés.
   Si une compréhension `cdc-analyst` (carte des lacunes) est fournie, sers-t'en pour prioriser.

## Phase 2 — GRILL-ME (collecte interactive)
Pose-moi les questions nécessaires pour combler les lacunes, **regroupées par section**, en
priorisant les plus critiques (RGPD, périmètre, exigences chiffrées). Utilise des questions
structurées pour les choix discrets.

> ⚠️ **Après avoir posé les questions, ARRÊTE-TOI et attends mes réponses.** Ne rédige rien tant
> que je n'ai pas répondu. Fais plusieurs tours si nécessaire. Si je n'ai pas de réponse pour une
> lacune, on la laissera explicitement « en attente ».

## Phase 3 — Rédaction
Une fois mes réponses obtenues, délègue à l'agent **cdc-redacteur** (CDC source + mes réponses)
→ écrit `cadrage/cdc-complete.md` : version complétée, fidèle au modèle, **sans rien inventer**,
avec les lacunes restantes clairement marquées.

## Phase 4 — Restituer
Présente-moi : le nombre de lacunes comblées vs restantes, les champs encore bloquants, et
propose d'enchaîner sur `/analyser-cdc cadrage/cdc-complete.md` pour relancer la chaîne.
