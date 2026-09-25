---
description: Chiffre un projet (charge j-h, TCO, planning, roadmap, GANTT) à partir du backlog
argument-hint: <chemin backlog.md> [chemin compréhension.md] [chemin docs/]
---

Produis le chiffrage du projet à partir de : $ARGUMENTS

1. Le 1er argument est `backlog/backlog.md` (sortie de `cdc-backlog`). Lis-le (points, MoSCoW, dépendances).
2. Les arguments suivants (optionnels) : `comprehension.md` (contraintes de date, volumétrie) et
   `docs/` (complexité technique). Utilise-les pour affiner. Lis aussi, s'ils existent,
   `cadrage/cahier-des-charges.md` (§8 : acteurs, disponibilités, jalons datés, budget) et
   `pilotage/journal-des-decisions.md` : ils disent **qui développe** et si le développement est
   **assisté par un assistant de code IA**, ce qui change le ratio points → charge.
3. Délègue à l'agent **chiffrage** → écrit `pilotage/chiffrage.md` (hypothèses et mode de
   réalisation, charge par epic, incompressible humain, TCO ponctuel + récurrent, planning/sprints
   avec marge par jalon, roadmap + GANTT Mermaid, fourchette de sensibilité).
4. Présente-moi : le **mode de réalisation retenu**, la **charge totale** (fourchette), le **TCO sur
   3 ans** (fourchette), le planning macro avec la marge par jalon, et les **3 hypothèses les plus
   sensibles** à valider.
