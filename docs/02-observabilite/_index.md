---
title: Observabilité
tags: [observabilite, monitoring, metrics, dashboards]
status: ready
---

# 02 — Observabilité

Les outils de cette section permettent de **voir ce qui se passe** dans tes systèmes : métriques, logs, traces, dépendances entre services.

## Contenu

- [[coroot|Coroot — Observabilité automatique]]
- [[victoria-metrics|VictoriaMetrics — Stockage métriques]]
- [[perses|Perses — Dashboards as Code]]
- [[opentelemetry|OpenTelemetry — Traces, métriques, logs unifiés]]
- [[ollama|Ollama + Open WebUI — LLMs locaux]]

## Les trois piliers de l'observabilité

```mermaid
graph TD
    M["📊 Métriques\nVictoriaMetrics\n— CPU, RAM, latence,\nerrors, saturation"] 
    L["📋 Logs\nLoki / stdout\n— Messages applicatifs,\nerreurs, traces"]
    T["🔍 Traces\nOpenTelemetry\n— Chemin d'une requête\nà travers les services"]
    C["🗺️ Coroot\nCorrèle les 3 automatiquement\nsans configuration"]

    M --> C
    L --> C
    T --> C
```

## Stack recommandée par cas d'usage

| Besoin | Outil |
|---|---|
| Voir les dépendances entre services automatiquement | [[coroot\|Coroot]] |
| Remplacer Prometheus/Mimir (moins de RAM) | [[victoria-metrics\|VictoriaMetrics]] |
| Dashboards versionnés dans Git | [[perses\|Perses]] |
| Alerting enrichi K8s | [[03-securite/robusta\|Robusta]] |

## Type d'installation

Tous les outils de cette section tournent en **Docker Compose** — pas besoin du cluster k3d.
