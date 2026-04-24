# VictoriaMetrics — Stockage métriques haute performance

## C'est quoi ?

VictoriaMetrics est une base de données time-series **compatible PromQL** qui remplace Prometheus/Mimir. Elle est écrite en Go et optimisée pour la compression et la vitesse.

## Pourquoi c'est intéressant vs Prometheus/Mimir

| Critère | Prometheus | Mimir | VictoriaMetrics |
|---|---|---|---|
| RAM pour 1M séries | ~8 GB | ~4 GB | ~1 GB |
| Compression disque | 1x | 2x | 10x |
| Compatibilité PromQL | Native | Native | Native |
| Setup | Simple | Complexe | Simple |
| Clustering | Non | Oui | Oui (Enterprise) |

Si tes coûts Grafana Cloud montent, VictoriaMetrics en self-hosted peut remplacer Mimir.

## Type d'installation

**Docker Compose** — standalone.

## Démarrage

```bash
cd tools/victoria-metrics
docker compose up -d
```

- VictoriaMetrics : `http://localhost:8428`
- VMAgent (scraping) : `http://localhost:8429`
- Grafana : `http://localhost:3000` (admin/admin)

## Utilisation avec Grafana

1. Ouvre Grafana sur `http://localhost:3000`
2. Ajouter une datasource → Prometheus
3. URL : `http://victoria-metrics:8428`
4. Tes dashboards Prometheus existants fonctionnent sans modification

## Requêtes PromQL

VictoriaMetrics accepte exactement les mêmes requêtes que Prometheus :

```promql
# Utilisation CPU
rate(process_cpu_seconds_total[5m])

# Mémoire
process_resident_memory_bytes / 1024 / 1024

# Requêtes MetricsQL (extensions de VictoriaMetrics)
rate(http_requests_total[5m]) keep_metric_names
```

## Migration depuis Prometheus

VictoriaMetrics expose le même endpoint que Prometheus :
- `/api/v1/query` — requête instantanée
- `/api/v1/query_range` — requête sur plage de temps
- `/api/v1/write` — remote write depuis Prometheus/agent
