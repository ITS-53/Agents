---
description: "Grill-me puis génère une proposition d'architecture (Vue3/TS/Node/Docker) + la doc /docs + un prompt de démarrage, à partir d'un dossier de compréhension projet"
argument-hint: <chemin vers le dossier de compréhension (ex. analyses/demo/PEPITE-comprehension.md)>
---

Tu vas produire une proposition d'architecture applicative à partir du dossier de
compréhension situé ici : $ARGUMENTS

Déroule **strictement** les phases suivantes, dans l'ordre. **Ne saute aucune phase.**

## Phase 1 — Charger les entrées
1. Lis le dossier de compréhension ($ARGUMENTS). S'il est absent, propose de lancer d'abord
   l'agent `cdc-analyst` et arrête-toi.
2. Localise le repo **Azure-Infra** (définition des plages de ports, réseau, conventions) :
   - Cherche d'abord un clone local plausible ; sinon demande-moi le chemin local **ou** le
     nom du repo GitHub (`owner/nom`) pour le lire via `gh`.
   - Lis-y les fichiers décrivant les **ports utilisés**, segments réseau et conventions
     (cherche dans `*.md`, `*.bicep`, `*.tf`, `docker-compose*`, `*.json`). Retiens les plages
     de ports **déjà occupées** pour ne pas entrer en collision.

## Phase 2 — GRILL-ME (le cœur de cette commande)
Pose-moi un **maximum de questions ciblées** pour lever toutes les ambiguïtés avant de
produire quoi que ce soit. Regroupe-les par thème. Utilise l'outil de questions structurées
pour les choix discrets (avec options), et des questions ouvertes pour le reste.

> ⚠️ **Impératif : après avoir posé les questions, ARRÊTE-TOI et attends mes réponses.**
> Ne génère **aucun** livrable tant que je n'ai pas répondu. Si mes réponses ouvrent de
> nouvelles questions, repose-en un second tour. Continue jusqu'à ce que tu estimes avoir
> tout le nécessaire — puis demande-moi une validation explicite « on génère ? ».

Couvre au minimum ces thèmes (adapte selon le dossier) :

- **Base de données (décision structurante)** : PostgreSQL isolé (instance dédiée) **vs**
  Supabase sur la VM Azure existante (greffe d'un nouveau schéma applicatif). Implications à
  m'exposer : Supabase apporte Auth/RLS/Storage/réaltime intégrés mais couplage à l'instance
  existante ; PostgreSQL isolé = contrôle total mais tout à recâbler (auth, stockage).
- **Back-end Node** : framework (NestJS / Fastify / Express) ? ORM (Prisma / Drizzle / TypeORM) ?
- **Authentification** : SSO/SAML pour les collaborateurs ? auth séparée pour les clients
  externes ? MFA (obligatoire vu les données sensibles) ? Si Supabase, utilise-t-on Supabase Auth ?
- **Stockage des fichiers** : Supabase Storage / Azure Blob / disque VM ? (penser volumétrie,
  rétention longue, valeur probante).
- **Cible de déploiement** : sur la VM Azure existante (docker compose) ? AKS ? conventions de ports Azure-Infra ?
- **Environnements** : dev / recette / prod — combien, où, isolés comment ?
- **CI/CD** : GitHub Actions ? registre d'images ?
- **Exigences non chiffrées** restées en suspens dans le dossier (perf cible, RPO/RTO,
  durée de conservation) : me demander des valeurs ou proposer des valeurs par défaut à valider.
- **Périmètre v1** : confirmer le gel des « Must » et l'exclusion des « Won't ».

## Phase 3 — Générer les livrables
Une fois mes réponses obtenues **et** ma validation « on génère ? » donnée :
1. Compile un **brief de cadrage** complet (dossier de compréhension + toutes mes réponses +
   contraintes Azure-Infra extraites).
2. Délègue la génération au sous-agent **cdc-architecte** en lui transmettant ce brief intégral.
   Il doit produire la documentation dans `docs/` (vue d'ensemble, architecture C4 Mermaid,
   modèle de données, API, sécurité/RGPD, infrastructure Azure + ports) et le fichier
   `docs/PROMPT-DEMARRAGE.md`.

## Phase 4 — Restituer
Présente-moi : la liste des fichiers `docs/` créés, les ADR (décisions) clés, les hypothèses
laissées ouvertes, et **affiche le contenu de `docs/PROMPT-DEMARRAGE.md`** pour que je puisse
le copier immédiatement dans une nouvelle session Claude Code.

**Étape suivante (chaînage)** : propose-moi de planifier les stories MVP (Must) du backlog une
à une via l'agent `cdc-story-plan` (`/planifier-story <US-id> <backlog.md> <docs/>`). Pour tout
orchestrer depuis le départ, renvoie vers **`/cadrer-projet`**.
