---
description: Rédige une AIPD (DPIA) complète selon la méthodologie CNIL, à partir de la note RGPD
argument-hint: [chemin note-dpo.md] [chemin compréhension.md] [chemin docs/]
---

Rédige l'AIPD du projet à partir de : $ARGUMENTS

1. Si une note `rgpd/note-dpo.md` (sortie de `rgpd-dpo`) existe, utilise-la en priorité ;
   sinon, appuie-toi sur `cadrage/comprehension.md` et `docs/` (et propose de lancer `/audit-rgpd` d'abord).
2. Délègue à l'agent **aipd** → écrit `rgpd/AIPD.md` (structure CNIL : description, nécessité/
   proportionnalité, mesures, appréciation des risques, validation).
3. Présente-moi : le **niveau de risque résiduel global**, les mesures complémentaires bloquantes
   avant prod, et les **lacunes à faire compléter par le DPO**.
