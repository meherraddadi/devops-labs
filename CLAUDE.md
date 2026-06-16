# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexte

Dépôt de lab pour évaluer des outils DevOps 2026 en local, sur WSL2 + Docker + k3d. Chaque outil est isolé dans `tools/<nom>/` avec son propre README. Documentation complète dans le vault Obsidian (`docs/`).

## Commandes clés

### Cluster k3d
```bash
# Créer le cluster
k3d cluster create devops-lab --config k3d/clusters/devops-lab.yaml

# Bootstrap complet (vérifie les prérequis + crée le cluster)
bash scripts/setup.sh

# Basculer sur le cluster local
kubectl config use-context k3d-devops-lab

# Supprimer le cluster
k3d cluster delete devops-lab
```

### Démarrer un outil Docker Compose
```bash
cd tools/<nom>
docker compose up -d
docker compose down
docker compose logs -f
```

### Déployer un outil Kubernetes (Helm)
```bash
helm repo add <repo> <url>
helm install <nom> <chart> -f tools/<nom>/values.yaml -n <namespace> --create-namespace
```

## Architecture

### Deux modes de déploiement

| Mode | Outils | Commande |
|---|---|---|
| **Docker Compose** | Coroot, VictoriaMetrics, Perses, OpenTelemetry (Collector + Jaeger), Ollama, Headroom | `docker compose up -d` |
| **Helm / K8s** | Crossplane, Karpenter, Trivy Operator, Falco, Robusta, k8sgpt, Glasskube | `helm install` + `kubectl apply` |
| **CLI seul** | Mirrord, k8sgpt CLI, Headroom CLI | binaire ou `pip install` |

### Outils par catégorie

- **Infrastructure** : `k3d/` (cluster), `tools/crossplane/` (IaC CRDs Azure), `tools/karpenter/` (autoscaling nœuds)
- **Observabilité** : `tools/coroot/` (APM eBPF zero-instrumentation), `tools/victoria-metrics/` (métriques Prometheus-compatible + Grafana), `tools/opentelemetry/` (traces+logs OTLP), `tools/perses/` (dashboards-as-code)
- **Sécurité** : `tools/trivy-operator/` (CVE scanning continu), `tools/falco/` (détection syscall eBPF), `tools/robusta/` (alertes enrichies K8s)
- **Productivité / IA** : `tools/ollama/` (LLMs locaux + Open WebUI), `tools/k8sgpt/` (diagnostic LLM), `tools/glasskube/` (package manager K8s), `tools/mirrord/` (dev local → cluster), `tools/headroom/` (compression contexte LLM)

### URLs des services actifs

| Service | URL | Note |
|---|---|---|
| Grafana | http://localhost:3000 | admin/admin |
| Open WebUI (Ollama) | http://localhost:3001 | |
| Coroot | http://localhost:8080 | **Conflit port avec Perses** |
| Perses | http://localhost:8080 | Ne pas démarrer en même temps que Coroot |
| VictoriaMetrics | http://localhost:8428/vmui | |
| Jaeger | http://localhost:16686 | |
| Glasskube UI | http://localhost:8580 | via K8s port-forward |
| Headroom proxy | http://localhost:8787 | |

### Fichiers de config importants

- `k3d/clusters/devops-lab.yaml` — config cluster (1 server + 1 agent, Traefik désactivé, ports 8080/8443)
- `tools/victoria-metrics/scrape.yml` — cibles Prometheus
- `tools/opentelemetry/otel-config.yaml` — pipeline OTLP (receivers / exporters)
- `tools/crossplane/manifests/provider-config.yaml` — credentials Azure pour Crossplane

## Points critiques

- **Conflit port 8080** : Coroot et Perses utilisent le même port — ne jamais les démarrer simultanément
- **Coroot nécessite le mode privileged** : le docker-compose.yml doit avoir `privileged: true` pour eBPF
- **Falco nécessite eBPF ou module kernel** : vérifie la compatibilité WSL2 avant de déployer
- **Karpenter / NAP** : conçu pour AKS (Node Auto Provisioning), pas fonctionnel sur k3d local — lab de lecture/étude uniquement
- **Crossplane** : le `provider-config.yaml` attend des secrets Azure en base64 — ne jamais committer de credentials
- **Mirrord** : nécessite un cluster K8s accessible ET un process local à rediriger, pas de manifest K8s autonome

## Ajouter un nouvel outil

Pattern standard (voir `docs/05-runbooks/ajouter-un-outil.md`) :
```
tools/<nom>/
├── README.md           # Présentation, use case, commandes
├── docker-compose.yml  # Si mode Docker Compose
├── manifests/          # Si manifests K8s bruts
└── values.yaml         # Si Helm
```

La documentation Obsidian est dans `docs/` — ajouter une note dans la catégorie correspondante et mettre à jour `docs/README.md`.
