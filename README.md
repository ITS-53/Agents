# Agents — chaîne de cadrage projet SI (Claude Code)

Chaîne d'agents [Claude Code](https://claude.com/claude-code) qui transforme un **cahier des
charges** en livrables de cadrage prêts pour le développement : compréhension, backlog,
architecture, plans d'implémentation, conformité RGPD, artefacts d'infra, chiffrage et pilotage
GitHub Project.

> Contexte : DSI d'un cabinet d'expertise comptable. Stack cible **Vue 3 / TypeScript / Node.js /
> Docker**, BDD **PostgreSQL** ou **Supabase greffé** sur VM Azure. **Langue : français.**
> Principe : **conception uniquement** — les agents ne touchent jamais aux VMs/infra réelles.

## Prérequis
- **Claude Code CLI** : `npm install -g @anthropic-ai/claude-code` (puis `claude` pour se connecter).
- **Node.js + npm**, **PowerShell 7** (`pwsh`), **Git**, **GitHub CLI** (`gh auth login`).
- Pour le pilotage GitHub Project : scope `project` → `gh auth refresh -s project --hostname github.com`.

## Installation (chaque membre de l'équipe)
```powershell
git clone https://github.com/ITS-53/Agents.git
cd Agents
pwsh ./scripts/Install-Agents.ps1   # copie agents + commandes + script dans ~/.claude
```
L'installeur rend les chemins **portables** (adaptés à ton profil) et installe tout en **global** :
les commandes `/...` sont alors disponibles dans **n'importe quel dépôt**. Redémarre ta session
Claude Code après l'installation.

> Alternative sans installer en global : ouvre Claude Code **dans ce dépôt** ; les agents/commandes
> y sont reconnus directement (copies « projet »).

## La chaîne en un coup d'œil
```
CDC (.docx/.md)
   │  /completer-cdc        (optionnel : complète un CDC incomplet, grill-me)
   ▼
/cadrer-projet  ── orchestre tout ────────────────────────────────────────────┐
   ├─ /analyser-cdc      → cadrage/comprehension.md         (agent cdc-analyst) │
   ├─ /generer-backlog   → backlog/ (backlog.md + .csv)     (agent cdc-backlog) │
   ├─ /proposer-archi    → docs/ + docs/PROMPT-DEMARRAGE.md (agent cdc-architecte, grill-me)
   ├─ /planifier-story   → plans/<US>-plan.md               (agent cdc-story-plan)
   └─ /chiffrer          → chiffrage/chiffrage.md           (agent chiffrage)
                                                                                │
Actions aval (réelles, sur demande) : ─────────────────────────────────────────┘
   /audit-rgpd            → rgpd/note-dpo.md                (agent rgpd-dpo)
   /verifier-cadrage      → avis go/no-go                   (agent cadrage-qa)
   /generer-infra         → deploy/ + PR Azure-Infra        (agent infra-azure)
   /publier-github-project→ GitHub Project (Kanban/Roadmap) (agent github-project)
```

## Usage typique
```text
# Tout d'un coup, dans le dépôt de ton projet :
/cadrer-projet "C:\chemin\vers\cahier-des-charges.docx"

# ou étape par étape (chaque commande propose d'enchaîner la suivante) :
/analyser-cdc "...cdc.docx"
/generer-backlog cadrage/comprehension.md
/proposer-archi cadrage/comprehension.md
/planifier-story US-010 backlog/backlog.md docs/
/chiffrer backlog/backlog.md docs/
```
Les livrables sont écrits **à la racine du repo courant** (`cadrage/`, `backlog/`, `docs/`,
`plans/`, `chiffrage/`), pour que l'implémentation démarre dans le même repo via
`docs/PROMPT-DEMARRAGE.md`.

## Commandes & agents
| Commande | Agent | Rôle |
|---|---|---|
| `/completer-cdc` | cdc-redacteur | Complète un CDC incomplet (grill-me), sans rien inventer |
| `/analyser-cdc` | cdc-analyst | CDC → dossier de compréhension (lacunes, questions de cadrage) |
| `/generer-backlog` | cdc-backlog | Compréhension → backlog (epics, user stories, MoSCoW, Gherkin) |
| `/proposer-archi` | cdc-architecte | Grill-me → docs d'architecture + prompt de démarrage |
| `/planifier-story` | cdc-story-plan | Une story → plan d'implémentation détaillé |
| `/chiffrer` | chiffrage | Backlog → charge, TCO, planning, roadmap + GANTT Mermaid |
| `/audit-rgpd` | rgpd-dpo | Audit RGPD/AIPD → note pour le DPO |
| `/generer-aipd` | aipd | Rédige l'AIPD/DPIA complète (méthodologie CNIL) |
| `/verifier-cadrage` | cadrage-qa | Cohérence/traçabilité de la chaîne → avis go/no-go |
| `/generer-infra` | infra-azure | Artefacts de déploiement + ports sans collision (Azure-Infra) |
| `/publier-github-project` | github-project | Crée/alimente un GitHub Project (Kanban + Roadmap) |
| `/rapport-copil` | comite-projet | Rapport de comité de pilotage (avancement, budget, risques) |
| `/cadrer-projet` | *(orchestrateur)* | Déroule toute la chaîne d'un seul lancement |

## Conventions
- **Français** pour tous les livrables. **PowerShell 7** pour les scripts.
- **Conception uniquement** : aucun déploiement ni action sur les VMs réelles.
- Un agent ne doit **jamais inventer** une donnée absente d'une source : il signale la lacune.
- Infra : respecter le repo **`ITS-53/Azure-Infra`** (tranches de ports, `127.0.0.1` only, nginx
  seul public, 1 schéma/app + `core` partagé, RLS). Voir aussi le `.docx` du modèle de CDC dans `templates/`.

## GitHub Project — recommandation
**Un Project par projet/produit**, possédé par l'**organisation `ITS-53`** (pas un Project
personnel fourre-tout, ni un par repo). Un GitHub Project v2 n'est pas lié à un repo : il peut
agréger les issues de plusieurs repos d'un même produit (front/back/infra). Garde éventuellement
**un** Project « portfolio » d'organisation pour la roadmap macro inter-projets. Détails : voir
le commentaire de `/publier-github-project`.

## Faire évoluer la chaîne
1. Modifie les fichiers dans `.claude/agents/` ou `.claude/commands/` (source de vérité).
2. `git commit` + `git push` sur `main`.
3. Chaque membre relance `pwsh ./scripts/Install-Agents.ps1` pour récupérer la mise à jour en global.

## Démo
Un exemple complet de bout en bout (projet fictif « PEPITE ») est dans
[`analyses/demo/PEPITE/`](analyses/demo/PEPITE) : compréhension, backlog, docs + prompt de
démarrage, plan de story, note RGPD, chiffrage.
