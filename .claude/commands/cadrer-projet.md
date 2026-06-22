---
description: "Orchestre toute la chaîne de cadrage : CDC -> compréhension -> backlog -> architecture (grill-me) -> plans par story. Reprenable au fil du temps."
argument-hint: <chemin CDC .docx ou .md> [--express]
---

Tu es le **chef d'orchestre du cadrage projet**. À partir du cahier des charges fourni, tu
déroules toute la chaîne d'agents, en t'arrêtant uniquement aux points de décision humaine.

Entrée : $ARGUMENTS
- 1er argument = chemin du CDC (`.docx` ou `.md`).
- `--express` (optionnel) = mode rapide : minimise les pauses, accepte les valeurs par défaut
  raisonnables et marque les hypothèses, **mais le grill-me d'architecture reste posé** (les
  décisions structurantes — BDD, auth, stockage — ont besoin de toi). Sans `--express`, mode
  **guidé** : une validation à chaque phase.

## Règles transverses
- **Reprenable** : avant chaque phase, vérifie si le livrable existe déjà dans `projets/<slug>/`.
  S'il existe, propose de le réutiliser (défaut) ou de le régénérer. Ne refais jamais en double sans demander.
- **Conception uniquement** : aucune manipulation réelle des VMs/infra (cf. CLAUDE.md).
- À chaque phase, **délègue au sous-agent dédié** (via la tâche), avec des chemins de sortie explicites.
- Tiens-moi informé : annonce chaque phase qui démarre et résume chaque livrable produit.

## Phase 0 — Initialisation
1. Si le CDC est un `.docx`, convertis-le :
   `pwsh ./scripts/Convert-Docx.ps1 -Path "<cdc>" -OutFile "projets/<slug>/cdc-extrait.md"`.
2. Détermine un **slug** de projet (code projet ou nom normalisé, ex. `pepite`). Crée le dossier
   `projets/<slug>/`. Tous les livrables y vivront.

## Phase 1 — Compréhension (agent cdc-analyst)
- Délègue à **cdc-analyst** → écrit `projets/<slug>/comprehension.md`.
- **Gate** : présente la synthèse exécutive + les 3 questions critiques. En mode guidé,
  demande « on continue ? ». En `--express`, enchaîne directement.

## Phase 2 — Backlog (agent cdc-backlog)
- Délègue à **cdc-backlog** (entrée : `comprehension.md`) → écrit `projets/<slug>/backlog/backlog.md` + `backlog.csv`.
- **Gate** : présente la synthèse chiffrée + le périmètre MVP. En mode guidé, demande validation
  (le périmètre MVP est important car il pilote la Phase 4). En `--express`, enchaîne.

## Phase 3 — Architecture (commande grill-me + agent cdc-architecte)
- **Déroule le grill-me** exactement comme `/proposer-archi` (lis d'abord le repo Azure-Infra
  `ITS-53/Azure-Infra` pour les ports/conventions), pose-moi les questions, **attends mes
  réponses**, puis demande « on génère ? ». ⚠️ Cette phase est **toujours interactive**.
- Une fois validé, délègue à **cdc-architecte** → écrit `projets/<slug>/docs/` (vue d'ensemble,
  architecture, modèle de données, API, sécurité/RGPD, infra, ADR) + `docs/PROMPT-DEMARRAGE.md`
  (qui impose la discipline story → plan → code et référence le backlog).

## Phase 4 — Plans d'implémentation (agent cdc-story-plan)
- Pour **chaque user story Must (MVP)** du backlog, **dans l'ordre des dépendances**, délègue à
  **cdc-story-plan** (entrée : la story + `backlog.md` + `docs/`) → écrit `projets/<slug>/plans/<US-id>-plan.md`.
- Annonce la progression (« plan 3/18 … »). En mode guidé, propose une **pause toutes les N
  stories** ou un point de validation par story si je le demande ; en `--express`, génère tous
  les plans Must d'affilée.
- Ignore les stories déjà planifiées (reprise).

## Phase 5 — Récapitulatif
Présente l'arborescence finale de `projets/<slug>/`, l'état de chaque phase, les hypothèses et
lacunes bloquantes restantes (notamment RGPD/AIPD), et **affiche le `docs/PROMPT-DEMARRAGE.md`**
prêt à coller dans une nouvelle session Claude Code pour démarrer l'implémentation.
