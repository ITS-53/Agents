---
description: Transforme une user story du backlog en plan d'implémentation détaillé, prêt pour le développement
argument-hint: <ID story (ex. US-010)> <chemin backlog.md> [chemin docs/ d'architecture]
---

Produis le plan d'implémentation détaillé pour la story demandée : $ARGUMENTS

Procédure :

1. Le **premier** argument est l'identifiant de la story (ex. `US-010`).
2. Le **deuxième** argument est le chemin du `backlog.md` (sortie de `cdc-backlog`). Lis-le et
   extrais la story correspondante (story, critères d'acceptation, priorité, estimation,
   dépendances, traçabilité). Si l'ID est introuvable, signale-le et arrête-toi.
3. Le **troisième** argument (recommandé) est le dossier `docs/` d'architecture. Lis-le pour
   te conformer aux décisions (stack, modèle de données, API, sécurité, ADR).
4. Délègue au sous-agent **cdc-story-plan** en lui transmettant ces éléments. Il doit écrire le
   plan dans `plans/<ID>-plan.md` (à côté du projet) selon son format.
5. Présente-moi : le nombre de tâches, l'estimation cumulée, le tableau critères → tests, et
   les éventuelles questions/lacunes bloquantes.
