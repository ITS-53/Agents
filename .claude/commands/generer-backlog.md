---
description: Génère un backlog produit (epics, user stories, critères Gherkin, MoSCoW, estimations) depuis un dossier de compréhension projet
argument-hint: <chemin compréhension.md> [chemin docs/ d'architecture (optionnel)]
---

Génère le backlog produit à partir des entrées suivantes : $ARGUMENTS

Procédure :

1. Le **premier** argument est le dossier de compréhension (sortie de `cdc-analyst`). Lis-le.
   S'il est absent, propose de lancer d'abord `/analyser-cdc` et arrête-toi.
2. Le **second** argument (optionnel) est un dossier `docs/` d'architecture (sortie de
   `cdc-architecte`). S'il est fourni, lis-le pour ajouter des stories techniques habilitantes.
3. Délègue la génération au sous-agent **cdc-backlog** en lui transmettant les chemins. Il doit
   produire `backlog.md` (backlog lisible) et `backlog.csv` (import outil) dans le dossier du
   projet (à côté de la compréhension, dans un sous-dossier `backlog/`).
4. Présente-moi : la synthèse chiffrée (nb d'epics/stories, répartition MoSCoW, total de points),
   le **périmètre MVP** proposé, et la liste des **stories bloquées par des lacunes** du CDC.

**Étape suivante (chaînage)** : propose-moi d'enchaîner sur l'architecture (`/proposer-archi`)
puis sur la planification des stories MVP (`/planifier-story`). Pour tout orchestrer, renvoie
vers **`/cadrer-projet`**.
