# ADR-0004 — Back-end : NestJS + Prisma

**Statut :** Accepté (2026-06-22) · **Contexte :** PEPITE / SI-2026-014

## Contexte
L'applicatif comporte une logique métier non triviale : relances automatiques programmées,
export vers la production comptable, piste d'audit, gestion fine des habilitations, signatures
d'URLs Blob. Stack imposée : Node.js + TypeScript.

## Options
1. **NestJS + Prisma** : framework structuré, modulaire, TS-first.
2. **Fastify + Drizzle** : plus léger, SQL-first.
3. **Minimal** : Supabase/PostgREST direct + petits jobs Node.

## Décision
**Option 1 — NestJS + Prisma.** Architecture modulaire (modules missions, demandes, pièces,
relances, export, audit), injection de dépendances, guards/intercepteurs pour l'autorisation
et l'audit, OpenAPI auto-généré. Prisma en multiSchema (`pepite` + `core`). Jobs asynchrones
via BullMQ (Redis).

## Conséquences
- (+) Structure durable et testable adaptée à une vraie logique métier.
- (+) Guards centralisent l'autorisation (avec RLS en défense en profondeur).
- (+) OpenAPI facilite l'intégration et la réversibilité.
- (−) Plus verbeux qu'une approche minimale ; courbe NestJS.
- (−) Prisma + RLS : propager l'identité utilisateur par requête (intercepteur) — point d'attention.
