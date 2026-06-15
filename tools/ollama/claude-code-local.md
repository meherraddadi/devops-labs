# Claude Code CLI — Mode 100% local et gratuit (Ollama)

Guide d'installation pour utiliser Claude Code CLI sans compte Anthropic ni frais, en pointant sur un LLM local via Ollama.

**Machine cible** : ThinkPad T14 Gen 3 AMD (Ryzen 7 Pro 6850U, 32 GB DDR5, iGPU Radeon 680M — pas de GPU dédié)

## Pourquoi natif plutôt que Docker pour ce cas d'usage

Le `docker-compose.yml` de ce lab est pratique pour tester Open WebUI. Mais pour utiliser Ollama comme backend permanent de Claude Code, l'installation **native** est préférable :

- Moins de latence (pas de couche réseau Docker)
- Détection automatique du CPU/iGPU AMD Radeon
- Service systemd stable au démarrage
- Accès direct depuis WSL2 sans bridge réseau

---

## Installation

### 1. Installer Ollama (natif WSL2)

```bash
curl -fsSL https://ollama.com/install.sh | sh

# Vérifier
ollama --version
curl http://localhost:11434/api/version
```

L'installeur configure automatiquement un service systemd. Ollama démarre au boot de WSL2.

### 2. Télécharger un modèle optimisé pour le code

Choix du modèle selon le T14 (32 GB DDR5, CPU-only en pratique) :

| Modèle | Taille disque | RAM utilisée | Qualité code | Vitesse T14 |
|---|---|---|---|---|
| `qwen2.5-coder:7b` | 4.7 GB | ~6 GB | ★★★★☆ | ~15 tok/s — **recommandé** |
| `qwen2.5-coder:14b` | 9 GB | ~12 GB | ★★★★★ | ~7 tok/s — excellent si patient |
| `deepseek-coder-v2:16b` | 9.1 GB | ~12 GB | ★★★★★ | ~6 tok/s — meilleur pour raisonnement |
| `gemma3:12b` | 7.3 GB | ~10 GB | ★★★★☆ | ~8 tok/s — bon généraliste |
| `codellama:7b` | 3.8 GB | ~5 GB | ★★★☆☆ | ~20 tok/s — dépannage rapide |

```bash
# Commencer par celui-ci
ollama pull qwen2.5-coder:7b

# Tester
ollama run qwen2.5-coder:7b "Écris un Dockerfile Python minimal"
```

### 3. Installer Claude Code CLI

```bash
npm install -g @anthropic-ai/claude-code

# Vérifier
claude --version
```

### 4. Configurer les variables d'environnement

```bash
# Ajouter dans ~/.zshrc
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_BASE_URL=http://localhost:11434

# Recharger
source ~/.zshrc
```

### 5. Lancer Claude Code en mode local

```bash
# Avec le modèle par défaut configuré dans Ollama
claude

# Ou spécifier explicitement le modèle
claude --model qwen2.5-coder:7b
```

---

## Vérification que tout fonctionne

```bash
# 1. Ollama répond
curl -s http://localhost:11434/api/version

# 2. Le modèle est bien chargé
ollama list

# 3. Claude Code voit le backend local
claude --model qwen2.5-coder:7b --print "dis bonjour en une phrase"
```

---

## Utilisation quotidienne

```bash
# Démarrer une session Claude Code locale
claude

# Claude Code se comporte normalement — lecture/écriture fichiers,
# commandes bash, etc. — mais l'inférence se fait sur ton CPU local.
```

Claude Code avec Ollama supporte tous les outils habituels :
- Lecture/écriture de fichiers
- Exécution de commandes bash
- Recherche dans le code
- Git operations

Ce qui ne fonctionne **pas** avec les modèles locaux :
- Extended thinking (fonctionnalité Anthropic uniquement)
- Qualité équivalente sur le code très complexe / multi-fichiers
- Fenêtre de contexte aussi grande (32K–128K vs 200K pour Claude)

---

## Option LiteLLM — basculer entre local et API Anthropic

Si tu veux garder la possibilité de basculer vers l'API Anthropic (pour les tâches complexes) sans changer ta config Claude Code :

```bash
pip install litellm

# Démarrer LiteLLM avec Ollama comme backend
litellm --model ollama/qwen2.5-coder:7b --port 4000
```

```bash
# Dans ~/.zshrc — pointer vers LiteLLM au lieu d'Ollama directement
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_AUTH_TOKEN=local

# Pour basculer sur l'API Anthropic réelle :
# export ANTHROPIC_API_KEY=sk-ant-...
# export ANTHROPIC_BASE_URL=  (vider)
```

---

## Intégration avec devops-rag (Qdrant MCP)

### Pourquoi ça fonctionne

Le MCP (Model Context Protocol) est géré par **Claude Code CLI lui-même**, pas par l'API Anthropic. Quand tu passes sur Ollama, le CLI reste identique — il continue à appeler `qdrant-find`, exécuter la recherche dans Qdrant, et injecter les chunks dans le contexte. Seul le LLM final change.

```
Conversation
    │
    ├─ Claude Code CLI  ←── identique, backend LLM transparent
    │       │
    │       ├─ MCP qdrant-find → Qdrant local → 3–5 chunks pertinents
    │       │
    │       └─ LLM → Ollama (qwen2.5-coder:7b) — local, gratuit
    │
    └─ Réponse
```

### Le RAG est encore PLUS précieux avec un modèle local

Avec l'API Anthropic, le RAG est un confort. Avec Ollama, il devient **critique** :

| Contrainte des modèles locaux | Sans RAG | Avec RAG |
|---|---|---|
| **Fenêtre de contexte courte** (32K vs 200K) | Contexte trop grand → troncature → hallucinations | 3–5 chunks ciblés → tient dans la fenêtre |
| **Lenteur CPU** (~15 tok/s) | Beaucoup de tokens = très lent | Moins de tokens = réponse 2–3× plus rapide |
| **Qualité moindre** des petits modèles | Se perd dans un grand contexte | Contexte ciblé = meilleure précision |

### Setup MCP Qdrant sur le T14

```bash
# 1. Installer uv (fournit uvx, nécessaire pour mcp-server-qdrant)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Créer ~/.claude/mcp.json
mkdir -p ~/.claude
cat > ~/.claude/mcp.json << 'EOF'
{
  "mcpServers": {
    "devops-knowledge": {
      "command": "uvx",
      "args": ["mcp-server-qdrant"],
      "env": {
        "QDRANT_URL": "http://localhost:6333",
        "COLLECTION_NAME": "yzy-devops",
        "EMBEDDING_MODEL": "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
      }
    }
  }
}
EOF

# 3. Démarrer Qdrant et indexer (voir ~/dev/devops-rag/README.md)
cd ~/dev/devops-rag
docker compose up -d
python3 index_docs.py
```

### Variable d'environnement FastEmbed (obligatoire sur WSL)

```bash
# Ajouter dans ~/.zshrc — évite le retéléchargement du modèle à chaque reboot
export FASTEMBED_CACHE_PATH="$HOME/.cache/fastembed"
mkdir -p ~/.cache/fastembed
```

### Nuance : fiabilité du tool calling selon le modèle

Les modèles locaux supportent le tool use mais **moins fiablement** que Claude. Le modèle peut parfois ne pas appeler `qdrant-find` de lui-même.

| Modèle | Tool calling | Comportement |
|---|---|---|
| `qwen2.5-coder:7b` | ★★★☆☆ | Appelle les outils sur demande explicite, parfois oublie |
| `qwen2.5-coder:14b` | ★★★★☆ | Fiable dans la plupart des cas |
| `deepseek-coder-v2:16b` | ★★★★★ | Le plus fiable pour le tool use |

**Contournement** : demander explicitement dans le prompt :

```
"Cherche dans la base de connaissance YZY les infos sur le cluster VTL
avant de répondre."
```

Cette formulation explicite déclenche systématiquement `qdrant-find`, même sur les modèles 7B.

---

## Troubleshooting

### `Error: connection refused` sur localhost:11434

```bash
# Vérifier qu'Ollama tourne
systemctl status ollama
# ou
ollama serve   # démarrer manuellement
```

### Réponses très lentes

Normale sur CPU-only. Pour améliorer :
```bash
# Réduire le nombre de layers en RAM (si <32 GB dispo)
OLLAMA_NUM_PARALLEL=1 ollama serve

# Vérifier que rien d'autre ne consomme la RAM
free -h
```

### Claude Code répond en anglais / comportement inattendu

Les modèles locaux ne respectent pas toujours les instructions système de Claude Code. Ajouter dans le `CLAUDE.md` du projet :
```
Always respond in French.
```

### Le modèle ne répond pas aux outils (tool use)

Certains modèles gèrent mal le tool use d'Anthropic. Si ça ne marche pas avec `qwen2.5-coder:7b`, essayer `qwen2.5-coder:14b` ou `deepseek-coder-v2:16b` qui ont de meilleures capacités d'instruction following.
