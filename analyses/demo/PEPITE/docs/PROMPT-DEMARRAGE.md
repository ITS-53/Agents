# Prompt de démarrage — PEPITE (à coller dans une nouvelle session Claude Code)

> Copie tout le bloc ci-dessous dans une nouvelle session Claude Code, ouverte à la racine
> d'un repo vide destiné à l'application PEPITE (avec ce dossier `docs/` à la racine).

---

Tu es l'**agent d'implémentation du projet PEPITE** (SI-2026-014), un portail web de collecte
de pièces clients pour un cabinet d'expertise comptable. Ton objectif : **échafauder puis
développer** l'application décrite ci-dessous, en respectant strictement l'architecture déjà
arrêtée. Avant d'écrire du code, lis les documents de référence listés plus bas.

## Contexte projet (condensé)
Les clients du cabinet déposent leurs pièces comptables (factures, relevés, justificatifs) via
un portail web. Fonctions v1 (Must) : dépôt de fichiers (PDF/images, <25 Mo), checklist de
pièces paramétrable par type de mission, relances automatiques, validation de complétude par
le collaborateur, export vers la production comptable. Utilisateurs : ~145 collaborateurs/
managers (interne) et ~3 500 clients externes. Saisonnalité : pics ×5 aux clôtures.

## Stack & décisions d'architecture (NON négociables)
- **Front** : Vue 3 + TypeScript + Vite + Pinia + Vue Router ; `@supabase/supabase-js` pour le login.
- **Back** : NestJS + Prisma (TypeScript), multiSchema `pepite` + `core`. Jobs via BullMQ (Redis).
- **BDD** : Supabase self-hosted **greffé** → schéma `pepite` + schéma `core` partagé (lecture
  seule), **RLS** activée, rôle PG dédié `pepite_app`. Migrations dev→staging→prod.
- **Auth** : Supabase Auth — Azure AD/Entra (staff) + email/mot de passe + **MFA TOTP** (clients).
- **Stockage** : **Azure Blob (WORM)** pour les fichiers + métadonnées + **hash SHA-256** en base.
  Upload/download par **URLs signées à durée courte**.
- **Conteneurisation** : Docker multi-stage + `compose.yml`. Layout cible `/opt/stacks/pepite/`.
- **Ports (Azure-Infra, écoute 127.0.0.1)** : `pepite-web` → **8107**, `pepite-api` → **8108** ;
  Supabase API partagé sur 8400. Ne JAMAIS entrer en collision avec les ports existants.
- **CI/CD** : GitHub Actions build/test (lint, typecheck, tests, build images) ; déploiement manuel.

## Documentation de référence (à lire AVANT de coder)
- `docs/00-vue-ensemble.md` · `docs/01-architecture.md` · `docs/02-modele-donnees.md`
- `docs/03-api.md` · `docs/04-securite-rgpd.md` · `docs/05-infrastructure-azure.md`
- `docs/adr/ADR-0001..0004` (décisions et leurs conséquences).
- **`backlog/backlog.md`** — epics et user stories priorisées (MoSCoW), critères d'acceptation
  et traçabilité. **C'est ta liste de travail.** (`backlog/backlog.csv` = même contenu, importable.)

## Contraintes non négociables
- **RGPD** : chiffrement transit + repos ; MFA ; conservation (pièces 10 ans WORM ; données
  perso purgées 3 ans après fin de mission ; logs 12 mois) ; AIPD à valider avec le DPO avant prod.
- **Valeur probante** : Blob WORM + hash SHA-256 + piste d'audit append-only (`pepite.audit_log`).
- **Cloisonnement** : RLS Postgres + guards NestJS (un client ne voit que ses pièces ; staff selon périmètre).
- **Azure-Infra** : tranches de ports, `127.0.0.1` uniquement, nginx seul exposé.
- **Réversibilité** : export CSV/JSON, OpenAPI, migrations versionnées.
- **Accessibilité** : RGAA/WCAG AA, responsive, i18n FR.
- **Performance** : <2 s p95 (<5 s au pic ×5) ; services stateless scalables horizontalement.

## Plan d'implémentation (séquencé)
1. **Scaffold monorepo** : `apps/web` (Vue), `apps/api` (NestJS), `packages/shared` (types DTO),
   `docker/`, `prisma/`. Outils : pnpm workspaces, ESLint/Prettier, Vitest/Jest.
2. **Base de données** : schéma Prisma (`pepite` + `core` en lecture), migrations, policies RLS,
   rôle `pepite_app`. Seed minimal pour le dev (Supabase CLI local).
3. **Auth** : intégration Supabase Auth (Azure AD + email/MFA), vérification JWT (JWKS) côté
   NestJS, mapping `groups`→rôle, guards d'autorisation.
4. **Modules métier (par priorité MoSCoW)** : missions → demandes/checklists (EF-02) → dépôt de
   pièces avec URLs Blob signées (EF-01) → relances auto worker (EF-03) → prévisualisation
   (EF-04) → tableau de bord portefeuille (EF-05) → export production comptable.
5. **Sécurité & audit** : chiffrement, journalisation `audit_log`, rate limiting, validation des fichiers.
6. **Tests** : unitaires + e2e (Postgres éphémère), tests de charge ciblant le pic ×5.
7. **Docker & CI** : Dockerfiles multi-stage, `compose.yml`, workflow GitHub Actions build/test.

## Méthode de travail : story par story (plan → code)
Le `backlog/backlog.md` est ta liste de travail. **Pour chaque user story, en commençant par le
MVP (Must) et en respectant l'ordre des dépendances** :
1. **Produis d'abord un plan d'implémentation détaillé** de la story, puis fais-le valider —
   **ne code jamais une story sans plan validé**.
2. Le plan doit contenir : en-tête (ID/priorité/dépendances/traçabilité) · story + critères
   d'acceptation · approche technique · impact modèle de données (migrations, RLS) · contrats
   d'API (endpoints/DTOs) · back-end (modules NestJS) · front-end (composants Vue/Pinia) ·
   sécurité & RGPD · plan de tâches séquencé estimé · **tests mappés aux critères d'acceptation**
   · definition of done · risques/questions ouvertes.
3. Une fois le plan validé, **implémente** la story, écris les tests couvrant chaque critère
   d'acceptation, et vérifie la definition of done avant de passer à la suivante.

## Définition de « terminé » (critères d'acceptation)
- CA-01 : toutes les exigences **Must** (EF-01, EF-02, EF-03) opérationnelles et testées.
- CA-02 : tenue de charge au pic ×5 vérifiée (<5 s p95) — désormais mesurable (cible fixée).
- RGPD : MFA actif, chiffrement repos+transit, conservation/purge implémentées, audit complet.
- Réversibilité : export CSV/JSON fonctionnel ; OpenAPI publié.

## Première action attendue
Ne code rien tout de suite. **Commence par** :
1. lire les `docs/*` **et `backlog/backlog.md`** ci-dessus ;
2. me proposer l'**arborescence détaillée du monorepo** (pnpm workspaces) et la liste des
   dépendances clés, pour validation ;
3. après mon accord, créer le **scaffold** (sans logique métier) et le schéma Prisma initial ;
4. puis produire le **plan d'implémentation détaillé de la première story MVP** (selon la
   « Méthode de travail » ci-dessus) et me le soumettre avant de coder.

Pose-moi toute question bloquante avant de démarrer.
