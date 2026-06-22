# PEPITE — Sécurité & RGPD

Résout les points **bloquants** identifiés par cdc-analyst (§4.2 du CDC : conservation,
chiffrement au repos, MFA non tranchés).

## 1. Authentification
- **Collaborateurs / managers** : Supabase Auth via **Azure AD / Entra ID** (provider déjà
  actif sur l'infra — cf. SUPABASE-CONFIG.md). Scope `openid email profile`. Claim `groups`
  Entra → mapping vers le rôle applicatif (`admin`/`manager`/`collaborateur`).
- **Clients externes** : Supabase Auth **email + mot de passe** + **MFA TOTP** (déjà activé
  par défaut). Confirmation d'email via **relais Microsoft Graph** (pas de SMTP — pattern
  existant). ⚠️ Prérequis : activer `Mail.Send` + secret du relais (cf. recette infra).
- **MFA** : TOTP **obligatoire** pour le staff ; **fortement recommandé/imposable** côté client
  vu la sensibilité (données financières/paie).
- **Tokens** : JWT Supabase vérifiés par NestJS via JWKS ; durée courte + refresh.

> ⚠️ Pièges Azure AD déjà documentés côté infra (à respecter) : `AZURE_URL` sans `/v2.0`,
> scope `email` obligatoire, buffers nginx élargis pour le callback OAuth.

## 2. Autorisation (moindre privilège)
Matrice du CDC (§4.3) appliquée via **guards NestJS** (source de vérité) + **RLS** Postgres
(défense en profondeur) :

| Rôle | Périmètre | L | C/M | Suppr. | Admin |
|---|---|---|---|---|---|
| Administrateur | Tous dossiers | ✓ | ✓ | ✓ | ✓ |
| Manager | Son portefeuille | ✓ | ✓ | ✗ | ✗ |
| Collaborateur | Dossiers assignés | ✓ | ✓ | ✗ | ✗ |
| Client | Ses propres dépôts | ✓ (ses pièces) | dépôt | ✗ | ✗ |

Cloisonnement **par client/portefeuille** via RLS (`auth.uid()` + `pepite.app_user`).

## 3. Chiffrement
- **En transit** : TLS partout (nginx public ; services internes sur `127.0.0.1`).
- **Au repos** :
  - Postgres (Supabase) : chiffrement disque de la VM Azure.
  - **Azure Blob** : chiffrement de service (SSE) + **immutability policy (WORM)** sur le
    conteneur `pepite-<env>` pour l'inaltérabilité (valeur probante).
  - Secrets dans `.env.<env>` sur la VM (jamais commités) — convention infra.

## 4. Intégrité & valeur probante
- **Hash SHA-256** calculé et stocké à chaque dépôt (`pepite.piece.hash_sha256`).
- Conteneur Blob **WORM** (write once, read many) : pièces inaltérables 10 ans.
- **Piste d'audit** `pepite.audit_log` append-only : qui a déposé/validé/exporté quoi et quand.

## 5. Conservation des données (politique)
| Donnée | Durée | Mécanisme |
|---|---|---|
| Pièces comptables | **10 ans** (valeur probante) | Blob WORM + métadonnées |
| Données personnelles (hors obligation légale) | **3 ans après fin de mission** | Job de purge (worker) |
| Logs d'accès / piste d'audit | **12 mois** (logs techniques) / aligné obligation (audit) | Rotation + archivage |
| Comptes clients inactifs | Revue périodique | Désactivation puis purge |

## 6. Gouvernance RGPD
- **AIPD** (analyse d'impact) : **probablement requise** (données de paie + 3 500 personnes
  concernées). ⚠️ À confirmer avec le DPO **avant** mise en production — point bloquant du CDC.
- **Base légale** : exécution du contrat de mission.
- **Sous-traitance** : hébergement UE (VM Azure) ; registre des traitements à mettre à jour.
- **Droits des personnes** : export/suppression outillés (cf. réversibilité).

## 7. Surface d'exposition (portail ouvert à 3 500 externes)
- Rate limiting + verrouillage après tentatives échouées.
- Validation stricte des fichiers (type MIME réel, taille, anti-malware à prévoir).
- URLs Blob **signées et à durée courte** (jamais d'accès direct au conteneur).
- Séparation nette staff/clients dès l'authentification et dans l'UI.
