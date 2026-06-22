# Plan d'implémentation — US-010 : Déposer un fichier (client)

| | |
|---|---|
| **ID / Epic** | US-010 / EPIC-03 — Dépôt & gestion des pièces |
| **Priorité** | Must (MVP) · **Estimation backlog** : 8 pts |
| **Dépendances** | US-002 (schéma + RLS), US-004 (auth client + MFA) |
| **Traçabilité** | EF-01, docs/03-api, docs/02-modele-donnees, **ADR-0003** (stockage hybride Blob+métadonnées) |

## Story & critères d'acceptation
**En tant que** client, **je veux** déposer mes pièces (PDF/images, < 25 Mo) **afin de** répondre à la demande.
- **CA-1** : *Étant donné* une demande, *quand* je dépose un fichier valide, *alors* il est envoyé vers Azure Blob via URL signée et l'item passe à « reçue ».
- **CA-2** : *Étant donné* un fichier > 25 Mo ou de type non autorisé, *quand* je tente le dépôt, *alors* il est rejeté avec un message clair.

## Objectif technique & approche
Upload **direct client → Azure Blob** via une **URL signée (SAS) à durée courte** générée par
l'API (le fichier ne transite pas par l'API → perf et tenue des pics ×5, cf. docs/01-architecture).
L'API ne fait que (1) autoriser + émettre la SAS, puis (2) **confirmer** le dépôt en
enregistrant les métadonnées et le hash dans `pepite.piece`, et mettre l'item de checklist à
« reçue ». Conforme à ADR-0003 et au flux de docs/03-api.

## Impact modèle de données (cf. docs/02-modele-donnees)
- Table `pepite.piece` : **déjà prévue** (blob_uri, nom_fichier, mime, taille_octets, hash_sha256, statut). Aucune nouvelle table.
- `pepite.checklist_item.statut` : transition `attendue → recue`.
- **Migration** : ajouter une contrainte d'unicité `(checklist_item_id, hash_sha256)` pour
  l'idempotence (re-dépôt du même fichier = pas de doublon → CA robuste).
- **RLS** : policy d'**insert** sur `pepite.piece` autorisant uniquement le client propriétaire
  de la mission liée (via `checklist_item → demande → mission.client_id = app_user.client_id`).

## Contrats d'API (cf. docs/03-api)
1. `POST /api/v1/checklist-items/{id}/upload-url`
   - **Auth** : client/staff autorisé sur l'item. **Réponse** : `{ uploadUrl, blobUri, expiresIn, maxBytes: 26214400, allowedMime: ["application/pdf","image/png","image/jpeg"] }`.
   - Erreurs : 403 (non autorisé), 404 (item inconnu), 409 (item déjà validé/clos).
2. `POST /api/v1/checklist-items/{id}/pieces` (confirmation)
   - **Body** : `{ blobUri, nomFichier, mime, tailleOctets, hashSha256 }`.
   - **Effet** : crée `pepite.piece`, passe l'item à « reçue », écrit l'audit.
   - Erreurs : **413** (taille > 25 Mo), **415** (type non autorisé), 409 (hash déjà présent), 422 (blob introuvable/incohérent).

## Back-end (NestJS)
- `pieces/` : `PiecesModule`, `PiecesController`, `PiecesService`.
- `storage/` : `BlobService` (Azure SDK `@azure/storage-blob`) — génère la SAS (user delegation
  key), valide l'existence/propriétés du blob à la confirmation.
- **Guards** : `ChecklistItemOwnershipGuard` (le client ne peut agir que sur ses items — défense
  applicative en plus de la RLS).
- **Validation** : `class-validator` sur le DTO ; vérification du **MIME réel** (magic bytes,
  pas seulement l'extension) côté confirmation ; contrôle `tailleOctets ≤ 25 Mo`.
- **Audit** : entrée `pepite.audit_log` (`action=PIECE_DEPOSEE`, acteur, item, hash).

## Front-end (Vue 3 + TS)
- Vue `DemandeDetail.vue` → composant `DepotPiece.vue` (drag-and-drop + sélecteur).
- **Validation client** (CA-2, retour immédiat) : type ∈ {PDF, PNG, JPEG} et taille ≤ 25 Mo
  **avant** toute requête ; message d'erreur clair sinon.
- Flux : demander `upload-url` → `PUT` direct vers `uploadUrl` (barre de progression) → calcul
  du **SHA-256** (Web Crypto) → `POST .../pieces` pour confirmer → MAJ optimiste du statut.
- **Store Pinia** `piecesStore` (état d'upload, erreurs, statut des items).
- États UI : en cours / succès / refus (taille|type) / échec réseau (avec reprise).

## Sécurité & RGPD spécifiques
- Autorisation double : **RLS** (insert) + **guard** NestJS ; un client ne dépose que sur ses items.
- SAS **scoping minimal** (write-only, blob unique, expiration courte) ; jamais d'accès au conteneur.
- Conteneur Blob **WORM** (ADR-0003) — l'écriture est unique ; gérer le cas re-dépôt via nouveau blob + idempotence par hash.
- **Antivirus** : prévoir un scan (post-upload) — ⚠️ voir questions ouvertes.
- Journalisation systématique ; aucune donnée sensible dans les logs (pas de contenu de fichier).

## Plan de tâches séquencé
- [ ] **T1** — Migration : contrainte unicité `(checklist_item_id, hash_sha256)` + policy RLS insert sur `pepite.piece` *(≈2 h)* — `prisma/migrations`, SQL `pepite`
- [ ] **T2** — `BlobService.generateUploadSas()` (user delegation SAS, write-only, TTL court) *(≈3 h)* — `apps/api/src/storage/blob.service.ts`
- [ ] **T3** — `POST upload-url` (contrôleur + guard ownership) *(≈2 h)* — `apps/api/src/pieces/`
- [ ] **T4** — `POST pieces` (confirmation : vérif blob, MIME réel, taille, création piece, MAJ item, audit) *(≈4 h)* — `pieces.service.ts`
- [ ] **T5** — Front `DepotPiece.vue` + validation client + progression + SHA-256 Web Crypto *(≈4 h)* — `apps/web/src/components/`
- [ ] **T6** — `piecesStore` Pinia + intégration dans `DemandeDetail.vue` *(≈2 h)*
- [ ] **T7** — Tests unitaires + e2e (cf. ci-dessous) *(≈4 h)*
- [ ] **T8** — Accessibilité du composant d'upload (clavier, libellés ARIA, messages d'erreur) *(≈1 h)*

**Total : 8 tâches · ≈22 h** (cohérent avec l'estimation de 8 pts).

## Stratégie de tests (critères → tests)
| Critère | Test(s) |
|---|---|
| CA-1 (dépôt valide → Blob + item « reçue ») | e2e : upload PDF valide → 201, `piece` créée, item=reçue, audit écrit ; unit : `PiecesService.confirm()` |
| CA-2 (refus > 25 Mo) | unit front (validation) + e2e API : confirmation 26 Mo → **413** |
| CA-2 (refus type non autorisé) | unit front + e2e API : `.exe`/MIME falsifié → **415** (vérif magic bytes) |
| Sécurité (cloisonnement) | e2e : client A tente sur item de client B → **403** (guard) et insert RLS refusé |
| Idempotence | e2e : re-dépôt du même hash → **409** (pas de doublon) |
Données de test **anonymisées** (faux PDF/images générés).

## Pré-requis & dépendances
- US-002 (schéma `pepite` + RLS + rôle) et US-004 (auth client + MFA JWT) **livrées**.
- Conteneur Blob `pepite-<env>` et clé de délégation disponibles côté config (`.env.<env>`).
- *(Conception uniquement — pas de création réelle de ressource Azure ici.)*

## Definition of Done
Code revu/mergé · tests unitaires + e2e verts couvrant chaque CA · RLS + guard testés ·
accessibilité du composant vérifiée · audit en place · documentation API (OpenAPI) à jour ·
démontré en recette (dépôt valide + refus taille/type + tentative inter-clients).

## Risques & questions ouvertes
- ⚠️ **Antivirus** : le CDC ne le mentionne pas, mais un portail ouvert à 3 500 externes l'exige.
  **Question** : intègre-t-on un scan (ex. ClamAV / Defender) avant validation de la pièce ? (proposition à valider)
- ⚠️ **WORM vs re-dépôt** : l'immutability empêche l'écrasement ; convention retenue = nouveau
  blob + idempotence par hash. À confirmer avec la politique de versioning Blob.
- **Blobs orphelins** : upload sans confirmation → prévoir un job de nettoyage des blobs non confirmés (story d'amélioration séparée ?).
