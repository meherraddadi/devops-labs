---
title: Robusta — Alerting K8s enrichi
tags: [securite, alerting, kubernetes, slack, teams]
status: ready
---

# Robusta — Alerting K8s enrichi

## C'est quoi ?

Robusta enrichit tes alertes Prometheus/Falco avec du **contexte automatique** : logs récents, events K8s, graphes de ressources — tout packagé dans une notification Slack ou Teams exploitable sans ouvrir kubectl.

## Le problème qu'il résout

```
Alerte Prometheus classique :
┌─────────────────────────────────────────────┐
│ 🔴 FIRING: PodCrashLooping                  │
│ pod=api-7d9f-xkp2q namespace=production     │
│ → Tu dois aller chercher les logs manuellement │
└─────────────────────────────────────────────┘

Alerte Robusta :
┌─────────────────────────────────────────────┐
│ 🔴 PodCrashLooping — api-7d9f (production)  │
│                                             │
│ Logs (5 dernières min) :                    │
│  Error: cannot connect to DB: conn refused  │
│                                             │
│ Events K8s :                                │
│  OOMKilled ×3 | BackOff ×12               │
│                                             │
│ CPU: ▓▓▓▓░░ 67% | RAM: ▓▓▓▓▓▓ 94%         │
│                                             │
│ [Voir Grafana] [Silence 1h] [Restart pod]  │
└─────────────────────────────────────────────┘
```

## Architecture

```mermaid
graph LR
    subgraph "Sources d'alertes"
        PROM["Prometheus\nAlertmanager"]
        FALCO["Falco\nRuntime alerts"]
    end

    subgraph "Cluster k3d"
        ROB["Robusta Runner\n(Operator)"]
        K8S["Kubernetes API\n(logs, events, metrics)"]
    end

    subgraph "Destinations"
        SLACK["Slack"]
        TEAMS["Teams"]
        PAGERDUTY["PagerDuty"]
    end

    PROM --> ROB
    FALCO --> ROB
    ROB <-->|"enrichissement"| K8S
    ROB --> SLACK
    ROB --> TEAMS
    ROB --> PAGERDUTY
```

## Installation dans k3d

```bash
helm repo add robusta https://robusta-charts.storage.googleapis.com
helm repo update

# Créer la config minimale
cat > robusta-values.yaml << 'EOF'
sinksConfig:
  - slack_sink:
      name: slack-devops
      slack_channel: "#alertes-k8s"
      api_key: "xoxb-TON-TOKEN-SLACK"

globalConfig:
  prometheus_url: "http://kube-prometheus-stack-prometheus.monitoring:9090"
EOF

helm install robusta robusta/robusta \
  --namespace robusta \
  --create-namespace \
  --values robusta-values.yaml

kubectl get pods -n robusta
```

## Playbooks — actions automatiques sur alerte

Robusta peut exécuter des actions automatiquement quand une alerte se déclenche.

### Exemple : collecter les logs sur CrashLoopBackOff

```yaml
# robusta-values.yaml
customPlaybooks:
  - triggers:
      - on_prometheus_alert:
          alert_name: KubePodCrashLooping
    actions:
      - logs_enricher: {}
      - event_enricher: {}
```

### Exemple : restart automatique sur OOMKill

```yaml
customPlaybooks:
  - triggers:
      - on_prometheus_alert:
          alert_name: KubePodOOMKilled
    actions:
      - restart_pod: {}
      - slack_enricher:
          message: "Pod redémarré automatiquement suite à OOMKill"
```

## Playbooks disponibles

| Action | Description |
|---|---|
| `logs_enricher` | Ajoute les logs récents du pod à l'alerte |
| `event_enricher` | Ajoute les events K8s du pod |
| `restart_pod` | Redémarre le pod |
| `rollback_deployment` | Rollback vers la version précédente |
| `node_cpu_enricher` | Ajoute le graphe CPU du nœud |
| `pod_graph_enricher` | Graphe CPU/RAM du pod |

## Intégration avec Falco

```yaml
customPlaybooks:
  - triggers:
      - on_pod_all_changes:
          name_prefix: "falco"
    actions:
      - slack_enricher:
          message: "Alerte Falco détectée"
```

## Liens

- [[_index|← Retour Sécurité]]
- [[falco|Falco — Source d'alertes runtime pour Robusta]]
- [[trivy-operator|Trivy Operator — CVE alerts routables via Robusta]]
