# PEPITE — Contrat d'API REST

Base : `https://pepite.<ip>.nip.io/api/v1` — proxifiée par nginx vers `127.0.0.1:8108`.
Auth : `Authorization: Bearer <JWT Supabase>`. Format : JSON. Erreurs : RFC 7807 (`application/problem+json`).

## Conventions
- Pagination : `?page=1&limit=50` → enveloppe `{ data: [...], page, limit, total }`.
- Tri/filtre : `?sort=-created_at&statut=en_cours`.
- Idempotence des uploads via `hash_sha256`.
- Codes : 200/201/204, 400, 401, 403, 404, 409 (conflit/doublon), 422 (validation), 429 (rate limit).

## Ressources principales

| Méthode | Endpoint | Rôle min. | Description |
|---|---|---|---|
| GET | `/missions` | collaborateur | Liste des missions (périmètre selon rôle/RLS) |
| POST | `/missions` | collaborateur | Crée une mission |
| GET | `/missions/{id}/demandes` | collaborateur | Demandes de pièces d'une mission |
| POST | `/demandes` | collaborateur | Crée une demande (depuis un template de checklist) |
| GET | `/demandes/{id}` | client/staff | Détail + avancement de la checklist |
| POST | `/demandes/{id}/relances` | collaborateur | Déclenche une relance manuelle |
| POST | `/checklist-items/{id}/upload-url` | client/staff | Renvoie une **URL Blob signée** pour l'upload |
| POST | `/checklist-items/{id}/pieces` | client/staff | Confirme le dépôt (métadonnées + hash) |
| GET | `/pieces/{id}/download-url` | selon RLS | URL de téléchargement signée (courte durée) |
| POST | `/pieces/{id}/valider` | collaborateur | Valide/refuse une pièce |
| GET | `/portefeuilles/{id}/tableau-de-bord` | manager | Avancement par portefeuille |
| POST | `/missions/{id}/exporter` | collaborateur | Déclenche l'export vers la production comptable |
| GET | `/admin/export?format=csv\|json` | admin | Export de réversibilité |

## Exemple — obtenir une URL d'upload

```http
POST /api/v1/checklist-items/8f2.../upload-url
Authorization: Bearer eyJ...
```
```json
{
  "uploadUrl": "https://<account>.blob.core.windows.net/pepite-prod/...&sig=...",
  "blobUri": "pepite-prod/2026/mission-123/piece-abc.pdf",
  "expiresIn": 600,
  "maxBytes": 26214400,
  "requiredHashHeader": "x-ms-blob-content-md5"
}
```

Puis confirmation :
```http
POST /api/v1/checklist-items/8f2.../pieces
{ "blobUri": "...", "nomFichier": "facture.pdf", "mime": "application/pdf",
  "tailleOctets": 184320, "hashSha256": "9f86d0818..." }
```

## Sécurité transverse
- Validation stricte des entrées (class-validator) ; limites de taille (25 Mo) et types MIME (PDF/images).
- Rate limiting sur les endpoints clients (anti-abus).
- Toute écriture journalisée dans `pepite.audit_log`.
- Documentation OpenAPI auto-générée par NestJS (`/api/docs`, accès restreint).
