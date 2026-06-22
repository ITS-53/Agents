---
description: "Crée/alimente un GitHub Project (Kanban + Roadmap + Table) depuis le backlog. Agit réellement sur GitHub via gh, avec prévisualisation et confirmation."
argument-hint: <chemin backlog.md> [--owner <user|org>] [--repo <owner/repo>] [--title "..."]
---

Tu vas publier le backlog dans un GitHub Project. **Tu agis réellement sur GitHub** : procède
avec prévisualisation et confirmation. Entrée : $ARGUMENTS

## Phase 1 — Pré-requis (scope gh)
Vérifie le scope `project` : `gh auth status`. S'il manque (`read:project`/`project` absents),
**arrête-toi** et demande-moi de lancer `gh auth refresh -s project --hostname github.com`, puis
de relancer la commande. Ne tente rien sans ce scope.

## Phase 2 — Cible & paramètres
1. Lis `backlog/backlog.md` (et `chiffrage/chiffrage.md` s'il existe, pour dates/estimations).
2. Détermine les paramètres ; si non fournis en arguments, **demande-moi** :
   - **Propriétaire** du projet : mon compte (`ITS-Corentyn`) ou l'orga (`ITS-53`) ?
   - **Repo des issues** : où créer les issues (ex. `ITS-53/pepite-app`) ? (les items du board sont des issues d'un repo)
   - **Titre** du projet (ex. « PEPITE — Delivery »).

## Phase 3 — Prévisualisation & confirmation
Affiche un **plan** : titre du projet, propriétaire, repo, **nombre d'issues** à créer (epics +
stories), champs à créer (Statut, Priorité, Estimation, Epic, Type, Sprint, Début, Cible),
et ce qui existe déjà (idempotence). **Demande « on publie ? »** et attends mon accord.

## Phase 4 — Exécution
Après accord, délègue à l'agent **github-project** avec les paramètres validés. Il crée/réutilise
le projet, les champs, les issues (sans doublon), les ajoute au board et renseigne les champs
(dates issues du chiffrage si dispo).

## Phase 5 — Restituer
Donne-moi : l'**URL du projet**, le récap (issues créées vs déjà présentes), et la **config des
vues à finaliser dans l'UI** : Kanban groupé par `Statut`, **Roadmap** sur `Début`/`Cible`
(le « GANTT » de GitHub), Table groupée par `Epic`/`Sprint`. Rappelle que pour un GANTT à
dépendances, le `chiffrage/chiffrage.md` contient un diagramme Mermaid complémentaire.
