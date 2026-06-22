---
description: Convertit un cahier des charges (.docx ou .md) puis lance l'agent cdc-analyst pour le comprendre en profondeur
argument-hint: <chemin vers le CDC .docx ou .md>
---

Le cahier des charges à analyser se trouve ici : $ARGUMENTS

Procédure :

1. Si le chemin pointe vers un `.docx`, convertis-le d'abord en Markdown :
   `pwsh ./scripts/Convert-Docx.ps1 -Path "$ARGUMENTS" -OutFile "./analyses/cdc-extrait.md"`
   S'il s'agit déjà d'un `.md` ou `.txt`, utilise-le directement.

2. Délègue ensuite l'analyse à l'agent **cdc-analyst** (via le sous-agent), en lui
   transmettant le chemin du fichier texte. Demande-lui le « Dossier de compréhension
   projet » complet selon son format.

3. Écris le résultat dans `./analyses/<code-projet-ou-nom>-comprehension.md` et présente-moi
   la synthèse exécutive + les 3 questions de cadrage les plus critiques.

**Étape suivante (chaînage)** : propose-moi d'enchaîner sur la suite de la chaîne — générer le
backlog (`cdc-backlog`) puis l'architecture (`/proposer-archi`, grill-me). Pour tout enchaîner
d'un coup, suggère plutôt la commande **`/cadrer-projet`** qui orchestre l'ensemble.
