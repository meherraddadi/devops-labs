---
title: Glossaire DevOps
tags: [glossaire, definitions]
status: ready
---

# Glossaire

## A

**ArgoCD** — Outil GitOps de déploiement continu pour Kubernetes. Synchronise l'état du cluster avec un repo Git.

## C

**CRD (Custom Resource Definition)** — Extension de l'API Kubernetes qui permet de définir ses propres types de ressources.

**CVE (Common Vulnerabilities and Exposures)** — Identifiant unique d'une vulnérabilité de sécurité connue.

## D

**DaemonSet** — Ressource Kubernetes qui garantit qu'un pod tourne sur chaque nœud du cluster. Utilisé par Falco, les agents de monitoring, etc.

**Docker Compose** — Outil pour définir et lancer des applications multi-containers avec un fichier YAML.

## E

**eBPF (extended Berkeley Packet Filter)** — Technologie Linux qui permet d'exécuter du code dans le kernel sans modifier le kernel lui-même. Utilisé par Falco et Coroot pour observer les syscalls et le réseau.

## G

**GitOps** — Pratique où l'état désiré de l'infrastructure est décrit dans Git, et un agent synchronise automatiquement le système réel avec cet état.

## H

**Helm** — Package manager pour Kubernetes. Les packages s'appellent des "charts".

## K

**k3d** — Outil qui fait tourner k3s dans Docker pour créer des clusters Kubernetes locaux légers.

**k3s** — Distribution Kubernetes allégée par Rancher Labs. Idéale pour les environnements de dev et edge.

**kubectl** — CLI officielle pour interagir avec un cluster Kubernetes.

## L

**LLM (Large Language Model)** — Modèle d'IA génératif entraîné sur de grandes quantités de texte. Ex : Claude, GPT-4.

## M

**MCP (Model Context Protocol)** — Protocole d'Anthropic permettant à Claude de se connecter à des outils externes (bases de données, APIs, etc.).

**Mermaid** — Syntaxe pour créer des diagrammes en Markdown. Supporté par Obsidian et GitHub.

## O

**Operator K8s** — Pattern Kubernetes qui encapsule la logique opérationnelle d'une application dans un controller.

**Obsidian** — Éditeur de notes basé sur Markdown avec support des wiki links et visualisation des connexions.

## P

**Pod** — Unité de base de déploiement dans Kubernetes. Contient un ou plusieurs containers.

**PromQL** — Langage de requête de Prometheus pour interroger les métriques time-series.

## Q

**Qdrant** — Base de données vectorielle open source utilisée pour le RAG.

## R

**RAG (Retrieval Augmented Generation)** — Architecture IA qui enrichit le contexte d'un LLM avec des données récupérées depuis une base de connaissances.

## S

**Syscall (System Call)** — Interface entre un programme et le kernel Linux pour accéder aux ressources système (fichiers, réseau, mémoire).

## T

**Time-series** — Séquence de valeurs numériques indexées par le temps. Format de base des métriques de monitoring.

## W

**WSL2 (Windows Subsystem for Linux 2)** — Couche de compatibilité Linux dans Windows, avec un vrai kernel Linux.
