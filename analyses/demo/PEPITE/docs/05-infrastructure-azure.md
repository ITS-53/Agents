# PEPITE — Infrastructure, Docker & déploiement

> Aligné sur **Azure-Infra** (PORTS.md, ARCHITECTURE-CIBLE.md, DATABASE.md).
> ⚠️ **Conception uniquement** — aucune action n'a été menée sur les VMs réelles.

## 1. Allocation de ports (tranches Azure-Infra)
Tout écoute sur **`127.0.0.1`** ; seul **nginx** (443) est public.

| Service | Port cible | Tranche | Upstream nginx | Justification |
|---|---|---|---|---|
| `pepite-web` (SPA statique) | **8107** | 81xx | `pepite_web` | Prochain port frontend libre (8101→8106 pris) |
| `pepite-api` (NestJS) | **8108** | 81xx | `pepite_api` | Suit immédiatement le front |
| `pepite-worker` | — | — | — | Pas d'écoute HTTP (jobs) |
| `redis` (file de jobs) | interne réseau compose | — | — | Non exposé |
| Supabase API (kong) | 8400 *(existant)* | 84xx | — | **Partagé**, non dupliqué |

> ✅ Aucune collision avec l'allocation actuelle (landing 8101, qualineo 8102, ci 8103, grp
> 8104, borne 8105, assets 8106, supabase 8400/8401/8402, PG 5401/5402). **Pas** de PG dédié
> (base greffée dans Supabase).

## 2. Layout de déploiement (standard P1)
```
/opt/stacks/pepite/
  compose.yml        # web:8107, api:8108, worker, redis — tous sur 127.0.0.1
  .env.<env>         # secrets (jamais commités)
  README.md          # lien vers le repo applicatif PEPITE
```

## 3. nginx (à ajouter au repo Azure-Infra, pas modifié ici)
- `conf.d/10-upstreams.conf` : `upstream pepite_web { server 127.0.0.1:8107; }` /
  `upstream pepite_api { server 127.0.0.1:8108; }`
- `sites-available/pepite.conf` : vhost `pepite.<ip>.nip.io` → `/` vers `pepite_web`,
  `/api/` vers `pepite_api` ; buffers élargis si appels OAuth proxifiés.
- Déploiement : `bash scripts/deploy-nginx.sh` ; vérif `curl -H "Host: pepite.<ip>.nip.io" http://127.0.0.1/`.

## 4. Conteneurs (Docker multi-stage)
- `pepite-web` : build Vite → image nginx servant le statique sur 8107.
- `pepite-api` : build NestJS (TS→JS) → image Node slim, `node dist/main.js`, expose 8108.
- `pepite-worker` : même image que l'API, commande `node dist/worker.js`.
- `redis` : image officielle, volume persistant.

`compose.yml` (esquisse) :
```yaml
services:
  web:    { build: ./web, ports: ["127.0.0.1:8107:80"], restart: unless-stopped }
  api:    { build: ./api, ports: ["127.0.0.1:8108:8108"], env_file: .env.${ENV}, depends_on: [redis] }
  worker: { build: ./api, command: node dist/worker.js, env_file: .env.${ENV}, depends_on: [redis] }
  redis:  { image: redis:7-alpine, volumes: ["redis-data:/data"] }
volumes: { redis-data: {} }
```

## 5. Environnements (isolation physique — DATABASE.md)
| Env | Base | Hôte | Notes |
|---|---|---|---|
| **dev** | Supabase CLI local | poste dev | Jetable, schéma `pepite` appliqué via migrations |
| **staging** | Supabase staging (instance dédiée) | VM STAGING | ⚠️ disque STAGING à 90 % — surveiller |
| **prod** | Supabase prod (instance dédiée) | VM PROD | Sauvegardes indépendantes |

Migrations jouées **dev → staging → prod**, jamais directement en prod.

## 6. CI/CD — GitHub Actions (build/test ; déploiement manuel)
```yaml
# .github/workflows/ci.yml (esquisse)
on: [push, pull_request]
jobs:
  quality:
    runs-on: [self-hosted, tools]   # runner sur VM TOOLS
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint && npm run typecheck
      - run: npm run test          # unitaires + e2e (Postgres éphémère)
      - run: docker build -t registry/pepite-api:${{ github.sha }} ./api
      - run: docker build -t registry/pepite-web:${{ github.sha }} ./web
      # push vers le registre ; DÉPLOIEMENT MANUEL ensuite (docker compose up -d sur /opt/stacks/pepite)
```

## 7. Sauvegarde / PRA
- **RPO 24 h / RTO 4 h** (valeurs validées) : sauvegarde quotidienne Postgres (prod isolée) ;
  Blob WORM = durabilité native + versioning.
- Restauration **testée** par un exercice réel (règle d'administration infra).

## 8. Observabilité (cible OBS)
Exporters en tranche **90xx** (node-exporter 9100, cAdvisor 9101) scrutés par Prometheus/Loki/
Grafana sur la VM OBS ; logs applicatifs structurés (JSON) poussés vers Loki.
