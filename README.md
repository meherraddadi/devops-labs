# DevOps Labs — Meher Raddadi

Environnement de test local pour évaluer les outils DevOps 2026.

## Stack de base

- **OS** : WSL2 (Ubuntu) sur Windows
- **Container runtime** : Docker
- **Local K8s** : k3d (k3s dans Docker)

## Structure

```
devops-labs/
├── k3d/                    # Setup cluster K8s local
├── tools/
│   ├── coroot/             # Observabilité automatique (eBPF)
│   ├── victoria-metrics/   # Metrics storage + Grafana
│   ├── perses/             # Dashboards as code
│   ├── trivy-operator/     # Scan CVE continu dans K8s
│   ├── falco/              # Détection runtime d'anomalies
│   ├── robusta/            # Alerting K8s intelligent
│   ├── k8sgpt/             # Analyse K8s par IA
│   ├── glasskube/          # Package manager K8s moderne
│   ├── ollama/             # LLMs locaux + Open WebUI
│   ├── crossplane/         # Infrastructure as Code K8s-native
│   ├── mirrord/            # Dev local connecté au cluster K8s
│   ├── opentelemetry/      # Traces + métriques + logs unifiés
│   ├── karpenter/          # Autoscaling de nœuds K8s
│   └── headroom/           # Compression de contexte IA — réduction tokens 60-95%
├── docs/                   # Vault Obsidian (documentation complète)
│   ├── 01-infrastructure/  # k3d, Crossplane, Karpenter
│   ├── 02-observabilite/   # Coroot, VictoriaMetrics, Perses, OTel, Ollama
│   ├── 03-securite/        # Trivy, Falco, Robusta
│   ├── 04-outils/          # k8sgpt, Glasskube, Mirrord
│   └── 05-runbooks/        # Procédures et démarrage
└── scripts/                # Scripts d'automatisation
```

## Démarrage rapide

```bash
# Bootstrap complet (installe k3d + crée le cluster)
bash scripts/setup.sh

# Démarrer un outil Docker Compose
cd tools/ollama && docker compose up -d
cd tools/coroot && docker compose up -d
cd tools/victoria-metrics && docker compose up -d
```

## URLs après démarrage

| Outil | URL | Type |
|---|---|---|
| Open WebUI (LLMs) | http://localhost:3001 | Docker Compose |
| Coroot | http://localhost:8080 | Docker Compose |
| VictoriaMetrics UI | http://localhost:8428/vmui | Docker Compose |
| Grafana | http://localhost:3000 | Docker Compose |
| Perses | http://localhost:8080 | Docker Compose |
| Jaeger (traces) | http://localhost:16686 | Docker Compose |
| Glasskube UI | http://localhost:8580 | K8s (k3d) |
| Headroom proxy | http://localhost:8787 | Docker Compose |

> ⚠️ Coroot et Perses utilisent tous deux le port 8080. Ne pas les démarrer simultanément.

## Philosophie

Chaque outil a son propre dossier avec :
- `README.md` — ce que c'est, pourquoi ça existe, comment l'utiliser
- `docker-compose.yml` ou manifests K8s selon le cas
- Script de démarrage si nécessaire

## Pré-requis

- Docker Desktop ou Docker Engine
- kubectl, helm, git
- k3d (installé par `scripts/setup.sh`)
