# Glasskube — Package Manager K8s moderne

## C'est quoi ?

Glasskube est un gestionnaire de paquets pour Kubernetes avec une **UI web propre** et une CLI moderne. C'est l'équivalent d'un `apt` ou `brew` pour K8s — installe, met à jour et gère les dépendances entre outils K8s en un clic.

## Le problème qu'il résout

Installer des outils K8s aujourd'hui :
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set grafana.enabled=true \
  --set alertmanager.enabled=true
# ... 50 valeurs à configurer
```

Avec Glasskube :
```bash
glasskube install kube-prometheus-stack
# ou depuis l'UI : clic → Install
```

## Pré-requis

- Cluster k3d démarré
- kubectl configuré

## Installation CLI

```bash
# Linux / WSL2
curl -LO https://github.com/glasskube/glasskube/releases/latest/download/glasskube_linux_amd64.tar.gz
tar -xzf glasskube_linux_amd64.tar.gz
sudo mv glasskube /usr/local/bin/
glasskube version
```

## Bootstrap dans le cluster

```bash
# Installe le controller Glasskube dans k3d
glasskube bootstrap

# Ouvrir l'UI web
glasskube serve
# → http://localhost:8580
```

## Utilisation

```bash
# Lister les paquets disponibles
glasskube repo list

# Installer un paquet
glasskube install cert-manager
glasskube install kube-prometheus-stack
glasskube install argo-cd

# Voir ce qui est installé
glasskube list

# Mettre à jour un paquet
glasskube update cert-manager

# Désinstaller
glasskube uninstall cert-manager
```

## Catalogue de paquets disponibles

- cert-manager
- argo-cd
- kube-prometheus-stack
- ingress-nginx
- external-secrets
- velero
- trivy-operator
- falco
- Et bien d'autres...

## Cas d'usage idéal

Bootstrapper rapidement un nouveau cluster avec tous les outils nécessaires en une seule commande, reproductible d'un cluster à l'autre.
