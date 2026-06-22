---
description: Chiffre un projet (charge j-h, TCO, planning, roadmap, GANTT) à partir du backlog
argument-hint: <chemin backlog.md> [chemin compréhension.md] [chemin docs/]
---

Produis le chiffrage du projet à partir de : $ARGUMENTS

1. Le 1er argument est `backlog/backlog.md` (sortie de `cdc-backlog`). Lis-le (points, MoSCoW, dépendances).
2. Les arguments suivants (optionnels) : `comprehension.md` (contraintes de date, volumétrie) et
   `docs/` (complexité technique). Utilise-les pour affiner.
3. Délègue à l'agent **chiffrage** → écrit `chiffrage/chiffrage.md` (hypothèses, charge par epic,
   TCO ponctuel + récurrent, planning/sprints, roadmap + GANTT Mermaid, fourchette de sensibilité).
4. Présente-moi : la **charge totale** (fourchette), le **TCO sur 3 ans** (fourchette), le planning
   macro, et les **3 hypothèses les plus sensibles** à valider (vélocité, TJM, coûts inconnus).
