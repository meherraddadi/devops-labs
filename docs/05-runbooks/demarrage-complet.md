---
title: Démarrage complet du lab
tags: [runbook, demarrage, setup]
status: ready
---

# Démarrage complet du lab

## Nouveau PC — Installation from scratch

```bash
# 1. Cloner le repo
git clone git@github.com:meherraddadi/devops-labs.git
cd devops-labs

# 2. Bootstrap automatique
bash scripts/setup.sh
# → installe k3d + crée le cluster devops-lab

# 3. Démarrer les outils Docker Compose selon le besoin
cd tools/coroot && docker compose up -d && cd ../..
cd tools/victoria-metrics && docker compose up -d && cd ../..
cd tools/perses && docker compose up -d && cd ../..
```

## Reprise après reboot WSL2

```bash
# Le cluster k3d s'arrête avec WSL2, le relancer :
k3d cluster start devops-lab

# Les containers Docker Compose redémarrent automatiquement
# (restart: unless-stopped dans les docker-compose.yml)

# Vérifier
kubectl get nodes
docker ps --format "table {{.Names}}\t{{.Status}}"
```

## URLs d'accès après démarrage

| Outil | URL | Notes |
|---|---|---|
| Coroot | http://localhost:8080 | Docker Compose |
| VictoriaMetrics UI | http://localhost:8428/vmui | Docker Compose |
| VMAgent | http://localhost:8429 | Docker Compose |
| Grafana (VM stack) | http://localhost:3000 | admin/admin |
| Perses | http://localhost:8080 | Docker Compose (port 8080 aussi) |

> ⚠️ Coroot et Perses utilisent tous les deux le port 8080. Ne pas les démarrer en même temps.

## Vérification de l'état

```bash
# Cluster k3d
k3d cluster list
kubectl get nodes
kubectl get pods -A | grep -v Running

# Containers Docker
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Qdrant (RAG DevOps)
curl -s http://localhost:6333/ | python3 -c "import sys,json; d=json.load(sys.stdin); print('Qdrant', d['version'])"
```
