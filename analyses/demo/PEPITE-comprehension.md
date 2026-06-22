# Dossier de compréhension projet — PEPITE (Portail de collecte de pièces clients)

> Produit par l'agent `cdc-analyst` à partir de `cdc-portail-clients-REMPLI.md` (v0.9 — En revue).

## 1. Synthèse exécutive
PEPITE (code SI-2026-014) est un **portail web de collecte des pièces comptables clients**
(factures, relevés, justificatifs) destiné à remplacer une collecte actuellement éclatée entre
e-mails et dossiers partagés, à l'origine de 30 % de dossiers en retard (§1.1). Il vise
~120 collaborateurs, ~3 500 clients et ~25 managers (§2.1), avec relances automatiques,
checklist paramétrable et export vers la production comptable (§1.3). Le projet est piloté en
Agile pour un go-live avant la clôture de décembre (§8.1).
**Niveau de confiance global : Moyen.** Le besoin métier, le périmètre et les exigences
fonctionnelles sont clairs et bien priorisés ; en revanche, des points **bloquants côté RGPD**
(durée de conservation, chiffrement au repos, authentification client), des **NFR de performance
non chiffrées** rendant un critère de recette invérifiable, et un **planning très tendu** non
porté au registre des risques fragilisent la validation en l'état.

## 2. Fiche d'identité
| Champ | Valeur |
|---|---|
| Nom / code | Portail Pièces « PEPITE » / SI-2026-014 |
| Version / statut | v0.9 — En revue |
| Rédacteur | C. Hayer, Chef de projet SI (12/06/2026) |
| Sponsor | Direction de la production comptable (visa en attente) |
| Échéances clés | Démarrage 01/09/2026 → Go-live 01/12/2026 |

## 3. Contexte & objectifs
Problème central : **fiabiliser et accélérer la collecte des pièces avec une traçabilité de bout en bout** (§1.1).

| Objectif (§1.2) | Type | KPI / cible |
|---|---|---|
| Réduire le délai de collecte | Productivité | **-40 %** de délai |
| Diminuer les relances manuelles | Qualité de service | ⚠️ KPI **non défini** `[À compléter]` |
| Améliorer la satisfaction client | Attractivité | NPS > 40 |

## 4. Périmètre
| Dans le périmètre (§1.3) | Hors périmètre (§1.3) |
|---|---|
| Dépôt de pièces par les clients (web) | Saisie comptable |
| Relances automatiques | Facturation des honoraires |
| Classement par mission/exercice | Application mobile native (web responsive en v1) |
| Notification collaborateurs | Signature électronique (EF-07, Won't v1) |
| Export vers production comptable | OCR (EF-06 en Could, non garanti) |

*Zone grise :* l'archivage à valeur probante 10 ans (§7) est-il rendu par PEPITE ou délégué à une GED existante ? Non tranché.

## 5. Utilisateurs & processus
- **Personas (§2.1) :** Collaborateur (~120, quotidien, mobilité) ; Client (~3 500, ponctuel) ; Manager de portefeuille (~25, suivi).
- **Processus cible (§2.2) :** création d'une demande de pièces → notification client → dépôt → relances auto → validation de complétude → export.
- **Saisonnalité forte (§2.2) :** pics **x5** aux clôtures (déc-janv et mai) — contrainte dimensionnante majeure.

## 6. Exigences fonctionnelles (MoSCoW déjà fournie — §3)
| Réf | Exigence | Priorité |
|---|---|---|
| EF-01 | Dépôt de fichiers client (PDF/images, < 25 Mo) | Must |
| EF-02 | Checklist de pièces paramétrable par mission | Must |
| EF-03 | Relances automatiques programmables | Must |
| EF-04 | Prévisualisation des pièces | Should |
| EF-05 | Tableau de bord d'avancement par portefeuille | Should |
| EF-06 | OCR du type de pièce | Could |
| EF-07 | Signature électronique | Won't (v1) |

## 7. Exigences non fonctionnelles
- **Performance / dispo / volumétrie (§4.1) :** disponibilité 99,5 % HO ; 3 500 clients, ~500 000 pièces/an, **pics x5**. ⚠️ **Temps de réponse cible `[À compléter]`** ; ⚠️ **RPO/RTO `[À compléter]`** (seule la sauvegarde quotidienne est posée).
- **Sécurité & RGPD (§4.2) :** données **financières + personnelles + sociales (paie)** = sensibilité élevée ; base légale = exécution du contrat ; hébergement UE certifié ; logs 12 mois ; jeux de test anonymisés. ⚠️ **Durée de conservation `[À compléter]`** ; ⚠️ **Chiffrement au repos `[À compléter]`** ; ⚠️ **authentification client = e-mail + mot de passe simple, sans MFA** (voir incohérence ci-dessous).
- **Droits & habilitations (§4.3) :** matrice claire à 4 profils (Admin / Manager / Collaborateur / Client), cloisonnement par portefeuille et par dépôts — conforme au moindre privilège.

## 8. Contraintes techniques (dont implicites — *inféré*)
- **Stack imposée (§6.3) :** back-end **.NET**, base **PostgreSQL**, **Docker**, déploiement **cloud privé groupe**. Navigateurs : Edge + Chrome. Environnements dév/recette/prod.
- **Intégrations SI (§6.1) :**

| Système | Sens | Données | Mode | Fréquence |
|---|---|---|---|---|
| Production comptable | Sortant | Pièces + métadonnées | API REST | Temps réel |
| Annuaire (SSO) | Entrant | Identités collaborateurs | SAML | Temps réel |
| Messagerie | Sortant | Notifications/relances | SMTP/API | Temps réel |

- **Réversibilité (§6.2) :** propriété groupe OK, export CSV/JSON OK, doc technique à fournir ; ⚠️ **plan de réversibilité `[À compléter]`**.
- **Implications techniques inférées (non écrites dans le CDC) :**
  - *inféré* — 500 000 pièces/an + archivage **10 ans à valeur probante** ⇒ volumétrie de stockage cumulée importante (plusieurs To probables) au coût récurrent non chiffré.
  - *inféré* — les pics **x5** exigent une architecture élastique (mise à l'échelle horizontale) ; la conteneurisation Docker imposée le permet, mais aucune cible de charge n'est fixée pour la dimensionner.
  - *inféré* — un portail ouvert à 3 500 clients externes manipulant des données paie ⇒ surface d'exposition élevée ⇒ MFA et chiffrement au repos devraient être des Must, pas des champs vides.

## 9. Conformité métier & réglementaire (§7)
Archivage légal 10 ans à valeur probante ; piste d'audit des dépôts/validations ; déontologie OEC et secret professionnel ; facturation électronique sans objet (hors périmètre).
*Point d'attention :* l'archivage **à valeur probante** est une exigence forte (intégrité, horodatage, non-répudiation) dont les modalités techniques ne sont pas spécifiées.

## 10. Organisation & budget
- **Méthodo / planning (§8.1) :** Agile, sprints 2 semaines. Démarrage 01/09 → go-live 01/12/2026.
- **Jalons (§8.2) :** CDC signé 15/07 · Maquettes 15/09 · Recette 20/11 · Go-live 01/12.
- **TCO (§8.3) :** Dév prestataire 180 000 € ; maintenance 15 %/an ; ⚠️ **hébergement récurrent `[À compléter]`** ⇒ TCO incomplet.
- **Recette (§8.4) :** CA-01 (tous les Must opérationnels) ; CA-02 (tenue de charge au pic x5) — *ce dernier n'est pas vérifiable sans cible de temps de réponse (cf. §4.1)*.

## 11. Risques & hypothèses
| Risque / hypothèse | Impact | Probab. | Mitigation | Source |
|---|---|---|---|---|
| Faible adoption par les clients | Élevé | Moyenne | Accompagnement + UX simple | §8.5 |
| Indisponibilité des experts métier | Élevé | Moyenne | Ateliers planifiés | §8.5 |
| **Planning très tendu** (dév réel ~15/09→20/11) | Élevé | **Élevée** | *À ajouter : réduire le scope v1, geler les Must* | *détecté* |
| **Conformité RGPD non finalisée** (conservation, chiffrement, MFA, AIPD) | Élevé | Élevée | *À ajouter : statuer avec le DPO avant dév* | *détecté* |
| **Coût d'hébergement/stockage non chiffré** (volumétrie + 10 ans) | Moyen | Élevée | *À ajouter : chiffrer le TCO cloud* | *détecté* |

## 12. Carte des lacunes
| Section | Lacune | Criticité |
|---|---|---|
| §4.2 | Durée de conservation des données **non définie** (données financières/paie) | 🔴 Bloquant |
| §4.2 | Chiffrement **au repos** non spécifié (données sensibles) | 🔴 Bloquant |
| §4.2 | Authentification client sans **MFA** sur données sensibles | 🔴 Bloquant |
| §4.1 | **Temps de réponse cible** absent ⇒ rend CA-02 invérifiable | 🟠 Important |
| §4.1 | **RPO/RTO** non définis (PRA incomplet) | 🟠 Important |
| §8.3 | **Coût d'hébergement récurrent** absent ⇒ TCO incomplet | 🟠 Important |
| §6.2 | **Plan de réversibilité** non rédigé | 🟠 Important |
| §1.2 | KPI « relances manuelles » sans cible | 🟡 Mineur |
| §1.4 | Référent sécurité SI « à désigner » | 🟡 Mineur |
| §9 | Grille de complétude seulement « partiellement renseignée » | 🟡 Mineur |

## 13. Incohérences & questions de cadrage à poser
**Incohérences détectées :**
1. **Sécurité vs sensibilité :** données de paie/financières (§4.2) mais authentification client par simple mot de passe et chiffrement au repos non posé ⇒ contradiction avec le niveau de sensibilité déclaré.
2. **Recette invérifiable :** CA-02 teste la tenue de charge au pic x5 (§8.4) alors qu'aucun temps de réponse cible n'est fixé (§4.1).
3. **Conservation vs archivage :** archivage 10 ans à valeur probante (§7) mais durée de conservation des données vide (§4.2) — à réconcilier.
4. **Planning :** maquettes validées seulement le 15/09, recette le 20/11 ⇒ ~9 semaines de développement effectif pour un projet à 180 k€ avec 3 intégrations, non reflété dans les risques.

**Questions de cadrage (priorisées) :**
- Une **AIPD** (analyse d'impact RGPD) est-elle requise vu les données de paie et les 3 500 clients ? Le DPO a-t-il statué ?
- Quelle **durée de conservation** par type de pièce, et quelle articulation avec l'archivage probant 10 ans ?
- Exige-t-on le **MFA** et le **chiffrement au repos** comme exigences Must dès la v1 ?
- Quelle **cible de temps de réponse** sous charge de pic (ex. < 2 s pour 95 % des actions à x5) ?
- Le périmètre v1 est-il **tenable d'ici décembre** ou faut-il geler/réduire le scope ?
- Qui chiffre le **coût d'hébergement/stockage** (TCO complet) ?

## 14. Grille de complétude (§9)
| Point de contrôle | Statut | Justification |
|---|---|---|
| Problème & objectifs mesurables | ⚠️ | Objectifs OK mais 1 KPI sans cible (§1.2) |
| Périmètre inclus/exclu explicite | ✅ | Clair (§1.3) |
| Parties prenantes & gouvernance | ⚠️ | Référent sécurité non désigné (§1.4) |
| Exigences fonctionnelles priorisées (MoSCoW) | ✅ | Fait (§3) |
| Performance & disponibilité chiffrées | ❌ | Temps de réponse & RPO/RTO absents (§4.1) |
| Sécurité / RGPD traitée (DPO) | ❌ | Conservation, chiffrement au repos, MFA, AIPD non tranchés (§4.2) |
| Matrice des droits définie | ✅ | Complète (§4.3) |
| Charte graphique & accessibilité | ✅ | Design system + RGAA AA (§5) |
| Intégrations SI listées | ✅ | 3 flux décrits (§6.1) |
| Réversibilité & propriété des données | ⚠️ | Propriété OK, plan de réversibilité absent (§6.2) |
| Conformité métier (archivage, piste d'audit) | ⚠️ | Posée mais modalités probantes non spécifiées (§7) |
| Budget complet (TCO) & coûts récurrents | ❌ | Hébergement non chiffré (§8.3) |
| Critères d'acceptation / recette | ⚠️ | CA-02 invérifiable sans cible de perf (§8.4) |
| Risques principaux identifiés & traités | ⚠️ | 2 risques listés ; planning/RGPD/coût manquants (§8.5) |

---

### ⭐ Les 3 questions les plus critiques à trancher en priorité
1. **RGPD :** AIPD requise ? + durée de conservation + MFA + chiffrement au repos — à statuer avec le DPO **avant** tout développement (bloquant légal).
2. **Performance :** quelle cible de temps de réponse sous pic x5 ? (sans elle, la recette CA-02 ne veut rien dire).
3. **Planning :** le scope v1 est-il livrable d'ici le 01/12/2026, ou faut-il le réduire dès maintenant ?
