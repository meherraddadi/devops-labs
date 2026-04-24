# Perses — Dashboards as Code (successeur Grafana)

## C'est quoi ?

Perses est un projet CNCF créé par l'équipe core de Grafana. C'est le successeur spirituel de Grafana, conçu dès le départ pour le **GitOps** : les dashboards sont des fichiers YAML/JSON versionnés dans Git, pas des objets cliqués dans une UI.

## Différence avec Grafana

| | Grafana | Perses |
|---|---|---|
| Dashboards | Stockés en DB, exportables JSON | Fichiers YAML natifs dans Git |
| GitOps | Compliqué (Grafonnet, grizzly...) | Natif |
| CRD K8s | Non | Oui — `PersesDashboard` resource |
| Status | Mature | Encore jeune (2024-2026) |

Si tu veux des dashboards reviewés en PR comme du code, Perses est l'avenir.

## Pré-requis

- Docker installé

## Démarrage

```bash
cd tools/perses
docker compose up -d
```

Accès : `http://localhost:8080`

## Créer un dashboard en YAML

```yaml
# dashboard.yaml
kind: Dashboard
metadata:
  name: kubernetes-overview
  project: devops-lab
spec:
  display:
    name: Kubernetes Overview
  duration: 1h
  panels:
    - kind: Panel
      spec:
        display:
          name: CPU Usage
        plugin:
          kind: TimeSeriesChart
        queries:
          - kind: TimeSeriesQuery
            spec:
              plugin:
                kind: PrometheusTimeSeriesQuery
                spec:
                  query: rate(container_cpu_usage_seconds_total[5m])
```

```bash
# Appliquer le dashboard
percli apply -f dashboard.yaml

# Lister les dashboards
percli get dashboards
```

## Installation CLI

```bash
# Linux / WSL2
curl -LO https://github.com/perses/perses/releases/latest/download/percli_linux_amd64.tar.gz
tar -xzf percli_linux_amd64.tar.gz
sudo mv percli /usr/local/bin/
percli version
```
