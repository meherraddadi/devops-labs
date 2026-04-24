# Karpenter — Autoscaling de nœuds K8s

## C'est quoi ?

Karpenter est un autoscaler de **nœuds** Kubernetes (pas de pods). Quand un pod est `Pending` faute de ressources, Karpenter provisionne le nœud optimal en 30-60 secondes. Il est plus intelligent et rapide que Cluster Autoscaler : il choisit le bon type de VM, consolide les nœuds sous-utilisés, et gère les interruptions Spot.

## Type d'installation

Helm / K8s (AKS avec Node Autoprovision)

## Contexte AKS

Azure intègre Karpenter via **Node Auto Provisioning (NAP)** sur AKS. NAP est la solution recommandée pour AKS — elle gère Karpenter en backend automatiquement.

```bash
# Activer NAP sur un cluster AKS existant
az aks update \
  --name <nom-cluster> \
  --resource-group <rg> \
  --node-provisioning-mode Auto

# Vérifier
kubectl get nodepools.karpenter.azure.com
```

## Installation Karpenter standalone (non-AKS)

```bash
# Pour k3d / vanilla K8s — mode simulation
helm repo add karpenter https://charts.karpenter.sh/
helm repo update

# Note: Karpenter a besoin d'un cloud provider.
# Sur k3d local, installation possible mais sans provisionnement réel.
helm install karpenter karpenter/karpenter \
  --namespace kube-system \
  --set controller.clusterName=devops-lab \
  --set controller.clusterEndpoint=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
```

## Configurer un NodePool

```yaml
# manifests/nodepool.yaml
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot", "on-demand"]
      nodeClassRef:
        apiVersion: karpenter.azure.com/v1alpha2
        kind: AKSNodeClass
        name: default
  limits:
    cpu: 100
    memory: 400Gi
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 30s
```

## Utilisation

```bash
# Voir les nœuds gérés par Karpenter
kubectl get nodes -l karpenter.sh/registered=true

# Voir les NodeClaims (instances provisionnées)
kubectl get nodeclaims

# Forcer la consolidation (supprime les nœuds vides)
kubectl annotate nodepool default karpenter.sh/voluntary-disruption=true
```
