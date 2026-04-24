# Falco — Détection runtime d'anomalies

## C'est quoi ?

Falco surveille en temps réel ce qui se passe **à l'intérieur** de tes containers en production. Il intercepte les appels système (syscalls) via eBPF et déclenche des alertes quand un comportement suspect est détecté.

## Ce que Falco détecte

- Un shell ouvert dans un container (`kubectl exec ... bash`)
- Un fichier système sensible lu (`/etc/shadow`, `/etc/kubernetes/`)
- Une connexion réseau inattendue depuis un pod
- Un binaire exécuté qui n'était pas dans l'image originale
- Une élévation de privilèges

## Utilité concrète

Si quelqu'un compromet un de tes pods et tente de lire des secrets ou d'installer des outils, Falco le détecte immédiatement et alerte.

## Pré-requis

- Cluster k3d démarré
- kubectl configuré

## Installation

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --set driver.kind=ebpf \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true \
  --set falcosidekick.webui.service.type=NodePort
```

## Accès à l'UI

```bash
kubectl port-forward svc/falco-falcosidekick-ui 2802:2802 -n falco
# ouvre http://localhost:2802
```

## Voir les alertes en temps réel

```bash
kubectl logs -l app.kubernetes.io/name=falco -n falco -f
```

## Tester Falco

```bash
# Dans un autre terminal, ouvrir un shell dans un pod
kubectl run test --image=ubuntu --restart=Never -it -- bash

# Falco doit alerter :
# Warning Spawned a shell inside a container
#   container=test image=ubuntu shell=bash
```

## Règles personnalisées

Falco utilise des règles YAML. Exemple pour alerter sur l'accès à un secret K8s :

```yaml
- rule: Read Kubernetes Secret
  desc: Detect access to Kubernetes secrets
  condition: >
    open_read and container and
    fd.name startswith /var/run/secrets/kubernetes.io
  output: >
    Kubernetes secret read (user=%user.name file=%fd.name
    container=%container.name image=%container.image.repository)
  priority: WARNING
```
