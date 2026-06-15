# Ollama + Open WebUI — LLMs locaux

## C'est quoi ?

**Ollama** fait tourner des LLMs (Llama 3, Mistral, Phi-3, Gemma...) en local sur ta machine, sans cloud. **Open WebUI** est une interface ChatGPT-like qui se connecte à Ollama.

## Type d'installation

Docker Compose

## Démarrage

```bash
cd ~/dev/devops-labs/tools/ollama
docker compose up -d

# Vérifier que Ollama est prêt
curl http://localhost:11434/api/version

# Télécharger un modèle (ex: Llama 3.2 3B — léger et rapide)
docker exec ollama ollama pull llama3.2

# Open WebUI → http://localhost:3001
```

## Modèles recommandés

| Modèle | Taille | RAM requise | Usage |
|---|---|---|---|
| `llama3.2` | 2.0 GB | 4 GB | Général, rapide |
| `mistral` | 4.1 GB | 8 GB | Raisonnement |
| `qwen2.5-coder:7b` | 4.7 GB | 6 GB | **Code — meilleur rapport qualité/vitesse** |
| `qwen2.5-coder:14b` | 9 GB | 12 GB | Code — haute qualité |
| `deepseek-coder-v2:16b` | 9.1 GB | 12 GB | Code — raisonnement complexe |
| `gemma3:12b` | 7.3 GB | 10 GB | Généraliste moderne |
| `phi3` | 2.2 GB | 4 GB | Léger, efficace |
| `nomic-embed-text` | 274 MB | 1 GB | Embeddings RAG |

## Utilisation CLI

```bash
# Chat interactif
docker exec -it ollama ollama run llama3.2

# Via API REST
curl http://localhost:11434/api/generate \
  -d '{"model": "llama3.2", "prompt": "Explique eBPF en une phrase", "stream": false}'

# Lister les modèles installés
docker exec ollama ollama list
```

## URLs

- Open WebUI : http://localhost:3001
- Ollama API : http://localhost:11434

## Cas d'usage avancé

- [Claude Code CLI en mode local gratuit](claude-code-local.md) — utiliser Claude Code sans compte Anthropic, avec un LLM local via Ollama
