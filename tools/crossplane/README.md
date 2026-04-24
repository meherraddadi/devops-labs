# Crossplane — Infrastructure as Code K8s-native

## C'est quoi ?

Crossplane transforme ton cluster Kubernetes en **control plane universel** pour provisionner des ressources cloud (Azure, AWS, GCP) via des CRDs K8s. Tu décris une base de données Azure SQL ou un AKS cluster dans un fichier YAML K8s — Crossplane le crée dans Azure.

## Type d'installation

Helm / K8s (Glasskube disponible)

## Démarrage

```bash
# S'assurer d'être sur k3d
kubectl config use-context k3d-devops-lab

# Installer Crossplane via Helm
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace

# Vérifier l'installation
kubectl get pods -n crossplane-system
```

## Installer le provider Azure

```bash
# Installer le provider Azure
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-azure
spec:
  package: xpkg.upbound.io/upbound/provider-azure:latest
EOF

# Attendre que le provider soit ready
kubectl get providers
```

## Configurer les credentials Azure

```bash
# Créer un service principal Azure
az ad sp create-for-rbac \
  --name crossplane-sp \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth > azure-creds.json

# Créer le secret K8s
kubectl create secret generic azure-secret \
  -n crossplane-system \
  --from-file=creds=./azure-creds.json

# Référencer dans une ProviderConfig
kubectl apply -f manifests/provider-config.yaml
```

## Utilisation

```bash
# Lister les CRDs disponibles après installation du provider
kubectl get crds | grep azure

# Créer un Resource Group Azure depuis K8s
kubectl apply -f manifests/resource-group.yaml

# Voir l'état des ressources gérées
kubectl get managed
```
