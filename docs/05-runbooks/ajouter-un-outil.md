---
title: Ajouter un nouvel outil au lab
tags: [runbook, contribution, outil]
status: ready
---

# Ajouter un nouvel outil au lab

## Checklist

```
[ ] 1. Créer le dossier tools/<nom-outil>/
[ ] 2. Créer tools/<nom-outil>/README.md (accès rapide)
[ ] 3. Créer docker-compose.yml OU manifests K8s selon le type
[ ] 4. Créer docs/<section>/<nom-outil>.md (doc Obsidian complète)
[ ] 5. Ajouter le lien dans docs/<section>/_index.md
[ ] 6. Ajouter dans le README.md racine
[ ] 7. Commit + push
```

## Structure minimale README.md (tools/)

```markdown
# <Nom Outil> — <Description courte>

## C'est quoi ?
...

## Type d'installation
Docker Compose / K8s Helm / CLI binaire

## Démarrage
\`\`\`bash
...
\`\`\`

## Utilisation
...
```

## Structure minimale doc Obsidian (docs/)

```markdown
---
title: Nom Outil — Description courte
tags: [categorie, tags]
status: draft
---

# Nom Outil

## C'est quoi ?

## Architecture
\`\`\`mermaid
...
\`\`\`

## Démarrage

## Utilisation

## Liens
- [[section/_index|← Retour Section]]
```

## Décider la section

| L'outil fait quoi ? | Section |
|---|---|
| Infrastructure / cluster / réseau | [[01-infrastructure/_index\|01-infrastructure]] |
| Métriques / logs / traces / dashboards | [[02-observabilite/_index\|02-observabilite]] |
| Scan CVE / détection / alerting | [[03-securite/_index\|03-securite]] |
| Améliore l'expérience K8s | [[04-outils/_index\|04-outils]] |

## Décider le type d'installation

**Docker Compose** si l'outil :
- Peut tourner sans K8s
- A sa propre UI web
- Est un service standalone (base de données, monitoring, etc.)

**Helm/K8s** si l'outil :
- Est un operator K8s
- Tourne en DaemonSet
- A besoin d'accéder à l'API K8s

## Commit et push

```bash
cd ~/dev/devops-labs
git add -A
git commit -m "feat(tools): add <nom-outil> — <description courte>"
git push
```
