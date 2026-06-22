---
description: Génère un rapport de comité de pilotage (avancement, budget, risques, décisions) depuis l'état réel du projet
argument-hint: "[--owner <user|org> --project <numéro>] (sinon déduit l'avancement des livrables locaux)"
---

Produis le rapport de COPIL à partir de : $ARGUMENTS

1. Rassemble les sources disponibles : un **GitHub Project** si `--owner`/`--project` sont fournis
   (`gh project item-list --owner <owner> <numéro> --format json` ; nécessite le scope `read:project`),
   sinon déduis l'avancement de `backlog/backlog.md` + `plans/`. Ajoute `chiffrage/chiffrage.md`
   (budget/planning), `cadrage/comprehension.md`, `rgpd/note-dpo.md`, `cadrage/cadrage-qa-rapport.md` (risques).
2. Signale les sources manquantes (le rapport reste honnête sur ses angles morts).
3. Délègue à l'agent **comite-projet** → écrit `copil/rapport-COPIL.md`.
4. Présente-moi : la **tendance globale** (🟢/🟠/🔴), l'avancement %, les alertes budget/délai,
   et les **3 décisions attendues** du COPIL.
