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

**Crossplane** — Outil Kubernetes qui permet de gérer des ressources cloud (Azure, AWS, GCP) via des CRDs K8s. L'état désiré est décrit en YAML K8s.

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

## J

**Jaeger** — Plateforme open source pour visualiser les traces distribuées. Reçoit les données via OTLP ou son protocole natif.

## K

**Karpenter** — Autoscaler de nœuds Kubernetes. Provisionne le bon type de VM en 30-60 secondes quand des pods sont `Pending`. Intégré dans AKS via Node Auto Provisioning (NAP).

**k3d** — Outil qui fait tourner k3s dans Docker pour créer des clusters Kubernetes locaux légers.

**k3s** — Distribution Kubernetes allégée par Rancher Labs. Idéale pour les environnements de dev et edge.

**kubectl** — CLI officielle pour interagir avec un cluster Kubernetes.

## L

**LLM (Large Language Model)** — Modèle d'IA génératif entraîné sur de grandes quantités de texte. Ex : Claude, GPT-4.

## M

**MCP (Model Context Protocol)** — Protocole d'Anthropic permettant à Claude de se connecter à des outils externes (bases de données, APIs, etc.).

**Mirrord** — Outil de Developer Experience qui redirige le trafic réseau, les variables d'env et les syscalls d'un process local vers un pod K8s distant. Élimine le cycle build/push/deploy pendant le développement.

**Mermaid** — Syntaxe pour créer des diagrammes en Markdown. Supporté par Obsidian et GitHub.

## O

**Ollama** — Runtime pour exécuter des LLMs open source (Llama, Mistral, Phi-3...) en local, sans cloud.

**OpenTelemetry (OTel)** — Standard CNCF pour l'instrumentation des applications. Collecte traces, métriques et logs avec un SDK unique et le protocole OTLP.

**Operator K8s** — Pattern Kubernetes qui encapsule la logique opérationnelle d'une application dans un controller.

**OTLP (OpenTelemetry Protocol)** — Protocole standard pour envoyer des données d'observabilité (traces, métriques, logs) vers n'importe quel backend compatible.

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
