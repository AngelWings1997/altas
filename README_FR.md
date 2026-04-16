# ALTAS Workflow

> **Fusion de trois avantages | Adaptation intelligente de la profondeur | Divulgation progressive | Retour à chaque étape**

**Version:** 4.0 (2026-04-16)  
**Taille du dépôt:** 8.3M, 169 fichiers Markdown, 79 documents de référence

---

## 🌐 Langue / Language

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | **Français** | [Deutsch](README_DE.md)

---

## 🎯 Qu'est-ce que c'est?

**ALTAS Workflow** est une spécification de workflow de développement AI-native complète qui intègre l'essence de trois excellents workflows: **SDD-RIPER**, **SDD-RIPER-Optimized (Checkpoint-Driven)**, et **Superpowers**.

### Mission principale

Dédié à résoudre quatre principaux points de douleur en ingénierie dans la programmation AI:

| Point de douleur | Solution ALTAS |
|------|-----------|
| **Dégradation du contexte** | Indexation CodeMap + divulgation progressive, chargement des documents de référence à la demande |
| **Paralysie de révision** | 4 niveaux de profondeur intelligente (XS/S/M/L), les petites tâches ne restent pas bloquées |
| **Méfiance du code** | Centralisation Spec + révision à trois axes, Spec is Truth |
| **Difficulté de maintenance** | Archivage des connaissances + loi de fer TDD, l'achèvement signifie actif |

### Lois de fer principales

1. **No Spec, No Code** — Pas de code avant de former le Spec minimum (Size XS exempté)
2. **No Approval, No Execute** — Jamais de code si l'humain ne hoche pas la tête en phase Plan
3. **Spec is Truth** — Quand Spec entre en conflit avec le code, le code a tort
4. **Reverse Sync** — Déviation trouvée en exécution → mettre à jour Spec d'abord → puis corriger le code
5. **Evidence First** — L'achèvement est prouvé par les résultats de vérification, pas par l'auto-déclaration du modèle
6. **No Root Cause, No Fix** — Analyse de cause racine requise avant correction de bug, corrections aveugles interdites
7. **TDD Iron Law** — Size M/L: Pas de code de production sans tests échoués
8. **Resume Ready** — Laisser une ancre de récupération dans Spec avant la pause de tâche longue

---

## 📦 Qu'est-ce qui est inclus?

### Aperçu de la structure du dépôt

```
altas/
├── altas-workflow/              # Répertoire principal du protocole (8.3M, 92 fichiers)
│   ├── SKILL.md                 # ⭐ Prompt système principal (AI lit)
│   ├── README.md                # Description détaillée ALTAS
│   ├── QUICKSTART.md            # Guide rapide basé sur les scénarios
│   ├── reference-index.md       # Index principal des documents de référence
│   ├── protocols/               # Protocoles spécialisés (3)
│   │   ├── RIPER-5.md           # Protocole mode strict
│   │   ├── RIPER-DOC.md         # Protocole expert documentation
│   │   └── SDD-RIPER-DUAL-COOP.md # Protocole collaboration double-modèle
│   ├── docs/                    # Documents méthodologiques (4)
│   │   ├── 从传统编程转向大模型编程.md
│   │   ├── AI-原生研发范式.md
│   │   ├── 团队落地指南.md
│   │   └── 手把手教程.md
│   ├── references/              # Documents de référence à la demande (79 fichiers)
│   │   ├── spec-driven-development/  # Développement piloté par Spec (7 documents principaux)
│   │   ├── checkpoint-driven/        # Mode léger Checkpoint (4 documents)
│   │   ├── superpowers/              # Super-pouvoirs (37 documents)
│   │   │   ├── test-driven-development/  # Loi de fer TDD
│   │   │   ├── systematic-debugging/     # Debug systématique
│   │   │   ├── subagent-driven-development/ # Piloté par Subagent
│   │   │   ├── brainstorming/            # Brainstorming de conception
│   │   │   ├── writing-plans/            # Meilleures pratiques d'écriture Plan
│   │   │   └── ... (plus de super-pouvoirs)
│   │   ├── agents/                       # Définitions Agent (22 documents)
│   │   │   ├── sdd-riper-one/            # Agent standard
│   │   │   └── sdd-riper-one-light/      # Agent léger
│   │   ├── entry/                        # Configuration d'entrée (4 documents)
│   │   └── special-modes/                # Modes spéciaux (5 documents)
│   └── scripts/                 # Outils d'automatisation
│       └── archive_builder.py   # Constructeur d'archive
├── .qoder/repowiki/             # Documents Wiki (69 documents)
├── AGENTS.md                    # Directives comportementales AI générales
├── CLAUDE.md                    # Directives comportementales AI générales
└── EXAMPLES.md                  # Exemples de code des quatre principes
```

### Statistiques des actifs principaux

| Catégorie | Quantité | Description |
|------|------|------|
| **Protocole principal** | 1 | SKILL.md (Protocole principal ALTAS Workflow) |
| **Protocoles spécialisés** | 3 | RIPER-5 / RIPER-DOC / DUAL-COOP |
| **Méthodologie** | 4 | Traditionnel vers LLM / Paradigme AI-native / Adoption équipe / Tutoriel pas à pas |
| **Documents de référence** | 79 | Piloté par Spec (7) / Checkpoint (4) / Superpowers (37) / Agents (22) / Entry (4) / Special-Modes (5) |
| **Agents indépendants** | 2 | SDD-RIPER-ONE (standard/léger) |
| **Exemples de code** | 1 | EXAMPLES.md (exemples pratiques des quatre principes) |
| **Outils d'automatisation** | 1 | archive_builder.py (Constructeur d'archive) |

---

## 🚀 Comment utiliser rapidement?

### Installation en 30 secondes

**Méthode 1**: Copier le contenu de `altas-workflow/SKILL.md` dans les Instructions Personnalisées de l'assistant AI

**Méthode 2**: Exécuter dans Cursor/Trae:
```bash
cp altas-workflow/SKILL.md .cursorrules
```

**Méthode 3**: Configuration du projet
```bash
mkdir -p mydocs/{codemap,context,specs,micro_specs,archive}
```

### Adaptation plateforme

| Plateforme | Méthode d'installation |
|------|----------|
| **Cursor / Trae** | Copier le contenu de `SKILL.md` dans `.cursorrules` ou Règles AI globales |
| **Claude / OpenAI Agent** | Injecter le contenu de `SKILL.md` comme Prompt Système |
| **Qoder** | Placer `SKILL.md` dans le répertoire `.qoder/skills/` du projet |

---

### Utilisation immédiate

**Modification extrêmement rapide (Size XS)**:
```
>> Changer MAX_RETRIES de 3 à 5 dans src/config.ts
```

**Petite tâche (Size S)**:
```
FAST: Ajouter un code de vérification d'image à l'interface de connexion
```

**Développement standard (Size M)**:
```
sdd_bootstrap: task=Ajouter une fonction anti-scraping à l'interface d'enregistrement utilisateur, goal=Amélioration de la sécurité
```

**Refactoring d'architecture (Size L)**:
```
DEEP: Refactorer le module d'authentification pour le diviser en microservices indépendants
```

**Investigation de bug**:
```
DEBUG: log_path=./logs/error.log, issue=Autorisation non obtenue après approbation
```

**Collaboration multi-projets**:
```
MULTI: task=Publication de fonctionnalité conjointe frontend-backend
```

---

## 📚 Commandes principales

### Aperçu des commandes

| Commande | Objectif | Taille applicable | Impact workflow |
|------|------|----------|----------|
| `>>` / `FAST` | Piste rapide, sauter Research/Plan | XS/S | Exécuter directement→vérifier→résumer |
| `sdd_bootstrap` | Démarrer workflow RIPER | M/L | Research→Plan→Execute→Review |
| `create_codemap` | Générer carte de code | M/L | Analyse en lecture seule, pas de modification de code |
| `MAP` / `PROJECT MAP` | Analyse de projet en lecture seule | Tous | Générer carte d'architecture |
| `DEBUG` | Mode debug système | - | Analyse de cause racine→rapport de diagnostic |
| `MULTI` | Collaboration multi-projets | L | Découverte automatique + isolation de portée |
| `ARCHIVE` | Archivage des connaissances | L | Version humaine + version LLM double perspective |
| `DOC` | Mode expert documentation | - | ABSORB→OUTLINE→AUTHOR→FACT-CHECK |
| `REVIEW SPEC` | Révision pré-exécution | M/L | Pré-révision consultative |
| `REVIEW EXECUTE` | Révision post-exécution à trois axes | M/L | Révision à trois axes Spec/code/qualité |

### Référence rapide des mots déclencheurs

| Mot déclencheur | Action | Taille |
|--------|------|------|
| `FAST` / `快速` / `>>` | Piste extrêmement rapide | XS/S |
| `DEEP` | Mode profond | L |
| `MAP` / `链路梳理` | CodeMap niveau fonctionnalité | - |
| `PROJECT MAP` / `项目总图` | CodeMap niveau projet | - |
| `MULTI` / `多项目` | Mode multi-projets | L |
| `CROSS` / `跨项目` | Autoriser modifications cross-projet | L |
| `DEBUG` / `排查` | Debug systématique | - |
| `REVIEW SPEC` / `计划评审` | Révision consultative pré-exécution | M/L |
| `REVIEW EXECUTE` / `代码评审` | Révision à trois axes post-exécution | M/L |
| `ARCHIVE` / `归档` / `沉淀` | Archivage des connaissances | L |
| `DOC` / `写文档` | Mode expert documentation | - |
| `EXIT ALTAS` / `退出协议` | Désactiver protocole | - |
| `全部` / `all` / `execute all` | Exécution par lots | M/L |

---

## 🏗️ Étapes du workflow

### Workflow Size M (Standard)

```mermaid
flowchart LR
    R["Research<br>Brouillon Spec"] --> P["Plan<br>Liste de tâches"]
    P --> E["Execute TDD<br>Tests échoués"]
    E --> RV["Review<br>Révision à trois axes"]
    RV --> V["Verification<br>Preuves"]
```

**Description du workflow**:
- **Research**: Alignement de recherche, former Spec (Goal, In-Scope, Out-of-Scope, Facts, Risks, Open Questions)
- **Plan**: Planification détaillée, décomposer en Checklist atomique, clarifier File Changes + Signatures + Done Contract
- **Execute**: Implémentation pilotée par TDD (RED→GREEN→REFACTOR)
- **Review**: Révision à trois axes (Qualité Spec / Cohérence Spec-code / Qualité intrinsèque du code)
- **Verification**: Preuves de vérification, s'assurer que les tests passent

### Workflow Size L (Profond)

```mermaid
flowchart LR
    R["Research<br>Brouillon Spec"] --> I["Innovate<br>Comparaison de solutions"]
    I --> P["Plan<br>Liste de tâches"]
    P --> E["Execute TDD+Subagent<br>Implémentation parallèle"]
    E --> RV["Review<br>Révision à trois axes"]
    RV --> A["Archive<br>Archivage des connaissances"]
```

**Description du workflow**:
- **Research**: Recherche approfondie, organiser les liens de statut actuel, identifier les risques
- **Innovate**: Comparaison de solutions, fournir 2-3 solutions (Pros/Cons/Risks/Effort)
- **Plan**: Checklist atomique + allocation Subagent
- **Execute**: Piloté par TDD + implémentation parallèle Subagent + révision en deux étapes
- **Review**: Révision à trois axes + archivage
- **Archive**: Générer documents à double perspective (version humaine + version LLM)

---

## ⚡ Adaptation intelligente de la profondeur

### Quatre niveaux de profondeur de tâche

| Taille | Condition déclencheuse | Exigence Spec | Workflow | Scénarios typiques |
|------|----------|----------|--------|----------|
| **XS (Extrêmement rapide)** | typo, valeur de config, <10 lignes | Sauter, résumé d'1 ligne après | Exécuter directement→vérifier→résumer | Changer config, corriger typo, logs |
| **S (Rapide)** | 1-2 fichiers, logique claire | micro-spec (1-3 phrases) | micro-spec→approuver→exécuter→réécrire | Ajouter paramètre, fonction simple |
| **M (Standard)** | 3-10 fichiers, dans module | Spec léger persisté | Research→Plan→Execute(TDD)→Review | Nouvelle interface, refactor module |
| **L (Profond)** | Cross-module, >500 lignes, niveau architecture | Spec complet + Innovate + Archive | Research→Innovate→Plan→Execute→Subagent→Review→Archive | Division architecture, transformation cross-équipe |

### Table de référence rapide d'évaluation de taille

| Signal | Taille recommandée | Description |
|------|----------|------|
| "Corriger un typo" | XS | Changement purement mécanique |
| "Ajouter un élément de config" | XS | Pas d'impact sur l'architecture |
| "Changer le texte du bouton" | XS/S | Scénario limite |
| "Ajouter un paramètre à cette interface" | S | Petit changement dans un seul fichier |
| "Ajouter une gestion d'erreur à cette fonction" | S | Logique claire |
| "Ajouter une nouvelle interface CRUD" | M | Développement dans module |
| "Refactorer ce module" | M/L | Scénario limite |
| "Changement de modèle de données cross-module" | L | Impact cross-module |
| "Refactoring niveau architecture" | L | Impact global |
| "Jointure frontend-backend" | L (MULTI) | Collaboration multi-projets |

### Mise à niveau/rétrogradation automatique

- **Complexité trouvée dépassant les attentes pendant l'exécution** → L'AI fait une pause immédiate, propose une mise à niveau
- **L'utilisateur peut utiliser à tout moment** `[Upgrade to M]` / `[Downgrade to S]` pour ajuster
- **Spécification forcée**: `>>`=XS, `FAST`=S, défaut=M, `DEEP`=L

---

## 🛡️ Lois de fer de qualité

| # | Loi de fer | Signification |
|---|------|------|
| 1 | **No Spec, No Code** | Pas de code avant de former le Spec minimum (Size XS exempté) |
| 2 | **No Approval, No Execute** | Jamais de code si l'humain ne hoche pas la tête en phase Plan |
| 3 | **Spec is Truth** | Quand Spec entre en conflit avec le code, le code a tort |
| 4 | **Reverse Sync** | Déviation trouvée en exécution → mettre à jour Spec d'abord → puis corriger le code |
| 5 | **Evidence First** | L'achèvement est prouvé par les résultats de vérification, pas par l'auto-déclaration du modèle |
| 6 | **No Root Cause, No Fix** | Analyse de cause racine requise avant correction de bug, corrections aveugles interdites |
| 7 | **TDD Iron Law** | Size M/L: Pas de code de production sans tests échoués |
| 8 | **Resume Ready** | Laisser une ancre de récupération dans Spec avant la pause de tâche longue |

---

## 🎯 Système de visualisation de progression

### Mécanisme de point de contrôle

**Après chaque étape terminée**, l'AI doit produire un point de contrôle standardisé:

```markdown
### Progression [Phase ▸ Étape]
[Terminé] ▸ **[Actuel]** ▸ [Suivant] ▸ [Suite...]

### Réalisation actuelle
- Ce qui vient d'être terminé (sortie spécifique)

### Sortie attendue
- Ce qui sera produit ensuite

### Actions suivantes
- **[Continue/Approved]**: Accepter, passer à l'étape suivante
- **[Modify]** + retour: Ajuster la réalisation actuelle
- **[Upgrade to X]** / **[Downgrade to X]**: Ajuster la taille
- **[Load Reference: XXX]**: Voir les détails d'un document de référence
```

---

## 📖 Documentation détaillée

### Documents principaux (Lecture obligatoire)

| Document | Objectif | Longueur |
|------|------|------|
| [Description détaillée ALTAS Workflow](altas-workflow/README.md) | Protocole de workflow complet | 650+ lignes |
| [Guide de démarrage rapide](altas-workflow/QUICKSTART.md) | Intégration en 30 secondes | 170+ lignes |
| [Index principal des documents de référence](altas-workflow/reference-index.md) | Carte de chargement à la demande | 200+ lignes |
| [SKILL.md](altas-workflow/SKILL.md) | Prompt système AI | 650+ lignes |

### Documents méthodologiques (Théorie)

| Document | Sujet | Public cible |
|------|------|----------|
| [De la programmation traditionnelle à la programmation LLM](altas-workflow/docs/从传统编程转向大模型编程.md) | Changement de paradigme | Tous |
| [Paradigme de développement AI-native](altas-workflow/docs/AI-原生研发范式 - 从代码中心到文档驱动的演进.md) | Piloté par documents | Architecte/Tech Lead |
| [Guide d'adoption en équipe](altas-workflow/docs/团队落地指南.md) | Promotion équipe | Tech Lead/Manager |
| [Tutoriel pas à pas](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md) | À partir de zéro | Débutants |

---

## 📊 Statistiques du dépôt

```
Taille du dépôt: 8.3M
Fichiers Markdown: 169
Documents de référence: 79
  - Spec-Driven Development: 7
  - Checkpoint-Driven: 4
  - Superpowers: 37
  - Agents: 22
  - Entry: 4
  - Special-Modes: 5
Protocoles principaux: 1 (SKILL.md)
Protocoles spécialisés: 3 (RIPER-5/RIPER-DOC/DUAL-COOP)
Méthodologie: 4
Agents indépendants: 2 (standard/léger)
Outils d'automatisation: 1 (archive_builder.py)
Documents Wiki: 69 (.qoder/repowiki/)
```

---

## 🎯 Navigation rapide

### Intégration débutants

1. [Guide de démarrage rapide](altas-workflow/QUICKSTART.md) - Intégration en 30 secondes
2. [De la programmation traditionnelle à la programmation LLM](altas-workflow/docs/从传统编程转向大模型编程.md) - Changement de paradigme
3. [Tutoriel pas à pas](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md) - À partir de zéro

### Référence rapide

- [Commandes principales](#-commandes-principales) - Tous les mots déclencheurs et commandes
- [Évaluation de taille](#-adaptation-intelligente-de-la-profondeur) - Comment choisir XS/S/M/L
- [Index des documents de référence](altas-workflow/reference-index.md) - Carte de chargement à la demande
- [Documentation détaillée](#-documentation-détaillée) - Liste complète des documents

---

*Propulsé par l'intégration de SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), et Superpowers.*

**Dernière mise à jour**: 2026-04-16
