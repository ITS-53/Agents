---
description: Audite un projet sous l'angle RGPD/AIPD et produit une note prête pour le DPO
argument-hint: <chemin compréhension.md> [chemin docs/ d'architecture]
---

Réalise l'audit RGPD du projet à partir de : $ARGUMENTS

1. Le 1er argument est le dossier de compréhension (sortie de `cdc-analyst`). Lis-le.
2. Le 2e argument (recommandé) est le dossier `docs/` d'architecture. S'il est fourni, lis-le
   (auth, chiffrement, RLS, conservation, hébergement).
3. Délègue à l'agent **rgpd-dpo** → écrit la note dans `rgpd/note-dpo.md` (ou `cadrage/note-dpo.md`).
4. Présente-moi : le niveau de risque, le verdict AIPD, et les **3 actions bloquantes** avant prod.
