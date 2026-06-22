CAHIER DES CHARGES — Portail de collecte de pièces clients

Nom du projet : Portail Pièces (nom de code « PEPITE »)
Code projet : SI-2026-014
Version du document : v0.9 — En revue
Rédigé par : C. Hayer, Chef de projet SI
Date : 12/06/2026
Statut : En revue

1. Contexte et enjeux

1.1 Contexte général
Origine de la demande : Demande métier portée par la Direction de la production comptable, inscrite au plan SI 2026.
Situation actuelle : La collecte des pièces clients (factures, relevés bancaires, justificatifs) se fait aujourd'hui par e-mail et par une multitude de dossiers partagés. 30 % des dossiers prennent du retard faute de pièces complètes à temps.
Problème à résoudre : Fiabiliser et accélérer la collecte des pièces comptables auprès des clients, avec une traçabilité de bout en bout.

1.2 Objectifs et alignement stratégique
- Réduire le délai moyen de collecte des pièces | Productivité | Gain de temps production | -40 % de délai de collecte
- Diminuer les relances manuelles | Qualité de service | Moins de tâches à faible valeur | KPI : [ À compléter ]
- Améliorer la satisfaction client | Attractivité | Image de cabinet moderne | NPS > 40

1.3 Périmètre
Dans le périmètre : dépôt de pièces par les clients via portail web ; relances automatiques ; classement par mission/exercice ; notification aux collaborateurs ; export vers le logiciel de production comptable.
Hors périmètre : la saisie comptable elle-même ; la facturation des honoraires ; l'application mobile native (une web app responsive suffit en v1).

1.4 Parties prenantes et gouvernance
- Sponsor / chef de projet : Direction de la production comptable / C. Hayer
- DPO : associé au cadrage
- Référent sécurité SI : à désigner

2. Utilisateurs et besoins métier

2.1 Profils utilisateurs
- Collaborateur production comptable | ≈ 120 | Quotidien, bureau et clientèle | Rapidité, fiabilité
- Client du cabinet | ≈ 3 500 | Ponctuel, dépôt de pièces | Simplicité, confiance
- Manager de portefeuille | ≈ 25 | Hebdomadaire, suivi | Vision d'avancement

2.2 Processus métier cible
Étape 1 — Le collaborateur crée une demande de pièces pour un dossier client (déclencheur : ouverture d'exercice).
Étape 2 — Le client reçoit une notification et dépose ses pièces sur le portail.
Étape 3 — Relances automatiques tant que des pièces manquent.
Étape 4 — Le collaborateur valide la complétude et exporte vers la production comptable.
Cas particuliers : forte saisonnalité aux clôtures (déc-janv et mai) ; pics x5 du volume de dépôts.

3. Exigences fonctionnelles
- EF-01 (Must) : dépôt de fichiers par le client (PDF, images, < 25 Mo).
- EF-02 (Must) : checklist de pièces attendues paramétrable par type de mission.
- EF-03 (Must) : relances automatiques programmables.
- EF-04 (Should) : prévisualisation des pièces déposées.
- EF-05 (Should) : tableau de bord d'avancement par portefeuille.
- EF-06 (Could) : OCR de reconnaissance automatique du type de pièce.
- EF-07 (Won't v1) : signature électronique des documents.

4. Exigences non fonctionnelles

4.1 Performance, disponibilité et volumétrie
Temps de réponse cible : [ À compléter ]
Disponibilité attendue : 99,5 % en heures ouvrées
Volumétrie : 3 500 clients, ~120 collaborateurs, pics x5 en période de clôture, ~500 000 pièces/an
Sauvegarde / PRA : sauvegarde quotidienne ; RPO/RTO [ À compléter ]

4.2 Sécurité et conformité RGPD
Nature des données traitées : données financières clients, données personnelles (identité, contacts), pièces sociales (bulletins de paie pour certaines missions).
Base légale du traitement : exécution du contrat de mission.
Hébergement des données : cloud, hébergeur certifié, localisation UE.
Durée de conservation : [ À compléter ]
Chiffrement : TLS en transit ; au repos [ À compléter ]
Authentification : SSO pour les collaborateurs ; pour les clients, e-mail + mot de passe.
Traçabilité / journalisation : logs d'accès et d'actions, conservation 12 mois.
Anonymisation : jeux de test anonymisés.

4.3 Gestion des droits et habilitations
- Administrateur | Tous dossiers | L/C/M/S/Admin : Oui
- Manager | Son portefeuille | L oui, C/M oui, S non, Admin non
- Collaborateur | Ses dossiers assignés | L oui, C/M oui, S non, Admin non
- Client | Ses propres dépôts | L oui (ses pièces), C oui, M non, S non

5. Charte graphique, design et expérience utilisateur
5.1 Identité visuelle : réutiliser le design system interne du groupe (lien intranet).
5.2 Ergonomie & accessibilité : viser RGAA/WCAG AA ; responsive web (poste fixe + mobilité clientèle) ; français, formats FR.
5.3 Maquettes : maquettes haute-fidélité Figma ; validation par la Direction production.

6. Architecture, intégrations et réversibilité
6.1 Intégration au SI
- Logiciel de production comptable | Sortant | Pièces + métadonnées | API REST | Temps réel
- Annuaire (SSO) | Entrant | Identités collaborateurs | SAML | Temps réel
- Messagerie | Sortant | Notifications/relances | SMTP/API | Temps réel
6.2 Réversibilité et propriété des données : le groupe est propriétaire du code et des données ; export CSV/JSON ; documentation technique à fournir ; plan de réversibilité [ À compléter ].
6.3 Contraintes techniques et hébergement
Stack technique imposée : back-end .NET, base PostgreSQL, conteneurisation Docker, déploiement sur le cloud privé du groupe.
Compatibilité navigateurs : Edge et Chrome (parc interne).
Environnements : dév, recette, production.

7. Conformité métier et réglementaire
Archivage légal : pièces à valeur probante, conservation 10 ans.
Piste d'audit fiable : traçabilité des dépôts et validations.
Normes profession : obligations déontologiques OEC, secret professionnel.
Facturation électronique : sans objet (hors périmètre).

8. Organisation, budget et pilotage
8.1 Méthodologie et planning : Agile (sprints de 2 semaines). Date de démarrage souhaitée : 01/09/2026. Échéance / contrainte de date : mise en production avant la clôture de décembre, soit 01/12/2026 (raison : absorber le pic de clôture).
8.2 Jalons
- Cadrage validé | CDC signé | 15/07/2026
- Maquettes validées | Figma | 15/09/2026
- Recette | PV de recette | 20/11/2026
- Mise en production | Go-live | 01/12/2026
8.3 Budget et coût complet (TCO)
- Développement | Prestataire | 180 000 € | Ponctuel
- Hébergement | Cloud privé groupe | [ À compléter ] | Récurrent
- Maintenance | Prestataire | 15 % / an | Récurrent
8.4 Recette et critères d'acceptation
- CA-01 | Toutes les exigences « Must » opérationnelles | Tests de recette métier
- CA-02 | Tenue de charge au pic de clôture (x5) | Tests de performance
8.5 Risques et hypothèses
- Faible adoption par les clients | Élevé | Moyenne | Accompagnement + UX simple
- Indisponibilité des experts métier | Élevé | Moyenne | Ateliers planifiés à l'avance

9. Grille de complétude : partiellement renseignée.

Validation : Rédacteur C. Hayer (12/06/2026). Sponsor : en attente. DSI : en attente.
