---
title: Infrastructure — Cluster K8s local
tags: [infrastructure, k3d, kubernetes]
status: ready
---

# 01 — Infrastructure

Cette section couvre la couche de base du lab : le cluster Kubernetes local et son architecture.

## Contenu

- [[k3d|k3d — Cluster Kubernetes local]]

## Pourquoi un cluster local ?

La plupart des outils DevOps modernes sont conçus pour Kubernetes. Tester sur les clusters de production est risqué. Un cluster local permet de :

- Expérimenter sans risque
- Reproduire des scénarios d'incidents
- Valider des configurations avant de les pousser en prod
- Former et documenter des procédures

## Comparatif solutions K8s locales

| Solution | RAM | Démarrage | WSL2 | Multi-cluster |
|---|---|---|---|---|
| **k3d** ✅ | ~300 MB | ~20 sec | Parfait | Oui |
| kind | ~500 MB | ~1 min | OK | Oui |
| minikube | ~2 GB | ~2 min | Problématique | Limité |
| Docker Desktop K8s | ~4 GB | ~5 min | Natif | Non |
