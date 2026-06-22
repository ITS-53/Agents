# ADR-0001 — Base de données : Supabase greffé (schéma `pepite`)

**Statut :** Accepté (2026-06-22) · **Contexte :** PEPITE / SI-2026-014

## Contexte
Le cabinet exploite déjà une instance **Supabase self-hosted** sur VM Azure, avec plusieurs
schémas applicatifs greffés (`assets`, `grp`, `borne`, `qualineo`) et un schéma `core` partagé,
selon la convention DATABASE.md (isolation physique par environnement, compartimentage logique
par application, RLS).

## Options
1. **Supabase greffé** : nouveau schéma `pepite` + réutilisation de `core`, RLS, rôle PG dédié.
2. **PostgreSQL isolé dédié** : instance PG séparée (tranche 54xx), auth/storage à recâbler.
3. **Supabase staging, prod isolée** : compromis hybride.

## Décision
**Option 1 — Supabase greffé.** Cohérent avec l'infra existante et la convention maison ;
fournit Auth (GoTrue) et RLS nativement ; livraison la plus rapide.

## Conséquences
- (+) Réutilisation d'Azure AD, MFA, relais email Graph déjà en place.
- (+) `core` partagé évite de redupliquer clients/contacts.
- (−) Couplage à l'instance Supabase partagée → cloisonnement par **schéma + rôle + RLS** impératif.
- (−) Prisma doit gérer le multiSchema et la propagation d'identité pour la RLS (cf. 02-modele-donnees).
- Données de paie sensibles : revoir l'option « prod isolée » si l'AIPD l'exige.
