# PEPITE — Backlog produit

> Généré par `cdc-backlog` depuis `PEPITE-comprehension.md` + `docs/` (architecture).
> Estimations en story points (Fibonacci) — **indicatives**, à affiner en planning poker.

## 1. Synthèse
- **6 epics**, **28 items** (26 stories estimées + 1 « Could » + 1 « Won't »).
- **MoSCoW** : 18 Must · 8 Should · 1 Could · 1 Won't.
- **Total estimé** : ~123 pts (hors Won't). **Périmètre MVP (Must)** : ~84 pts.
- **1 story bloquée par une lacune** : US-026 (AIPD RGPD — validation DPO).

## 2. Proposition de roadmap / MVP
- **Sprint 0 — Socle** : US-001, US-002, US-003, US-004 (scaffold, BDD+RLS, auth staff + client/MFA).
- **Sprint 1 — Cœur de collecte (MVP)** : US-007, US-008, US-009, US-010, US-011, US-012, US-013.
- **Sprint 2 — Relances & export (MVP)** : US-015, US-016, US-019, US-021, US-022, US-024.
- **Sprint 3 — Pilotage & confort** : US-005, US-006, US-014, US-017, US-018, US-020, US-023, US-025.
- **Backlog ultérieur** : US-027 (OCR, Could). **Exclu v1** : US-028 (signature, Won't).
- 🔒 **Jalon bloquant avant prod** : US-026 (AIPD) doit être levée.

> Le **MVP** = tous les Must (EF-01/02/03 + socle sécurité/RGPD + export). Il couvre le processus
> cible de bout en bout : créer une demande → le client dépose → relances → validation → export.

## 3. Epics
| ID | Epic | Objectif | Stories |
|---|---|---|---|
| EPIC-01 | Socle technique & sécurité | Fondations applicatives, auth, déploiement | US-001→006 |
| EPIC-02 | Gestion des demandes de pièces | Missions, checklists paramétrables, demandes | US-007→009 |
| EPIC-03 | Dépôt & gestion des pièces | Dépôt client, intégrité, validation | US-010→014 |
| EPIC-04 | Relances & notifications | Notifications et relances auto/manuelles | US-015→017 |
| EPIC-05 | Pilotage & export comptable | Tableau de bord, export production comptable | US-018→020 |
| EPIC-06 | Conformité, RGPD & réversibilité | Audit, conservation, droits, accessibilité, AIPD | US-021→026 |

---

## 4. User stories

### EPIC-01 — Socle technique & sécurité

#### US-001 — Scaffold du monorepo
- **En tant que** équipe technique, **je veux** un monorepo structuré (web, api, shared, docker) **afin de** démarrer le développement sur des bases saines.
- **CA :**
  - *Étant donné* le dépôt vide, *quand* le scaffold est créé, *alors* `apps/web` (Vue 3+TS), `apps/api` (NestJS), `packages/shared`, lint/format et tests s'exécutent sans erreur.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : — · **Traçabilité** : docs/01-architecture, PROMPT-DEMARRAGE

#### US-002 — Schéma BDD `pepite` + `core` + RLS
- **En tant que** équipe technique, **je veux** le schéma `pepite` greffé (+ `core` en lecture), avec RLS et rôle PG dédié **afin de** disposer d'un modèle de données cloisonné.
- **CA :**
  - *Étant donné* l'instance Supabase, *quand* les migrations sont jouées, *alors* le schéma `pepite`, le rôle `pepite_app` et les policies RLS existent.
  - *Étant donné* un utilisateur client, *quand* il interroge les missions, *alors* il ne voit que celles de son `client_id`.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-001 · **Traçabilité** : docs/02-modele-donnees, ADR-0001

#### US-003 — Authentification collaborateurs (Azure AD)
- **En tant que** collaborateur, **je veux** me connecter via mon compte Azure AD **afin d'**accéder au portail sans nouveau mot de passe.
- **CA :**
  - *Étant donné* un collaborateur Entra, *quand* il se connecte, *alors* un JWT Supabase valide est émis et son rôle applicatif est déduit du claim `groups`.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-001, US-002 · **Traçabilité** : docs/04-securite-rgpd, ADR-0002

#### US-004 — Authentification clients (email + MFA)
- **En tant que** client, **je veux** créer un compte par email avec MFA **afin d'**accéder de façon sécurisée à mes dépôts.
- **CA :**
  - *Étant donné* un nouveau client, *quand* il s'inscrit, *alors* il reçoit un email de confirmation (relais Graph) et doit activer le MFA TOTP.
  - *Étant donné* un client, *quand* il se connecte sans 2ᵉ facteur, *alors* l'accès est refusé.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-002 · **Traçabilité** : §4.2, docs/04-securite-rgpd

#### US-005 — CI build/test (GitHub Actions)
- **En tant que** équipe technique, **je veux** un pipeline lint/typecheck/tests/build d'images **afin de** garantir la qualité à chaque push.
- **CA :** *Étant donné* une PR, *quand* le pipeline tourne, *alors* lint, typecheck, tests et build des images réussissent (déploiement manuel).
- **Priorité** : Should · **Est.** : 3 · **Dép.** : US-001 · **Traçabilité** : docs/05-infrastructure-azure

#### US-006 — Conteneurisation & déploiement
- **En tant que** équipe technique, **je veux** des Dockerfiles multi-stage + `compose.yml` (web 8107, api 8108) **afin de** déployer sous `/opt/stacks/pepite`.
- **CA :** *Étant donné* le compose, *quand* il démarre, *alors* web/api/worker/redis écoutent sur `127.0.0.1` aux ports cibles, sans collision.
- **Priorité** : Should · **Est.** : 5 · **Dép.** : US-001 · **Traçabilité** : docs/05-infrastructure-azure

### EPIC-02 — Gestion des demandes de pièces

#### US-007 — Créer une mission
- **En tant que** collaborateur, **je veux** créer une mission rattachée à un client et un exercice **afin d'**organiser la collecte.
- **CA :** *Étant donné* un client de `core`, *quand* je crée une mission, *alors* elle est enregistrée avec type, exercice et portefeuille.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : US-002, US-003 · **Traçabilité** : §2.2

#### US-008 — Paramétrer un template de checklist par type de mission
- **En tant que** manager, **je veux** définir les pièces attendues par type de mission **afin de** standardiser les demandes.
- **CA :** *Étant donné* un type de mission, *quand* je configure la checklist, *alors* les items (libellé, type, obligatoire) sont réutilisables.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-002 · **Traçabilité** : **EF-02**

#### US-009 — Créer une demande de pièces depuis un template
- **En tant que** collaborateur, **je veux** générer une demande à partir d'un template **afin de** lancer la collecte rapidement.
- **CA :** *Étant donné* un template, *quand* je crée une demande pour une mission, *alors* la checklist est instanciée avec une date d'échéance.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : US-008 · **Traçabilité** : EF-02, §2.2

### EPIC-03 — Dépôt & gestion des pièces

#### US-010 — Déposer un fichier (client)
- **En tant que** client, **je veux** déposer mes pièces (PDF/images, < 25 Mo) **afin de** répondre à la demande.
- **CA :**
  - *Étant donné* une demande, *quand* je dépose un fichier valide, *alors* il est envoyé vers Azure Blob via URL signée et l'item passe à « reçue ».
  - *Étant donné* un fichier > 25 Mo ou de type non autorisé, *quand* je tente le dépôt, *alors* il est rejeté avec un message clair.
- **Priorité** : Must · **Est.** : 8 · **Dép.** : US-002, US-004 · **Traçabilité** : **EF-01**, docs/03-api, ADR-0003

#### US-011 — Intégrité & conservation à valeur probante
- **En tant que** cabinet, **je veux** un hash SHA-256 et un stockage WORM **afin de** garantir l'inaltérabilité des pièces 10 ans.
- **CA :** *Étant donné* une pièce déposée, *quand* elle est stockée, *alors* son hash est enregistré et le conteneur Blob est en immutability (WORM).
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-010 · **Traçabilité** : §7, docs/04-securite-rgpd

#### US-012 — Valider ou refuser une pièce
- **En tant que** collaborateur, **je veux** valider/refuser une pièce avec motif **afin de** garantir la conformité.
- **CA :** *Étant donné* une pièce reçue, *quand* je la valide ou la refuse, *alors* son statut change et l'action est journalisée.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : US-010 · **Traçabilité** : §2.2, §4.3

#### US-013 — Suivi de complétude de la checklist
- **En tant que** collaborateur, **je veux** voir l'avancement d'une demande **afin de** savoir ce qui manque.
- **CA :** *Étant donné* une demande, *quand* je l'ouvre, *alors* je vois les items reçus/validés/manquants et un taux de complétude.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : US-009, US-012 · **Traçabilité** : §2.2

#### US-014 — Prévisualiser une pièce
- **En tant que** collaborateur, **je veux** prévisualiser une pièce sans la télécharger **afin de** gagner du temps.
- **CA :** *Étant donné* une pièce PDF/image, *quand* je clique « aperçu », *alors* elle s'affiche via une URL signée à durée courte.
- **Priorité** : Should · **Est.** : 5 · **Dép.** : US-010 · **Traçabilité** : **EF-04**

### EPIC-04 — Relances & notifications

#### US-015 — Notifier le client à la création d'une demande
- **En tant que** client, **je veux** être notifié quand une demande m'est adressée **afin de** déposer mes pièces à temps.
- **CA :** *Étant donné* une demande créée, *quand* elle est publiée, *alors* le client reçoit un email (relais Graph) avec le lien.
- **Priorité** : Must · **Est.** : 3 · **Dép.** : US-009 · **Traçabilité** : §2.2

#### US-016 — Relances automatiques programmables
- **En tant que** collaborateur, **je veux** des relances automatiques tant que des pièces manquent **afin de** réduire les relances manuelles.
- **CA :**
  - *Étant donné* une demande incomplète et échue, *quand* le worker s'exécute, *alors* une relance est envoyée et enregistrée selon la cadence configurée.
  - *Étant donné* une demande complétée, *quand* le worker s'exécute, *alors* aucune relance n'est envoyée.
- **Priorité** : Must · **Est.** : 8 · **Dép.** : US-013, US-015 · **Traçabilité** : **EF-03**

#### US-017 — Relance manuelle
- **En tant que** collaborateur, **je veux** déclencher une relance ponctuelle **afin de** gérer les cas particuliers.
- **CA :** *Étant donné* une demande, *quand* je clique « relancer », *alors* un email est envoyé et tracé.
- **Priorité** : Should · **Est.** : 2 · **Dép.** : US-016 · **Traçabilité** : §4.3

### EPIC-05 — Pilotage & export comptable

#### US-018 — Tableau de bord d'avancement par portefeuille
- **En tant que** manager, **je veux** une vue d'avancement de mon portefeuille **afin de** prioriser les actions.
- **CA :** *Étant donné* mon portefeuille, *quand* j'ouvre le tableau de bord, *alors* je vois le statut des demandes et les retards.
- **Priorité** : Should · **Est.** : 5 · **Dép.** : US-013 · **Traçabilité** : **EF-05**

#### US-019 — Export vers la production comptable
- **En tant que** collaborateur, **je veux** exporter les pièces validées + métadonnées vers la production comptable **afin d'**éviter la ressaisie.
- **CA :** *Étant donné* une demande validée, *quand* je lance l'export, *alors* pièces et métadonnées sont transmises via l'API REST et l'état d'export est tracé.
- **Priorité** : Must · **Est.** : 8 · **Dép.** : US-012, US-013 · **Traçabilité** : §1.3, §6.1

#### US-020 — Robustesse de l'export (rejeu)
- **En tant que** collaborateur, **je veux** un rejeu automatique en cas d'échec d'export **afin de** fiabiliser le flux.
- **CA :** *Étant donné* un échec d'export, *quand* le worker réessaie, *alors* l'export aboutit ou alerte après N tentatives.
- **Priorité** : Should · **Est.** : 3 · **Dép.** : US-019 · **Traçabilité** : docs/01-architecture

### EPIC-06 — Conformité, RGPD & réversibilité

#### US-021 — Piste d'audit
- **En tant que** cabinet, **je veux** une piste d'audit append-only **afin de** retracer dépôts, validations et exports.
- **CA :** *Étant donné* une action sensible, *quand* elle a lieu, *alors* une entrée immuable (acteur, action, entité, horodatage) est écrite dans `audit_log`.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-002 · **Traçabilité** : §7, docs/04-securite-rgpd

#### US-022 — Conservation & purge automatique
- **En tant que** DPO, **je veux** des durées de conservation appliquées automatiquement **afin de** respecter le RGPD.
- **CA :** *Étant donné* les politiques (pièces 10 ans ; perso 3 ans post-mission ; logs 12 mois), *quand* le job de purge s'exécute, *alors* les données échues sont purgées/anonymisées et l'action est tracée.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-002 · **Traçabilité** : docs/04-securite-rgpd (valeurs par défaut adoptées)

#### US-023 — Export de réversibilité (CSV/JSON)
- **En tant que** cabinet, **je veux** exporter toutes les données en formats ouverts **afin de** garantir la réversibilité.
- **CA :** *Étant donné* un admin, *quand* il lance l'export, *alors* il obtient les données `pepite` en CSV/JSON et les pièces ré-exportables.
- **Priorité** : Should · **Est.** : 3 · **Dép.** : US-002 · **Traçabilité** : §6.2

#### US-024 — Habilitations & matrice de droits
- **En tant que** administrateur, **je veux** que chaque rôle n'accède qu'à son périmètre **afin d'**appliquer le moindre privilège.
- **CA :**
  - *Étant donné* la matrice (§4.3), *quand* un utilisateur agit, *alors* guards NestJS + RLS autorisent/refusent conformément à son rôle et son périmètre.
  - *Étant donné* un client, *quand* il tente d'accéder aux pièces d'un autre client, *alors* l'accès est refusé.
- **Priorité** : Must · **Est.** : 5 · **Dép.** : US-002, US-003, US-004 · **Traçabilité** : **§4.3**

#### US-025 — Accessibilité RGAA/WCAG AA
- **En tant que** utilisateur, **je veux** une interface accessible (contrastes, clavier, lecteurs d'écran) **afin de** garantir l'inclusion.
- **CA :** *Étant donné* les écrans clés, *quand* on les audite, *alors* ils respectent RGAA/WCAG AA.
- **Priorité** : Should · **Est.** : 5 · **Dép.** : — · **Traçabilité** : §5.2

#### US-026 — ⚠️ AIPD RGPD validée avant prod
- **En tant que** DPO, **je veux** une analyse d'impact réalisée **afin de** autoriser la mise en production.
- **CA :** *Étant donné* le traitement (données de paie, 3 500 personnes), *quand* l'AIPD est conduite, *alors* elle est validée et les mesures sont intégrées.
- **Priorité** : Must · **Est.** : 2 · **Dép.** : — · **Traçabilité** : §4.2
- ⚠️ **Bloquée par lacune** : le CDC ne tranche pas si une AIPD est requise. **Question à lever** : le DPO confirme-t-il l'AIPD et son périmètre ?

### Hors MVP

#### US-027 — OCR de reconnaissance du type de pièce
- **En tant que** client, **je veux** que le type de pièce soit reconnu automatiquement **afin de** simplifier le dépôt.
- **Priorité** : Could · **Est.** : 8 · **Dép.** : US-010 · **Traçabilité** : **EF-06**

#### US-028 — Signature électronique des documents
- **Priorité** : **Won't (v1)** · **Traçabilité** : **EF-07** (explicitement hors périmètre v1).

---

## 5. Matrice de traçabilité (exigences → stories)
| Exigence | Stories | Couvert ? |
|---|---|---|
| EF-01 Dépôt de fichiers | US-010, US-011 | ✅ |
| EF-02 Checklist paramétrable | US-008, US-009 | ✅ |
| EF-03 Relances automatiques | US-016 (US-015, US-017) | ✅ |
| EF-04 Prévisualisation | US-014 | ✅ |
| EF-05 Tableau de bord | US-018 | ✅ |
| EF-06 OCR | US-027 (Could) | ✅ |
| EF-07 Signature | US-028 (Won't) | ⏸️ exclu v1 |
| §4.2/4.3 Sécurité & droits | US-003, US-004, US-021, US-022, US-024, US-026 | ✅ |
| §6.1 Export comptable | US-019, US-020 | ✅ |
| §6.2 Réversibilité | US-023 | ✅ |
| §5.2 Accessibilité | US-025 | ✅ |

> ✅ Aucune exigence **Must** orpheline.

## 6. Definition of Ready / Definition of Done
- **DoR** : story rédigée (INVEST), CA Gherkin présents, dépendances connues, maquette/échange métier si besoin, estimation faite, aucune lacune bloquante non levée.
- **DoD** : code revu et mergé, tests unitaires + e2e verts, CA vérifiés, sécurité/RLS testée, accessibilité vérifiée (si UI), journalisation en place, documentation à jour, démontré en recette.
