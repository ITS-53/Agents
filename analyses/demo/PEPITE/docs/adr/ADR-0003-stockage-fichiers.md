# ADR-0003 — Stockage des pièces : hybride Azure Blob (WORM) + métadonnées en base

**Statut :** Accepté (2026-06-22) · **Contexte :** PEPITE / SI-2026-014

## Contexte
~500 000 pièces/an, conservation **10 ans à valeur probante**, soit plusieurs millions de
fichiers et un volume cumulé important. Le disque de la VM STAGING est déjà à 90 %.

## Options
1. **Supabase Storage** : intégré à l'auth/RLS, mais sur le disque de la VM Supabase.
2. **Azure Blob** : scalable, lifecycle, immutability/WORM.
3. **Hybride** : fichiers dans Azure Blob (WORM), métadonnées/index/permissions en base `pepite`.

## Décision
**Option 3 — Hybride.** Fichiers dans **Azure Blob** (conteneur `pepite-<env>` avec
immutability policy WORM + chiffrement SSE) ; métadonnées, statuts, permissions et **hash
SHA-256** dans le schéma `pepite`. Accès via **URLs signées à durée courte**.

## Conséquences
- (+) Scalabilité et durabilité adaptées à 10 ans / millions de fichiers ; ne sature pas les VMs.
- (+) WORM + hash = inaltérabilité / valeur probante.
- (+) Upload direct client→Blob (URL signée) → sort les gros transferts du chemin API (perf pics ×5).
- (−) Plomberie backend : génération d'URLs signées, cohérence métadonnées↔Blob, gestion des orphelins.
- (−) Politique de cycle de vie et coûts de stockage à suivre (TCO récurrent — lacune du CDC).
