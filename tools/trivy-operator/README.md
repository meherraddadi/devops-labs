# Trivy Operator — Scan CVE continu dans K8s

## C'est quoi ?

Trivy Operator installe Trivy **directement dans le cluster** et scanne en continu toutes les images de tes pods. Chaque nouveau déploiement est automatiquement scanné. Les résultats sont stockés comme des ressources Kubernetes (CRDs) et visibles via `kubectl`.

## Différence avec Trivy en CI

| | Trivy en CI (GitHub Actions) | Trivy Operator |
|---|---|---|
| Quand ? | Au build | En continu dans le cluster |
| Quoi ? | L'image au moment du build | Toutes les images actuellement déployées |
| Nouvelles CVE ? | Non détectées | Détectées automatiquement |
| Résultats | Logs CI | kubectl / Grafana |

Les deux sont complémentaires — tu as déjà le CI, l'operator couvre les CVE qui apparaissent après le déploiement.

## Pré-requis

- Cluster k3d démarré
- kubectl configuré

## Installation

```bash
# Ajouter le repo Helm
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update

# Installer dans le cluster
helm install trivy-operator aqua/trivy-operator \
  --namespace trivy-system \
  --create-namespace \
  --set trivy.ignoreUnfixed=true
```

## Utilisation

```bash
# Voir les rapports de vulnérabilités
kubectl get vulnerabilityreports -A

# Détail d'un rapport
kubectl describe vulnerabilityreport <nom> -n <namespace>

# Voir les config audits (mauvaises pratiques K8s)
kubectl get configauditreports -A

# Output court — juste les CRITICAL
kubectl get vulnerabilityreports -A -o json | \
  jq '.items[] | select(.report.summary.criticalCount > 0) | 
  {name: .metadata.name, namespace: .metadata.namespace, critical: .report.summary.criticalCount}'
```

## Exemple de sortie

```
NAMESPACE   NAME                              CRITICAL  HIGH  MEDIUM
default     replicaset-nginx-7d9f-nginx       2         15    43
default     replicaset-api-6c8b-api           0         3     12
```

## Dashboard Grafana (optionnel)

Trivy Operator expose des métriques Prometheus. Importer le dashboard ID `17813` dans Grafana pour visualiser les CVE par namespace/severity.
