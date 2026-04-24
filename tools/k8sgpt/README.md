# k8sgpt — Analyse K8s par IA

## C'est quoi ?

k8sgpt analyse ton cluster Kubernetes et **explique les problèmes en langage naturel** grâce à un LLM. Un pod en CrashLoopBackOff ? k8sgpt lit les logs, les events, et te dit en clair ce qui ne va pas et comment le corriger.

## Utilité concrète

Sans k8sgpt :
```
kubectl describe pod mon-pod
# → 200 lignes à lire, event cryptique "Back-off restarting failed container"
```

Avec k8sgpt :
```
k8sgpt analyze
# → "Le pod échoue car la variable d'environnement DATABASE_URL est manquante.
#    Le secret 'app-secrets' référencé n'existe pas dans le namespace."
```

## Type d'installation

**CLI standalone** — pas besoin de K8s pour commencer, mais peut aussi tourner comme operator dans le cluster.

## Installation (CLI)

```bash
# Linux / WSL2
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/latest/download/k8sgpt_linux_amd64.tar.gz
tar -xzf k8sgpt_linux_amd64.tar.gz
sudo mv k8sgpt /usr/local/bin/
k8sgpt version
```

## Configuration avec Claude/Anthropic

```bash
# Configurer le backend IA
k8sgpt auth add --backend anthropic --model claude-sonnet-4-6
# → entre ton API key Anthropic quand demandé

# Vérifier
k8sgpt auth list
```

## Utilisation

```bash
# Analyse complète du cluster courant
k8sgpt analyze

# Avec explication détaillée par l'IA
k8sgpt analyze --explain

# Filtrer par namespace
k8sgpt analyze --namespace production --explain

# Filtrer par type de ressource
k8sgpt analyze --filter Pod,Service --explain

# Output JSON (pour automatisation)
k8sgpt analyze --explain --output json
```

## Exemple de sortie

```
0 default/mon-deployment-7d9f8b-xkp2q(mon-deployment)
- Error: Back-off restarting failed container

AI Analysis:
Le container échoue au démarrage car il ne trouve pas le fichier de config
/app/config.yaml. Ce fichier est monté depuis le ConfigMap 'app-config' qui
n'existe pas dans le namespace 'default'. Créez le ConfigMap manquant :

kubectl create configmap app-config --from-file=config.yaml
```

## Installation comme Operator K8s (optionnel)

```bash
# Avec Helm dans le cluster k3d
helm repo add k8sgpt-operator https://charts.k8sgpt.ai/
helm install k8sgpt-operator k8sgpt-operator/k8sgpt-operator \
  --namespace k8sgpt-operator-system \
  --create-namespace
```
