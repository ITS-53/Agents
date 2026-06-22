
CAHIER DES CHARGES
Modèle standard — Projet de développement logiciel sur mesure
Socle méthodologique commun — Direction des Systèmes d'Information
Nom du projet
[ À compléter ]
Code projet
[ À compléter ]
Version du document
v0.1 — Brouillon
Rédigé par
[ Nom / fonction ]
Date
[ JJ/MM/AAAA ]
Statut
[ Brouillon / En revue / Validé ]

Comment utiliser ce modèle
Ce document est le socle commun de cadrage de tous nos projets de développement logiciel sur mesure. Il garantit que chaque projet démarre sur la même méthodologie, avec le même niveau d'exigence et sans angle mort.
Remplacez chaque mention « [ À compléter ] » par le contenu propre à votre projet ; supprimez les lignes d'exemple en italique une fois comprises.
Les encadrés orange « Questions de cadrage » servent à animer les ateliers de lancement avec le métier ; ils ne sont pas destinés à rester dans la version finale.
Toutes les sections ne s'appliquent pas à tous les projets : indiquez « Sans objet » plutôt que de laisser vide, pour montrer que le point a été traité.
La grille de complétude en fin de document permet de vérifier que le cahier des charges est prêt à être validé.

	TOC \h \o "1-2"Comment utiliser ce modèle	 PAGEREF _Toc232493999 \h 1
	1. Contexte et enjeux	 PAGEREF _Toc232494000 \h 1
	1.1 Contexte général	 PAGEREF _Toc232494001 \h 1
	1.2 Objectifs et alignement stratégique	 PAGEREF _Toc232494002 \h 1
	1.3 Périmètre	 PAGEREF _Toc232494003 \h 1
	1.4 Parties prenantes et gouvernance	 PAGEREF _Toc232494004 \h 1
	2. Utilisateurs et besoins métier	 PAGEREF _Toc232494005 \h 1
	2.1 Profils utilisateurs	 PAGEREF _Toc232494006 \h 1
	2.2 Processus métier cible	 PAGEREF _Toc232494007 \h 1
	3. Exigences fonctionnelles	 PAGEREF _Toc232494008 \h 1
	3.1 Liste des exigences	 PAGEREF _Toc232494009 \h 1
	3.2 Règles de gestion détaillées	 PAGEREF _Toc232494010 \h 1
	4. Exigences non fonctionnelles	 PAGEREF _Toc232494011 \h 1
	4.1 Performance, disponibilité et volumétrie	 PAGEREF _Toc232494012 \h 1
	4.2 Sécurité et conformité RGPD	 PAGEREF _Toc232494013 \h 1
	4.3 Gestion des droits et habilitations	 PAGEREF _Toc232494014 \h 1
	5. Charte graphique, design et expérience utilisateur	 PAGEREF _Toc232494015 \h 1
	5.1 Identité visuelle	 PAGEREF _Toc232494016 \h 1
	5.2 Principes d'ergonomie et d'accessibilité	 PAGEREF _Toc232494017 \h 1
	5.3 Maquettes et livrables design	 PAGEREF _Toc232494018 \h 1
	6. Architecture, intégrations et réversibilité	 PAGEREF _Toc232494019 \h 1
	6.1 Intégration au système d'information	 PAGEREF _Toc232494020 \h 1
	6.2 Réversibilité et propriété des données	 PAGEREF _Toc232494021 \h 1
	6.3 Contraintes techniques et hébergement	 PAGEREF _Toc232494022 \h 1
	7. Conformité métier et réglementaire	 PAGEREF _Toc232494023 \h 1
	8. Organisation, budget et pilotage	 PAGEREF _Toc232494024 \h 1
	8.1 Méthodologie et planning	 PAGEREF _Toc232494025 \h 1
	8.2 Jalons	 PAGEREF _Toc232494026 \h 1
	8.3 Budget et coût complet (TCO)	 PAGEREF _Toc232494027 \h 1
	8.4 Recette et critères d'acceptation	 PAGEREF _Toc232494028 \h 1
	8.5 Risques et hypothèses	 PAGEREF _Toc232494029 \h 1
	9. Grille de complétude (avant validation)	 PAGEREF _Toc232494030 \h 1
	Validation	 PAGEREF _Toc232494031 \h 1

1. Contexte et enjeux
1.1 Contexte général
Décrivez la situation actuelle, l'origine de la demande et l'environnement métier dans lequel s'inscrit le projet.
Origine de la demande
[ Qui est à l'origine, dans quel cadre (plan SI, demande métier, contrainte réglementaire…) ]
Situation actuelle
[ Comment le besoin est-il couvert aujourd'hui (outil existant, Excel, manuel, rien) ]
Problème à résoudre
[ Le problème central, formulé en une à deux phrases ]

1.2 Objectifs et alignement stratégique
Reliez le projet à la vision SI du groupe et aux bénéfices attendus.
Objectif
Type
Bénéfice attendu
Indicateur de succès (KPI)
Réduire le temps de saisie des dossiers
Productivité
Gain de temps collaborateurs
-30 % de temps par dossier

Questions de cadrage — Pourquoi ce projet ?
• Quel problème concret résout-on, et pour qui ? Que se passe-t-il si on ne fait rien ?
• En quoi ce projet sert-il la stratégie du groupe (croissance, conformité, qualité de service, attractivité) ?
• Quel est le bénéfice mesurable attendu, et à quelle échéance ?
• Existe-t-il une solution du marché qui ferait l'affaire ? Pourquoi développer sur mesure ?

1.3 Périmètre
Délimitez clairement ce qui est inclus et, tout aussi important, ce qui est exclu.
Dans le périmètre (in scope)
Hors périmètre (out of scope)
[ Fonction / module inclus ]
[ … ]
[ Ce qui est explicitement exclu ]
[ … ]

1.4 Parties prenantes et gouvernance
Rôle
Nom / entité
Responsabilité
Sponsor / chef de projet
[ Direction ]
Arbitrages, budget, validation des jalons

2. Utilisateurs et besoins métier
2.1 Profils utilisateurs
Profil / persona
Volume
Contexte d'usage
Attentes principales
Collaborateur production comptable
≈ 120
Quotidien, au bureau et en clientèle
Rapidité, fiabilité, mobilité

2.2 Processus métier cible
Décrivez le déroulé du processus une fois l'outil en place (étapes, acteurs, déclencheurs).
[ Étape 1 — déclencheur, acteur, action ]
[ Étape 2 — … ]
[ Étape 3 — … ]

Questions de cadrage — Pour qui et comment ?
• Qui utilisera l'outil au quotidien, et avec quel niveau d'aisance numérique ?
• Comment le travail se fait-il aujourd'hui, étape par étape ? Où sont les irritants et les pertes de temps ?
• Quels cas particuliers ou exceptions doivent absolument être gérés ?
• Y a-t-il une saisonnalité (clôtures, échéances fiscales) à prendre en compte ?
3. Exigences fonctionnelles
Détaillez votre projet, vos besoins, vos attentes.

4. Exigences non fonctionnelles
4.1 Performance, disponibilité et volumétrie
Temps de réponse cible
[ ex. < 2 s pour 95 % des actions ]
Disponibilité attendue
[ ex. 99,5 % en heures ouvrées ]
Volumétrie
[ nb d'utilisateurs simultanés, nb de dossiers, croissance annuelle ]
Sauvegarde / PRA
[ fréquence des sauvegardes, RPO/RTO attendus ]

4.2 Sécurité et conformité RGPD
Section sensible pour un cabinet d'expertise comptable : données financières, secret professionnel et données personnelles des clients et salariés.
Nature des données traitées
[ Données personnelles ? financières ? sociales (paie) ? sensibles ? ]
Base légale du traitement
[ Contrat, obligation légale, intérêt légitime, consentement ]
Hébergement des données
[ Localisation (UE), cloud / on-premise, hébergeur, certifications ]
Durée de conservation
[ Politique de rétention et purge par type de donnée ]
Chiffrement
[ Au repos et en transit (TLS), gestion des clés ]
Authentification
[ SSO, MFA, politique de mots de passe ]
Traçabilité / journalisation
[ Logs d'accès et d'actions, durée de conservation des logs ]
Anonymisation / pseudonymisation
[ Environnements de test, jeux de données ]

Questions de cadrage — Sécurité & RGPD
• Quelles données personnelles ou confidentielles l'outil va-t-il manipuler, et faut-il une analyse d'impact (AIPD) ?
• Où les données seront-elles hébergées et qui peut techniquement y accéder ?
• Comment garantit-on le secret professionnel comptable et l'étanchéité entre dossiers clients ?
• Le DPO du groupe a-t-il été associé au cadrage ? Quelles obligations contractuelles côté sous-traitants ?

4.3 Gestion des droits et habilitations
Définissez les profils d'accès et la matrice des droits. Principe du moindre privilège : chacun n'accède qu'à ce dont il a besoin.
Profil / rôle
Périmètre de données
Lecture
Création / modif.
Suppression
Administration
Administrateur
Tous dossiers
Oui
Oui
Oui
Oui

Questions de cadrage — Droits & habilitations
• Quels sont les grands profils d'accès, et qui décide de l'attribution des droits ?
• Faut-il cloisonner par bureau, par portefeuille client, par mission ?
• Comment gère-t-on les départs, arrivées et changements de poste (revue périodique des accès) ?
• Certaines actions sensibles nécessitent-elles une double validation ?
5. Charte graphique, design et expérience utilisateur
Garantit la cohérence visuelle avec l'identité du groupe et une expérience homogène d'un outil à l'autre.
5.1 Identité visuelle
Charte graphique de référence
[ Lien vers la charte du groupe / design system existant ]
Logo et déclinaisons
[ Emplacements, versions claires/foncées ]
Palette de couleurs
[ Couleurs primaires / secondaires, codes hexadécimaux ]
Typographies
[ Police(s), tailles, hiérarchie ]
Iconographie
[ Bibliothèque d'icônes, style ]

5.2 Principes d'ergonomie et d'accessibilité
Cohérence : mêmes composants, mêmes comportements que nos autres applications internes.
Accessibilité : viser le RGAA / WCAG AA (contrastes, navigation clavier, lecteurs d'écran).
Responsive : préciser les usages mobile / tablette / poste fixe attendus.
Langue et formats : français, formats de date et montants conformes aux usages français.

5.3 Maquettes et livrables design
Niveau attendu
[ Wireframes / maquettes haute-fidélité / prototype cliquable ]
Outil
[ Figma, Adobe XD… et lien ]
Validation design
[ Qui valide les écrans avant développement ]

Questions de cadrage — Design & UX
• Disposons-nous d'un design system / d'une charte à réutiliser, ou faut-il les créer ?
• Sur quels supports l'outil sera-t-il utilisé (poste fixe, mobilité en clientèle) ?
• Quel niveau d'accessibilité visons-nous, et est-ce une obligation pour nous ?
• Qui, côté métier, valide les maquettes avant le lancement des développements ?
6. Architecture, intégrations et réversibilité
6.1 Intégration au système d'information
Listez les applications avec lesquelles l'outil doit échanger (production comptable, paie, GED, CRM, SSO, messagerie…).
Système / application
Sens du flux
Données échangées
Mode (API, fichier, manuel)
Fréquence
Logiciel de production comptable
Bidirectionnel
Écritures, plan comptable
API REST
Temps réel

6.2 Réversibilité et propriété des données
Point stratégique : ne jamais se retrouver prisonnier d'une solution. À traiter même pour un développement interne.
Propriété du code et des données
[ Le groupe est propriétaire — préciser dépôt, licences ]
Format d'export des données
[ Formats standards et ouverts (CSV, JSON, SQL) ]
API d'accès aux données
[ Disponibilité, documentation ]
Documentation technique
[ Architecture, schéma de données, procédures de reprise ]
Plan de réversibilité
[ Comment migrer / récupérer en cas d'abandon ou de changement ]

6.3 Contraintes techniques et hébergement
Stack technique imposée
[ Langages, frameworks, base de données standards du groupe ]
Hébergement
[ Cloud privé / public, on-premise, datacenter ]
Compatibilité postes / navigateurs
[ Parc existant à supporter ]
Environnements
[ Dév, recette, production ]

Questions de cadrage — Intégrations & réversibilité
• Avec quelles briques du SI l'outil doit-il dialoguer, et ces briques exposent-elles des API ?
• Le groupe reste-t-il pleinement propriétaire du code et des données ?
• Si nous devions abandonner ou remplacer l'outil dans 5 ans, comment récupérerions-nous les données ?
• Quelles contraintes techniques de notre socle SI le projet doit-il respecter ?

7. Conformité métier et réglementaire
Exigences propres à la profession d'expertise comptable.
Archivage légal
[ Durée et modalités d'archivage à valeur probante ]
Piste d'audit fiable
[ Traçabilité des écritures et des modifications ]
Normes profession
[ Référentiels OEC, obligations déontologiques ]
Facturation électronique
[ Conformité aux obligations en vigueur ]
Réversibilité réglementaire
[ Conservation des données après fin de mission ]
8. Organisation, budget et pilotage
8.1 Méthodologie et planning
Méthodologie
[ Agile / itératif, cycle en V, hybride ]
Date de démarrage souhaitée
[ JJ/MM/AAAA ]
Échéance / contrainte de date
[ Date butoir et sa raison ]

8.2 Jalons
Jalon
Livrable attendu
Date cible
Cadrage validé
CDC signé
[ … ]

8.3 Budget et coût complet (TCO)
Poste de coût
Nature
Estimation
Récurrence
Développement
Interne / prestataire
[ € ]
Ponctuel

Ne pas oublier les coûts récurrents : maintenance, hébergement, support, montées de version, formation.

8.4 Recette et critères d'acceptation
Conditions objectives qui permettront de déclarer le projet « livré et conforme ».
Réf.
Critère d'acceptation
Méthode de vérification
CA-01
Toutes les exigences « Must » sont opérationnelles
Tests de recette métier

8.5 Risques et hypothèses
Risque / hypothèse
Impact
Probabilité
Mesure de mitigation
Indisponibilité des experts métier
Élevé
Moyenne
Planifier les ateliers à l'avance

9. Grille de complétude (avant validation)
À cocher avant de soumettre le cahier des charges à validation.
Fait
Point de contrôle
☐
Le problème à résoudre et les objectifs mesurables sont formulés clairement
☐
Le périmètre (inclus / exclu) est explicite
☐
Les parties prenantes et la gouvernance sont identifiées
☐
Les exigences fonctionnelles sont priorisées (MoSCoW)
☐
Les exigences de performance et de disponibilité sont chiffrées
☐
La conformité Sécurité / RGPD est traitée (et le DPO associé si besoin)
☐
La matrice des droits et habilitations est définie
☐
La charte graphique et les exigences d'accessibilité sont précisées
☐
Les intégrations au SI sont listées
☐
La réversibilité et la propriété des données sont garanties
☐
La conformité métier (archivage, piste d'audit) est couverte
☐
Le budget complet (TCO) et les coûts récurrents sont estimés
☐
Les critères d'acceptation / recette sont définis
☐
Les risques principaux sont identifiés et traités

Validation
Rôle
Nom
Date
Visa
Rédacteur

Sponsor métier

DSI
