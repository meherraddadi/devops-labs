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
│   ├── k8sgpt/             # Analyse K8s par IA
│   ├── coroot/             # Observabilité automatique
│   ├── victoria-metrics/   # Metrics storage alternatif à Prometheus
│   ├── trivy-operator/     # Scan CVE continu dans K8s
│   ├── falco/              # Détection runtime d'anomalies
│   ├── robusta/            # Alerting K8s intelligent
│   ├── perses/             # Dashboards as code (successeur Grafana)
│   └── glasskube/          # Package manager K8s moderne
└── scripts/                # Scripts d'automatisation
```

## Démarrage rapide

```bash
# 1. Installer k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# 2. Créer le cluster de lab
k3d cluster create devops-lab --config k3d/clusters/devops-lab.yaml

# 3. Vérifier
kubectl get nodes
```

## Philosophie

Chaque outil a son propre dossier avec :
- `README.md` — ce que c'est, pourquoi ça existe, comment l'utiliser
- `docker-compose.yml` ou manifests K8s selon le cas
- Script de démarrage si nécessaire

## Pré-requis

- Docker Desktop ou Docker Engine
- kubectl
- helm
- git
