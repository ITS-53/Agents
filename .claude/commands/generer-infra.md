---
description: Génère les artefacts de déploiement (compose, nginx, CI, .env) alignés sur Azure-Infra, avec allocation de ports sans collision
argument-hint: <chemin docs/ d'architecture>
---

Génère les artefacts d'infrastructure à partir de : $ARGUMENTS

> 🔒 Conception uniquement : ne touche jamais aux VMs réelles ; produis des fichiers + un projet de PR.

1. Le 1er argument est le dossier `docs/` d'architecture (sortie de `cdc-architecte`). Lis-le.
2. Lis le repo **`ITS-53/Azure-Infra`** via `gh` : `docs/PORTS.md` (ports occupés + tranches),
   `prod/nginx/` (format upstreams + vhosts), layout `/opt/stacks`, `docs/DATABASE.md`.
3. Délègue à l'agent **infra-azure** → écrit dans `deploy/` (compose, Dockerfiles, nginx,
   `.env.example`, GitHub Actions) + `deploy/PR-Azure-Infra.md`.
4. Présente-moi : le **tableau des ports alloués** (en confirmant l'absence de collision), la
   liste des fichiers générés, et le contenu de `deploy/PR-Azure-Infra.md` à porter dans Azure-Infra.
