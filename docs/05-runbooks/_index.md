---
title: Runbooks
tags: [runbooks, procedures]
status: ready
---

# 05 — Runbooks

Procédures et recettes pour les tâches courantes du lab.

## Contenu

- [[demarrage-complet|Démarrage complet du lab]]
- [[ajouter-un-outil|Ajouter un nouvel outil]]

## Accès rapide

```bash
# Démarrer tout le lab
k3d cluster start devops-lab
cd ~/dev/devops-labs/tools/coroot && docker compose up -d
cd ~/dev/devops-labs/tools/victoria-metrics && docker compose up -d

# Vérifier l'état
k3d cluster list
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
kubectl get pods -A
```
