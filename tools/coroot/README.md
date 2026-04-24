# Coroot — Observabilité automatique

## C'est quoi ?

Coroot est une plateforme d'observabilité qui **découvre automatiquement** toutes les dépendances entre tes services et génère des dashboards sans aucune configuration. Il utilise eBPF pour observer le trafic réseau au niveau kernel — zéro instrumentation de code.

## Utilité concrète

Avec Prometheus + Grafana classique :
- Tu dois créer les dashboards manuellement
- Tu dois instrumenter chaque service
- Trouver pourquoi le service A est lent prend 30 min

Avec Coroot :
- Démarre, et en 2 minutes tu vois la carte de toutes les dépendances
- Il détecte automatiquement les goulots d'étranglement
- Il corrèle les logs, métriques et traces automatiquement

## Type d'installation

**Docker Compose** — standalone, pas besoin de K8s.

## Démarrage

```bash
cd tools/coroot
docker compose up -d
```

Accès : `http://localhost:8080`

## docker-compose.yml

Voir le fichier `docker-compose.yml` dans ce dossier.

## Première utilisation

1. Ouvre `http://localhost:8080`
2. Coroot scanne automatiquement les containers Docker actifs
3. La carte des services apparaît en quelques minutes
4. Clique sur un service pour voir : latence, erreurs, logs, dépendances

## Ce que Coroot surveille automatiquement

- **Latence** p50/p95/p99 entre services
- **Taux d'erreur** par service
- **Utilisation CPU/RAM** par container
- **Requêtes SQL** (détection automatique)
- **Appels HTTP** entre services
- **Logs** corrélés avec les métriques

## Intégration avec Prometheus existant

Si tu as déjà Prometheus/Grafana, Coroot peut se brancher dessus :
```yaml
# dans docker-compose.yml, ajouter :
environment:
  - PROMETHEUS_URL=http://prometheus:9090
```
