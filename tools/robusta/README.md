# Robusta — Alerting K8s intelligent

## C'est quoi ?

Robusta enrichit tes alertes Prometheus avec du **contexte automatique**. Quand une alerte se déclenche, Robusta collecte les logs, les events K8s, et l'état des pods associés, puis envoie tout ça dans une notification Slack/Teams enrichie.

## Le problème qu'il résout

Alerte Prometheus classique dans Slack :
```
🔴 FIRING: PodCrashLooping
alertname=PodCrashLooping namespace=production pod=api-7d9f-xkp2q
```
→ Tu dois aller manuellement chercher les logs, les events, etc.

Alerte Robusta :
```
🔴 PodCrashLooping — api-7d9f-xkp2q (production)
Logs des dernières 5 min : "Error: cannot connect to database: connection refused"
Events K8s : OOMKilled x3, BackOff x12
Graphe CPU/RAM : [graphe intégré]
[Bouton] Voir dans Grafana  [Bouton] Silence 1h
```

## Pré-requis

- Cluster k3d démarré
- Prometheus installé dans le cluster (ou Grafana Cloud)
- Un webhook Slack ou Teams

## Installation

```bash
helm repo add robusta https://robusta-charts.storage.googleapis.com
helm repo update

# Générer la config
helm show values robusta/robusta > robusta-values.yaml
# Éditer robusta-values.yaml : ajouter Slack webhook, Prometheus URL

helm install robusta robusta/robusta \
  --namespace robusta \
  --create-namespace \
  --values robusta-values.yaml
```

## Configuration minimale (robusta-values.yaml)

```yaml
sinksConfig:
  - slack_sink:
      name: slack-devops
      slack_channel: "#alertes-k8s"
      api_key: "xoxb-ton-token-slack"

globalConfig:
  prometheus_url: "http://prometheus-server.monitoring:9090"
```

## Actions automatiques disponibles

Robusta peut exécuter des actions automatiques sur alerte :

```yaml
# Redémarrer automatiquement un pod en OOMKill
triggers:
  - on_prometheus_alert:
      alert_name: KubePodOOMKilled
actions:
  - restart_pod: {}
  - send_slack_message:
      message: "Pod redémarré automatiquement suite à OOMKill"
```

## Playbooks utiles

| Alerte | Action automatique possible |
|---|---|
| PodCrashLooping | Collecter logs + events |
| NodeMemoryPressure | Lister pods par consommation RAM |
| PVCNearlyFull | Alerter avec taille actuelle/max |
| DeploymentFailed | Rollback automatique |
