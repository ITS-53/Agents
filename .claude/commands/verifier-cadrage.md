---
description: Contrôle la cohérence et la traçabilité de toute la chaîne de cadrage et rend un avis go / no-go pour le développement
argument-hint: <dossier projet ou chemins compréhension/backlog/docs/plans>
---

Vérifie la cohérence du cadrage à partir de : $ARGUMENTS

1. Localise les livrables disponibles : `comprehension.md`, `backlog/`, `docs/`, `plans/`
   (à la racine du repo courant, sous `cadrage/`, ou dans `projets/<slug>/`). Liste présents/absents.
2. Délègue à l'agent **cadrage-qa** → écrit le rapport dans `cadrage/cadrage-qa-rapport.md`.
3. Présente-moi : le **verdict (Go / Go sous conditions / No-go)**, le nombre d'anomalies par
   gravité (🔴/🟠/🟡), la matrice de traçabilité résumée, et les 3 actions prioritaires.
