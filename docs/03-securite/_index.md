---
title: Sécurité K8s
tags: [securite, kubernetes, cve, runtime]
status: ready
---

# 03 — Sécurité

Les outils de cette section couvrent la sécurité à plusieurs niveaux du cycle de vie K8s.

## Contenu

- [[trivy-operator|Trivy Operator — Scan CVE continu]]
- [[falco|Falco — Détection runtime d'anomalies]]
- [[robusta|Robusta — Alerting K8s enrichi]]

## Les 3 couches de sécurité K8s

```mermaid
graph TD
    subgraph "Shift Left — Avant déploiement"
        CI["Trivy en CI\nGitHub Actions\n(scan à chaque build)"]
    end

    subgraph "Shift Right — Après déploiement"
        OP["Trivy Operator\nScan continu CVE\nnouveaux pods"]
        FALCO["Falco\nDétection comportements\nanormaux à runtime"]
    end

    subgraph "Réponse aux incidents"
        ROB["Robusta\nAlertes enrichies\nactions automatiques"]
    end

    CI --> OP
    OP --> ROB
    FALCO --> ROB
```

## Tous les outils nécessitent le cluster k3d

```bash
# S'assurer que le cluster est démarré
k3d cluster start devops-lab
kubectl config use-context k3d-devops-lab
```
