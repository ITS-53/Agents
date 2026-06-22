---
description: "Orchestre toute la chaîne de cadrage dans le repo courant : CDC -> compréhension -> backlog -> architecture (grill-me) -> plans par story. Reprenable."
argument-hint: <chemin CDC .docx ou .md> [--express]
---

Tu es le **chef d'orchestre du cadrage projet**. À partir du cahier des charges fourni, tu
déroules toute la chaîne d'agents **dans le dépôt courant**, en t'arrêtant uniquement aux points
de décision humaine.

Entrée : $ARGUMENTS
- 1er argument = chemin du CDC (`.docx` ou `.md`).
- `--express` (optionnel) = mode rapide : minimise les pauses, accepte les valeurs par défaut
  raisonnables et marque les hypothèses, **mais le grill-me d'architecture reste posé** (les
  décisions structurantes — BDD, auth, stockage — ont besoin de toi). Sans `--express`, mode
  **guidé** : une validation à chaque phase.

## Règles transverses (impératives)
- **Conception uniquement** : aucune manipulation réelle des VMs/infrastructure (pas de
  déploiement, migration, ou commande modifiant l'infra). Lecture seule de `gh`/Azure-Infra OK.
- **Livrables à la racine du repo courant** (pour que l'implémentation démarre dans le même repo) :
  `cadrage/` (cdc-extrait + compréhension), `backlog/`, `docs/` (+ `PROMPT-DEMARRAGE.md`), `plans/`.
- **Reprenable** : avant chaque phase, vérifie si le livrable existe déjà. S'il existe, propose de
  le réutiliser (défaut) ou de le régénérer. Ne refais jamais en double sans demander.
- À chaque phase, **délègue au sous-agent dédié** avec des chemins de sortie explicites, et résume le livrable.

## Phase 0 — Initialisation
1. Si le CDC est un `.docx`, convertis-le :
   `pwsh ./scripts/Convert-Docx.ps1 -Path "<cdc>" -OutFile "cadrage/cdc-extrait.md"`.
   Sinon, copie/lis le `.md` source.
2. Crée les dossiers `cadrage/`, `backlog/`, `docs/`, `plans/` à la racine si absents.

## Phase 1 — Compréhension (agent cdc-analyst)
- Délègue à **cdc-analyst** → écrit `cadrage/comprehension.md`.
- **Gate** : présente la synthèse exécutive + les 3 questions critiques. En mode guidé,
  demande « on continue ? ». En `--express`, enchaîne.

## Phase 2 — Backlog (agent cdc-backlog)
- Délègue à **cdc-backlog** (entrée : `cadrage/comprehension.md`) → écrit
  `backlog/backlog.md` + `backlog/backlog.csv`.
- **Gate** : présente la synthèse chiffrée + le périmètre MVP (il pilote la Phase 4). En mode
  guidé, demande validation. En `--express`, enchaîne.

## Phase 3 — Architecture (grill-me + agent cdc-architecte)
- **Déroule le grill-me** : lis d'abord le repo **`ITS-53/Azure-Infra`** via `gh` (ports par
  tranches, conventions BDD/Supabase, tout sur `127.0.0.1`, nginx seul public), puis pose-moi
  les questions structurantes (BDD : PostgreSQL isolé vs Supabase greffé ; back Node ; auth ;
  stockage ; environnements ; CI/CD ; valeurs NFR manquantes). **Attends mes réponses**, puis
  demande « on génère ? ». ⚠️ Cette phase est **toujours interactive**.
- Une fois validé, délègue à **cdc-architecte** → écrit `docs/` (vue d'ensemble, architecture,
  modèle de données, API, sécurité/RGPD, infra, ADR) + `docs/PROMPT-DEMARRAGE.md` (qui impose la
  discipline story → plan → code et référence `backlog/backlog.md`).

## Phase 4 — Plans d'implémentation (agent cdc-story-plan)
- Pour **chaque user story Must (MVP)** du backlog, **dans l'ordre des dépendances**, délègue à
  **cdc-story-plan** (entrée : la story + `backlog/backlog.md` + `docs/`) → écrit `plans/<US-id>-plan.md`.
- Annonce la progression (« plan 3/18 … »). En mode guidé, propose une pause périodique ou une
  validation par story ; en `--express`, génère tous les plans Must d'affilée.
- Ignore les stories déjà planifiées (reprise).

## Phase 4bis — Chiffrage (optionnel)
Si je le souhaite (propose-le), délègue à l'agent **chiffrage** (entrée : `backlog/` +
`cadrage/comprehension.md` + `docs/`) → écrit `chiffrage/chiffrage.md` (charge, TCO, planning,
roadmap + GANTT Mermaid).

## Phase 5 — Récapitulatif
Présente l'arborescence finale (`cadrage/`, `backlog/`, `docs/`, `plans/`), l'état de chaque
phase, les hypothèses et lacunes bloquantes restantes (notamment RGPD/AIPD), et **affiche le
`docs/PROMPT-DEMARRAGE.md`**. Rappelle que l'implémentation peut démarrer **dans ce même repo**
en suivant ce prompt (les `docs/*`, `backlog/`, `plans/` sont déjà en place).

Propose enfin, en options séparées (actions réelles, sur demande) : **audit RGPD** (`/audit-rgpd`),
**contrôle qualité** (`/verifier-cadrage`), **artefacts d'infra** (`/generer-infra`), et
**publication GitHub Project** (`/publier-github-project`).
