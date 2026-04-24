# k3d — Cluster Kubernetes local

## C'est quoi ?

k3d lance **k3s** (Kubernetes allégé par Rancher) à l'intérieur de containers Docker. Résultat : un vrai cluster Kubernetes qui démarre en 20 secondes, sans VM, sans overhead.

Comparaison rapide :

| Solution | RAM utilisée | Temps démarrage | WSL2 |
|---|---|---|---|
| minikube | ~2 GB | ~2 min | Problématique |
| kind | ~500 MB | ~1 min | OK |
| **k3d** | ~300 MB | ~20 sec | Parfait |

## Pourquoi k3d et pas minikube ?

- Tourne dans Docker → pas de VM séparée
- Parfait sur WSL2
- Multi-cluster en une commande
- Idéal pour tester des outils K8s sans impacter les clusters de prod

## Installation

```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Vérifier
k3d version
```

## Créer le cluster de lab

```bash
k3d cluster create devops-lab --config clusters/devops-lab.yaml
```

## Commandes essentielles

```bash
# Lister les clusters
k3d cluster list

# Démarrer un cluster arrêté
k3d cluster start devops-lab

# Arrêter (sans supprimer)
k3d cluster stop devops-lab

# Supprimer
k3d cluster delete devops-lab

# Basculer le contexte kubectl
kubectl config use-context k3d-devops-lab
```

## Accès au cluster

Après création, k3d met à jour automatiquement ton `~/.kube/config` :

```bash
kubectl get nodes
# NAME                       STATUS   ROLES
# k3d-devops-lab-server-0    Ready    control-plane
```

## Réseau & ports

Le cluster expose les ports via le load balancer Docker :
- Port **8080** → ingress HTTP du cluster
- Port **8443** → ingress HTTPS du cluster

Pour accéder à un service depuis ton navigateur :
```bash
kubectl port-forward svc/mon-service 9090:9090
# puis ouvre http://localhost:9090
```
