# PEPITE — Note RGPD pour le DPO

> Produite par `rgpd-dpo` depuis `PEPITE-comprehension.md` + `docs/`. **Analyse d'aide à la
> décision, pas un avis juridique** : faire valider les points sensibles par le DPO/juriste.

## 1. Synthèse & niveau de risque
**Risque : Élevé.** PEPITE traite des **données financières et sociales (paie)** de ~3 500
clients et ~145 collaborateurs, à grande échelle, via un portail ouvert à l'externe.
**Verdict AIPD : REQUISE** (données sensibles + traitement à grande échelle).

## 2. Cartographie des données
| Catégorie | Personnes concernées | Sensibilité | Source |
|---|---|---|---|
| Identité, coordonnées | Clients, contacts | Personnelle | §2.1, §4.2 |
| Données financières (factures, relevés, écritures) | Clients | Confidentielle / secret pro | §1.1, §4.2 |
| Données sociales / **paie** (bulletins) | Salariés des clients | **Sensible (cat. particulière possible)** | §4.2 |
| Comptes & journaux d'accès | Utilisateurs | Personnelle | §4.2, §7 |

## 3. Base légale
**Exécution du contrat de mission** (art. 6.1.b) pour le traitement principal (§4.2) — cohérent.
Obligations légales comptables (archivage) = base distincte pour la conservation longue.

## 4. AIPD (art. 35)
**Requise.** Critères CNIL réunis : (a) données **sensibles/hautement personnelles** (paie,
financières), (b) traitement à **grande échelle** (~3 500 personnes), (c) données de personnes
non-clientes directes (salariés des clients). Périmètre proposé : description des traitements,
nécessité/proportionnalité, mesures (cf. §5), analyse des risques (accès illégitime, fuite
inter-dossiers, altération), plan d'action. **À conduire et valider avant la mise en production.**

## 5. Mesures techniques & organisationnelles (attendu vs prévu)
| Mesure | Prévu par l'archi | Écart |
|---|---|---|
| Chiffrement en transit (TLS) | Oui (nginx, services 127.0.0.1) | — |
| Chiffrement au repos | Postgres (disque VM) + **Blob SSE/WORM** | OK (ADR-0003) |
| MFA | TOTP staff + clients | ✅ ; **confirmer MFA imposé côté client** |
| Cloisonnement | **RLS** + guards (par client/portefeuille) | OK (ADR-0001, §4.3) |
| Intégrité / valeur probante | Hash SHA-256 + WORM | OK |
| Journalisation / piste d'audit | `audit_log` append-only | OK (§7) |
| Anonymisation des jeux de test | Prévue | OK (§4.2) |
| **Antivirus / anti-malware** | **Non prévu** | 🔴 manquant (portail ouvert à 3 500 externes) |

## 6. Conservation & purge
| Catégorie | Durée | Base |
|---|---|---|
| Pièces comptables | **10 ans** (valeur probante) | Obligation légale / archivage |
| Données personnelles hors obligation | **3 ans après fin de mission** | Minimisation (purge worker) |
| Logs techniques / piste d'audit | 12 mois / aligné obligation | §4.2, §7 |

Cohérence à confirmer : articuler clairement durée « pièces 10 ans » et « perso 3 ans ».

## 7. Sous-traitance & hébergement
Hébergement **VM Azure (UE)**, Supabase **self-hosted** (pas de SaaS tiers sur les données) +
**Azure Blob**. Microsoft = sous-traitant (IaaS/Graph pour emails) → **clauses art. 28** et
registre à jour. Pas de transfert hors UE identifié (à confirmer pour Graph/Microsoft).

## 8. Droits des personnes
- Accès/rectification : via le portail (comptes clients).
- Effacement/portabilité : outillés par l'**export CSV/JSON** et la **purge** (réversibilité §6.2).
- ⚠️ Information des personnes (mentions, politique de confidentialité du portail) : à prévoir.

## 9. Plan d'action priorisé
- 🔴 **Conduire l'AIPD** et la faire valider par le DPO **avant prod**.
- 🔴 **Antivirus** sur les fichiers déposés (scan avant validation).
- 🔴 Confirmer **MFA obligatoire côté client** + chiffrement au repos documenté.
- 🟠 Clauses **art. 28** Microsoft + mise à jour du **registre des traitements**.
- 🟠 **Mentions d'information** / politique de confidentialité du portail.
- 🟡 Réconcilier les durées de conservation (pièces vs données perso).

## 10. Questions au DPO / métier
- Les bulletins de paie traités relèvent-ils de l'art. 9 (données sensibles) dans votre analyse ?
- Transferts éventuels hors UE via Microsoft Graph (emails) : acceptés / encadrés ?
- Politique de revue périodique des accès (départs/arrivées) : qui, à quelle fréquence ?

## 11. Esquisse — fiche « registre des traitements »
- **Traitement** : collecte et gestion des pièces comptables clients (PEPITE).
- **Finalité** : fiabiliser/accélérer la collecte, traçabilité.
- **Base légale** : exécution du contrat de mission (+ obligation légale pour l'archivage).
- **Catégories de données / personnes** : cf. §2. **Destinataires** : collaborateurs habilités.
- **Hébergement** : Azure UE (self-hosted). **Durées** : cf. §6. **Mesures** : cf. §5.
- *(à compléter et valider par le DPO)*

---

### ⭐ 3 actions bloquantes avant mise en production
1. **AIPD réalisée et validée** par le DPO.
2. **Antivirus** des pièces déposées en place.
3. **MFA client + chiffrement au repos** confirmés et documentés.
