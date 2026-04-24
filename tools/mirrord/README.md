# Mirrord — Dev local connecté au cluster K8s

## C'est quoi ?

Mirrord intercepte les appels réseau, fichiers et variables d'environnement de ton process local et les **redirige vers un pod K8s distant**. Tu codes en local avec `go run` ou `python app.py` mais ton process "voit" le réseau et l'environnement du cluster distant.

**Avant mirrord** : `docker build` → push → deploy → test → repeat (5-10 min par cycle)
**Avec mirrord** : `mirrord exec -- python app.py` et tu es "dans" le cluster (< 1s)

## Type d'installation

CLI binaire (+ extension VS Code disponible)

## Installation

```bash
# Via script officiel
curl -fsSL https://raw.githubusercontent.com/metalbear-co/mirrord/main/scripts/install.sh | bash

# Vérifier
mirrord --version

# Extension VS Code (optionnel)
code --install-extension metalbear.mirrord
```

## Démarrage

```bash
# Lancer ton app locale "dans" le cluster
# mirrord va intercepter le trafic du pod cible
mirrord exec \
  --target pod/<nom-du-pod> \
  --target-namespace <namespace> \
  -- python app.py

# Exemple avec un pod spécifique
mirrord exec \
  --target deployment/mon-api \
  --target-namespace production \
  -- python -m uvicorn main:app --port 8000
```

## Configuration (mirrord.toml)

```toml
[target]
path = "deployment/mon-api"
namespace = "production"

[feature.network]
incoming = "mirror"   # mirror (copie) ou steal (redirige)
outgoing = true

[feature.env]
include = ["DATABASE_URL", "REDIS_URL", "SECRET_KEY"]

[feature.fs]
mode = "local"  # fichiers restent locaux
```

## Utilisation

```bash
# Mode mirror — copie le trafic entrant (prod safe)
mirrord exec --target pod/mon-pod -- python app.py

# Mode steal — redirige le trafic vers toi (pour dev/staging)
mirrord exec --steal --target pod/mon-pod -- python app.py

# Voir les logs de mirrord
MIRRORD_LOG=debug mirrord exec --target pod/mon-pod -- python app.py
```
