# Headroom — Compression de contexte pour agents IA

## C'est quoi ?

**Headroom** est un projet open source créé par Tejas Chopra (ingénieur Netflix) qui compresse tout ce qu'un agent IA lit — outputs d'outils, logs, chunks RAG, fichiers, historique de conversation — **avant** que ça atteigne le LLM. Même réponses, beaucoup moins de tokens.

- Repo : https://github.com/chopratejas/headroom
- Docs : https://headroom-docs.vercel.app/docs
- Licence : Apache 2.0

## Pourquoi c'est intéressant pour nous

On a déjà un RAG Qdrant (`~/dev/devops-rag`) qui réduit les tokens par **sélection** (on n'injecte que les chunks pertinents). Headroom vient en complément : il réduit les tokens par **compression** de ce qui est effectivement envoyé.

| Ce qu'on a | Technique | Gain |
|---|---|---|
| RAG Qdrant (`devops-rag`) | Sélection — n'injecter que le nécessaire | 90–99% sur le contexte connaissance |
| **Headroom** (ce lab) | Compression — réduire ce qui est envoyé | 50–95% sur logs, JSON, outputs MCP |

### Savings annoncés sur des workloads réels

| Workload | Avant | Après | Économie |
|---|---:|---:|---:|
| Code search (100 résultats) | 17 765 | 1 408 | **92%** |
| Debugging incident SRE | 65 694 | 5 118 | **92%** |
| Triage issues GitHub | 54 174 | 14 761 | **73%** |
| Exploration codebase | 78 502 | 41 254 | **47%** |

### Cas d'usage directs chez YZY

- Outputs `kubectl describe/logs` (très verbeux) collés dans la conversation
- Réponses JSON des tools MCP (ClickUp, `qdrant-find`, Grafana API)
- Logs Loki/Azure passés en contexte pour debug
- Scripts Python qui appellent l'API Anthropic directement

## Architecture

```
 Claude Code CLI / scripts Python / apps
        │   prompts · tool outputs · logs · RAG chunks
        ▼
    ┌─────────────────────────────────────────┐
    │  Headroom  (tourne localement)          │
    │  CacheAligner → ContentRouter → CCR     │
    │    ├─ SmartCrusher    (JSON)            │
    │    ├─ CodeCompressor  (AST)             │
    │    └─ Kompress-base   (texte, HF model) │
    └─────────────────────────────────────────┘
        │   prompt compressé + retrieval tool
        ▼
 API Anthropic / OpenAI
```

**4 modes d'utilisation :**

| Mode | Commande | Cas d'usage |
|---|---|---|
| **Agent wrap** | `headroom wrap claude` | Wraper Claude Code CLI directement |
| **Proxy** | `headroom proxy --port 8787` | Drop-in pour n'importe quelle app |
| **Library** | `compress(messages)` | Intégration Python/TS dans les scripts |
| **MCP server** | `headroom mcp install` | Tools MCP dans Claude Code |

---

## Plan du lab

### Phase 1 — Installation et premier test avec Claude Code

**Objectif** : tester `headroom wrap claude` et voir les stats en temps réel.

```bash
# Installer Headroom (Python 3.10+ requis)
pip install "headroom-ai[all]"

# Vérifier l'installation
headroom --version

# Wrapper Claude Code — le plus simple pour commencer
headroom wrap claude

# Dans une autre session, voir les stats
headroom perf
```

**Ce qu'on observe** :
- Headroom intercepte les appels de Claude Code vers `api.anthropic.com`
- Il compresse les tool outputs et outputs MCP avant envoi
- `headroom perf` affiche tokens avant/après en temps réel

---

### Phase 2 — Mesurer les économies sur nos vrais workloads

**Objectif** : quantifier les gains sur des données réelles YZY.

```bash
# Préparer des jeux de test réels
# 1. Output kubectl
kubectl describe node -A > /tmp/test-kubectl.txt
kubectl get pods -A -o json > /tmp/test-pods.json

# 2. Output MCP qdrant-find (copier un vrai résultat de conversation)
# 3. Réponse API Grafana / Azure (json typique)

# Tester la compression en Python
python3 - <<'EOF'
from headroom import compress

# Charger un fichier de test
with open("/tmp/test-pods.json") as f:
    content = f.read()

messages = [{"role": "user", "content": content}]
result = compress(messages, model="claude-sonnet-4-6")

original = len(content)
compressed = len(str(result))
print(f"Original  : {original:,} chars")
print(f"Compressé : {compressed:,} chars")
print(f"Économie  : {(1 - compressed/original)*100:.1f}%")
EOF
```

**Métriques à relever** :
- [ ] Compression kubectl output (texte brut)
- [ ] Compression pods JSON (JSON structuré)
- [ ] Compression output `qdrant-find` (chunks Markdown)
- [ ] Compression réponse ClickUp task JSON

---

### Phase 3 — Mode MCP dans Claude Code

**Objectif** : installer Headroom comme MCP server pour compresser automatiquement tous les outputs MCP.

```bash
# Installer le MCP server Headroom dans Claude Code
headroom mcp install

# Vérifier dans la config MCP
cat ~/.claude/settings.json | grep headroom
```

**Tools MCP disponibles après installation** :
- `headroom_compress` — compresse manuellement un contenu
- `headroom_retrieve` — récupère l'original compressé (CCR)
- `headroom_stats` — stats de compression de la session

**Test** : dans une conversation Claude Code, demander à comprimer un output kubectl avant de l'analyser.

---

### Phase 4 — Mode proxy pour les scripts Python

**Objectif** : zéro modification de code — juste pointer `ANTHROPIC_BASE_URL` vers Headroom.

```bash
# Démarrer le proxy en arrière-plan
headroom proxy --port 8787 &

# Utiliser dans un script Python existant
ANTHROPIC_BASE_URL=http://localhost:8787 python3 mon-script.py

# Ou via Docker Compose (voir docker-compose.yml de ce dossier)
docker compose up -d
```

**Intégration SDK Python** (si on veut l'intégrer proprement dans un script) :

```python
import anthropic
from headroom.integrations.anthropic import withHeadroom

client = withHeadroom(anthropic.Anthropic())
# Ensuite utilisation normale du client
```

---

### Phase 5 — `headroom learn` (bonus)

**Objectif** : miner les sessions échouées pour enrichir automatiquement `CLAUDE.md`.

```bash
# Analyser les sessions Claude Code récentes
headroom learn

# Affiche les corrections suggérées → à valider avant d'appliquer à CLAUDE.md
```

---

## Type d'installation

Docker Compose (proxy) + pip (CLI/library)

## Démarrage rapide

```bash
cd ~/dev/devops-labs/tools/headroom

# Option A — proxy Docker
docker compose up -d
export ANTHROPIC_BASE_URL=http://localhost:8787

# Option B — wrapper direct Claude Code
pip install "headroom-ai[all]"
headroom wrap claude
```

## URLs

| Service | URL |
|---|---|
| Proxy Headroom | http://localhost:8787 |
| Stats dashboard | `headroom perf` (CLI) |

## Liens utiles

- [Quickstart](https://headroom-docs.vercel.app/docs/quickstart)
- [Architecture](https://headroom-docs.vercel.app/docs/architecture)
- [CCR — compression réversible](https://headroom-docs.vercel.app/docs/ccr)
- [Cache optimization](https://headroom-docs.vercel.app/docs/cache-optimization)
- [MCP tools](https://headroom-docs.vercel.app/docs/mcp)
- [Benchmarks](https://headroom-docs.vercel.app/docs/benchmarks)

## Contexte

- Complémentaire à `~/dev/devops-rag` (RAG Qdrant) — les deux ensemble = réduction maximale
- Auteur : Tejas Chopra (Netflix) — article Le Monde Informatique 2026-06-05
- Lab ouvert — à traiter par sessions quand on a le temps
