# PEPITE — Vue d'ensemble technique

> Portail de collecte de pièces clients (code SI-2026-014). Proposition d'architecture
> issue du dossier de compréhension `PEPITE-comprehension.md` et du cadrage technique
> (grill-me) du 2026-06-22. **Document de conception — aucun déploiement réel n'a été effectué.**

## Problème & objectif
Remplacer une collecte de pièces comptables éclatée (e-mails + dossiers partagés, 30 % de
dossiers en retard) par un **portail web** où les clients déposent leurs pièces, avec
checklist paramétrable, relances automatiques, validation de complétude et export vers la
production comptable. Cibles : −40 % de délai de collecte, NPS > 40.

## Utilisateurs
~120 collaborateurs (interne, Azure AD), ~25 managers de portefeuille, ~3 500 clients
externes (email + MFA). Saisonnalité forte : **pics ×5** aux clôtures.

## Décisions d'architecture arrêtées
| Domaine | Choix | ADR |
|---|---|---|
| Front-end | Vue 3 + TypeScript + Vite + Pinia + Vue Router | — |
| Back-end | NestJS + Prisma (TypeScript) | [ADR-0004](adr/ADR-0004-backend-framework.md) |
| Base de données | Supabase self-hosted **greffé** : schéma `pepite` + `core` partagé, RLS | [ADR-0001](adr/ADR-0001-choix-base-de-donnees.md) |
| Authentification | Supabase Auth — Azure AD (staff) + email/MFA (clients) | [ADR-0002](adr/ADR-0002-authentification.md) |
| Stockage des pièces | Hybride : Azure Blob (WORM) + métadonnées en base | [ADR-0003](adr/ADR-0003-stockage-fichiers.md) |
| Conteneurisation | Docker (multi-stage + compose), layout `/opt/stacks/pepite` | — |
| Déploiement | Frontend `127.0.0.1:8107`, API `127.0.0.1:8108`, vhost `pepite.<ip>.nip.io` | — |
| CI/CD | GitHub Actions build/test (déploiement manuel) | — |

## Contraintes non négociables (rappel)
- **RGPD** : chiffrement transit (TLS) + repos, MFA, durées de conservation, cloisonnement RLS.
- **Valeur probante** : pièces conservées 10 ans en stockage **immuable (WORM)** + hash SHA-256 + piste d'audit.
- **Azure-Infra** : ports par tranches, écoute sur `127.0.0.1` uniquement, nginx seul exposé. Pas de collision de ports.
- **Réversibilité** : export CSV/JSON, propriété groupe, doc technique.
- **Convention BDD** : 1 schéma par app + `core` partagé, 1 rôle PG par app, RLS.

## Documents de référence
- [01-architecture.md](01-architecture.md) — architecture C4, topologie, flux.
- [02-modele-donnees.md](02-modele-donnees.md) — modèle de données, DDL, RLS.
- [03-api.md](03-api.md) — contrat d'API REST.
- [04-securite-rgpd.md](04-securite-rgpd.md) — auth, chiffrement, conservation, audit.
- [05-infrastructure-azure.md](05-infrastructure-azure.md) — Docker, ports, environnements, CI/CD.
- [adr/](adr/) — décisions d'architecture (ADR).
- [PROMPT-DEMARRAGE.md](PROMPT-DEMARRAGE.md) — **prompt à coller dans une nouvelle session Claude Code**.
