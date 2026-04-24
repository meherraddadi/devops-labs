#!/bin/bash
# Setup complet de l'environnement DevOps Lab
# Usage : bash scripts/setup.sh

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

# 1. Vérifier les pré-requis
info "Vérification des pré-requis..."
for cmd in docker kubectl helm git; do
    if ! command -v "$cmd" &>/dev/null; then
        warn "$cmd non trouvé — installe-le avant de continuer"
        exit 1
    fi
done
info "Pré-requis OK"

# 2. Installer k3d si absent
if ! command -v k3d &>/dev/null; then
    info "Installation de k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    info "k3d déjà installé : $(k3d version | head -1)"
fi

# 3. Créer le cluster si absent
if ! k3d cluster list | grep -q "devops-lab"; then
    info "Création du cluster k3d devops-lab..."
    k3d cluster create devops-lab --config "$(dirname "$0")/../k3d/clusters/devops-lab.yaml"
else
    info "Cluster devops-lab déjà existant"
    k3d cluster start devops-lab 2>/dev/null || true
fi

# 4. Vérifier le cluster
info "Vérification du cluster..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s
kubectl get nodes

info ""
info "Setup terminé ! Prochaines étapes :"
info "  → k8sgpt  : voir tools/k8sgpt/README.md"
info "  → coroot  : cd tools/coroot && docker compose up -d"
info "  → victoria: cd tools/victoria-metrics && docker compose up -d"
info "  → perses  : cd tools/perses && docker compose up -d"
