# Dépôt `Agents` — agents Claude Code pour la DSI

Ce dépôt héberge des agents Claude Code (sous-agents, commandes, scripts) au service
des projets SI du cabinet. Tout est versionné dans Git pour être partagé et révisé.

## Structure

- `.claude/agents/` — sous-agents spécialisés (un fichier `.md` par agent).
- `.claude/commands/` — commandes slash (`/nom`) qui orchestrent les agents.
- `scripts/` — utilitaires PowerShell (ex. extraction de `.docx`).
- `templates/` — modèles de référence (cahier des charges, etc.).
- `analyses/` — sorties produites par les agents (dossiers de compréhension, audits).

## Agents disponibles

- **cdc-analyst** (sous-agent) — analyse un cahier des charges rempli et produit un « Dossier
  de compréhension projet » complet (objectifs, exigences, contraintes, lacunes, questions de
  cadrage). Invocable via la commande `/analyser-cdc <chemin>`.
- **cdc-architecte** (sous-agent) — transforme un dossier de compréhension + des réponses de
  cadrage en proposition d'architecture (Vue 3 / TS / Node.js / Docker, BDD PostgreSQL isolé
  ou Supabase greffé sur VM Azure), génère la doc dans `docs/` et un `docs/PROMPT-DEMARRAGE.md`.
- **/proposer-archi `<compréhension>`** (commande) — orchestrateur **interactif « grill-me »** :
  il te pose un maximum de questions, puis délègue la génération à `cdc-architecte`.
- **cdc-backlog** (sous-agent) — génère un backlog produit (epics, user stories, critères
  Gherkin, MoSCoW, estimations, dépendances, traçabilité) depuis un dossier de compréhension
  (et, optionnellement, la doc d'architecture). Produit `backlog.md` + `backlog.csv`.
- **/generer-backlog `<compréhension>` `[docs/]`** (commande) — lance `cdc-backlog`.
- **cdc-story-plan** (sous-agent) — transforme **une** user story en plan d'implémentation
  détaillé (approche, impact BDD/API, front/back, sécurité, tâches, tests mappés aux critères,
  DoD), en se conformant à la doc d'architecture. Produit `plans/<ID>-plan.md`.
- **/planifier-story `<ID>` `<backlog.md>` `[docs/]`** (commande) — lance `cdc-story-plan`.

- **/cadrer-projet `<cdc.docx>` `[--express]`** (commande **orchestratrice**) — déroule toute la
  chaîne d'un seul lancement : extraction → compréhension → backlog → architecture (grill-me) →
  un plan par story Must. **Reprenable** (saute les livrables déjà présents), s'arrête uniquement
  aux points de décision humaine. C'est le « lance le premier, tout suit » de bout en bout.

> Chaîne type (manuelle) : `/analyser-cdc <cdc.docx>` → `/generer-backlog <compréhension.md>` →
> `/proposer-archi <compréhension.md>` → `/planifier-story <US-id> <backlog.md> <docs/>`.
> Chaque commande propose d'enchaîner la suivante ; **`/cadrer-projet` fait tout d'un coup.**
> Le prompt de démarrage généré par `cdc-architecte` impose la discipline **story → plan → code**.

## Espace de travail par projet

L'orchestrateur range tous les livrables d'un projet dans `projets/<slug>/` :
`cdc-extrait.md`, `comprehension.md`, `backlog/`, `docs/` (+ `PROMPT-DEMARRAGE.md`), `plans/`.
(Le dossier `analyses/` reste utilisé par les démos et les commandes lancées isolément.)

## Repo Azure-Infra

L'infrastructure Azure (plages de ports, réseau, conventions) est décrite dans un repo GitHub
**Azure-Infra** séparé. Tout agent produisant de l'infra (`cdc-architecte`) doit s'y référer et
**ne jamais entrer en collision** avec les ports déjà occupés.

Repo : **`ITS-53/Azure-Infra`** (lecture via `gh`). Docs clés : `docs/PORTS.md` (tranches
81xx frontends / 84xx admin / 54xx bases / 90xx exporters ; tout sur `127.0.0.1`, nginx seul
public), `docs/DATABASE.md` (1 schéma par app + `core` partagé, RLS, 1 rôle PG/app),
`docs/SUPABASE-CONFIG.md` (Supabase self-hosted, Azure AD + MFA actifs, emails via relais Graph).
Frontends déjà alloués : 8101-8106 ; Supabase API 8400. **Conception uniquement : ne jamais
manipuler les VMs réelles.**

## Conventions

- **Langue : français** pour tous les livrables (CDC, analyses, documentation projet).
- Les `.docx` doivent être convertis en Markdown via `scripts/Convert-Docx.ps1` avant
  lecture par un agent (Claude ne lit pas le binaire `.docx` nativement).
- Shell principal : **PowerShell 7** (Windows). Les scripts utilisent la syntaxe `pwsh`.
- Un agent ne doit **jamais inventer** une donnée absente d'un document source : il
  signale la lacune.
