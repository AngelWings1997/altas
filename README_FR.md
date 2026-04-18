# ALTAS Workflow

> **Fusion de trois avantages | Adaptation intelligente en profondeur | Divulgation progressive | Rétroaction étape par étape | Amical pour les ingénieurs de test**

**Version :** 4.7 (2026-04-18)
**Taille du dépôt :** 8.3M, 200+ fichiers Markdown, 95+ documents de référence

---

## 🌐 Langue / Language

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | **Français** | [Deutsch](README_DE.md)

---

## 🎯 Qu'est-ce que c'est ?

**ALTAS Workflow** est une spécification complète de workflow de développement AI-native qui intègre l'essence de trois excellents workflows : **SDD-RIPER**, **SDD-RIPER-Optimized (Checkpoint-Driven)** et **Superpowers**.

### Mission Principale

Dédié à résoudre quatre douleurs majeures d'ingénierie dans la programmation AI :

| Douleur | Solution ALTAS |
|------|-----------|
| **Pourriture du contexte** | Indexation CodeMap + divulgation progressive, charger les références à la demande |
| **Paralysie de la revue** | 4 niveaux de profondeur intelligente (XS/S/M/L), petites tâches ne bloquent pas l'approbation |
| **Méfiance du code** | Centré sur Spec + revue à trois axes, Spec is Truth |
| **Difficile à maintenir** | Accumulation des connaissances Archive + loi TDD, complément = actif |

### Lois de Fer Principales

1. **No Spec, No Code** — Pas de code avant formation du minimum Spec (Size XS exempté)
2. **No Approval, No Execute** — Jamais de code si l'humain n'a pas approuvé dans la phase Plan
3. **Spec is Truth** — Quand Spec entre en conflit avec le code, le code a tort
4. **Reverse Sync** — Écart découvert pendant l'exécution → mettre à jour Spec d'abord → puis corriger le code
5. **Evidence First** — Complétion prouvée par résultats de vérification, pas auto-déclaration du modèle
6. **No Root Cause, No Fix** — Analyse de cause racine requise avant correction de bug, corrections aveugles interdites
7. **TDD Iron Law** — Size M/L : Pas de code production sans test échouant
8. **Resume Ready** — Laisser une ancre de récupération dans Spec avant pause longue tâche

---

## 📦 Qu'est-ce qui est inclus ?

### Aperçu de la Structure du Dépôt

```
altas/
├── altas-workflow/              # Répertoire principal du protocole (8.3M, 120+ fichiers)
│   ├── SKILL.md                 # ⭐ Prompt système central (lu par l'IA) - v4.7
│   ├── README.md                # Description détaillée ALTAS
│   ├── QUICKSTART.md            # Guide rapide basé sur scénarios
│   ├── reference-index.md       # Index maître des matériaux de référence
│   ├── workflow-diagrams.md     # Collection de diagrammes Mermaid
│   ├── protocols/               # Protocoles spécialisés (4)
│   │   ├── RIPER-5.md           # Protocole mode strict
│   │   ├── RIPER-DOC.md         # Protocole expert documentation
│   │   └── SDD-RIPER-DUAL-COOP.md # Protocole collaboration double modèle
│   │   └── PROTOCOL-SELECTION.md # Guide de sélection de protocole
│   ├── docs/                    # Documents méthodologiques (5)
│   ├── references/              # Matériaux de référence à la demande (95+ fichiers)
│   │   ├── spec-driven-development/  # Développement piloté par Spec (7 documents)
│   │   ├── checkpoint-driven/        # Mode léger Checkpoint (4 documents)
│   │   ├── superpowers/              # Super-pouvoirs (50+ documents)
│   │   │   ├── test-driven-development/  # Loi TDD
│   │   │   ├── systematic-debugging/     # Débugage systématique
│   │   │   ├── subagent-driven-development/ # Piloté par Subagent
│   │   │   ├── brainstorming/            # Brainstorming de conception
│   │   │   ├── writing-plans/            # Meilleures pratiques d'écriture Plan
│   │   │   ├── code-review/              # Revue de code (Go/Python)
│   │   │   └── ... (plus de super-pouvoirs)
│   │   ├── agents/                       # Définitions d'agents (22 documents)
│   │   ├── entry/                        # Configuration d'entrée (5 documents)
│   │   ├── special-modes/                # Modes spéciaux (5 documents)
│   │   ├── prd-analysis/                 # 🆕 Workflow analyse PRD (6 documents)
│   │   └── testing/                      # 🆕 Spécialité ingénierie de test (18+ documents)
│   │       ├── test-strategy-template.md    # Modèle stratégie de test
│   │       ├── pytest-patterns.md           # Meilleures pratiques Pytest
│   │       ├── e2e-testing.md               # Guide E2E
│   │       ├── api-testing.md               # Référence API test
│   │       ├── performance-testing.md       # Méthodologie performance test
│   │       ├── security-testing.md          # Test sécurité
│   │       ├── contract-testing.md          # Test contrat
│   │       ├── test-data-management.md      # Gestion données test
│   │       ├── test-environment.md          # Gestion environnement test
│   │       ├── ci-cd-integration.md         # Intégration CI/CD
│   │       └── templates/                   # Modèles scaffolding test
│   └── scripts/                 # Outils d'automatisation
├── .agents/skills/              # 🆕 Paquets de compétences indépendants (6)
│   ├── advanced-api-testing/   # Test API avancé
│   ├── go-code-review/         # Revue code Go
│   ├── python-code-review/     # Revue code Python
│   ├── pytest-patterns/        # Motifs Pytest
│   ├── specify-requirements/   # Spécification exigences
│   └── implementation-verify/  # Vérification implémentation
├── .qoder/repowiki/             # Documents Wiki (69 documents)
├── AGENTS.md                    # Lignes directrices comportement IA générales
├── CLAUDE.md                    # Lignes directrices comportement Claude
├── EXAMPLES.md                  # Exemples code quatre principes
└── skills-lock.json             # Verrouillage version paquets compétences
```

### Statistiques des Actifs Principaux

| Catégorie | Quantité | Description |
|------|------|------|
| **Protocole Central** | 1 | SKILL.md (protocole principal ALTAS Workflow) v4.7 |
| **Protocoles Spécialisés** | 4 | RIPER-5 / RIPER-DOC / DUAL-COOP / PROTOCOL-SELECTION |
| **Méthodologie** | 5 | Traditionnel vers LLM / Paradigme AI-native / Adoption équipe / Tutoriel pas à pas / Plan implémentation v4.6 |
| **Matériaux Référence** | 95+ | Spec-driven (7) / Checkpoint (4) / Superpowers (50+) / Agents (22) / Entry (5) / Special-Modes (5) / PRD Analyse (6) / Testing (18+) |
| **Agents Indépendants** | 2 | SDD-RIPER-ONE (standard/léger) |
| **🆕 Paquets Compétences** | 6 | API Test / Revue Go / Revue Python / Pytest / Spécification Exigences / Vérification Implémentation |
| **Exemples Code** | 1 | EXAMPLES.md (exemples pratiques quatre principes) |
| **Outils Automatisation** | 3 | archive_builder.py / scaffold.py / validate_aliases_sync.py |

---

## 🚀 Nouveautés v4.7 (2026-04-18)

### 🧪 Optimisation Spécialité Ingénierie de Test

- ✅ **Guide de Référence Framework E2E** : Meilleures pratiques test bout-en-bout avec intégration Playwright/Cypress
- ✅ **Méthodologie Test Performance/Charge** : Stratégie stress test, benchmark test, système métriques performance
- ✅ **Processus Complet API Test** : Test contrat, test sécurité, modèles matrice API test
- ✅ **Suite Documents Motifs Pytest** : Conception Fixture, paramétrisation, stratégies Mock, couverture
- ✅ **Gestion Données Test** : Pattern usine, hiérarchie Fixture, isolation test
- ✅ **Gestion Environnement Test** : Docker Compose, injection dépendance, cohérence environnement
- ✅ **Intégration Test CI/CD** : Pipeline automatisé, portes qualité, rapports test
- ✅ **Modèles Scaffolding Test** : Prêt à l'emploi conftest.py / factories / fixtures
- ✅ **Support Test Go/Python** : Meilleures pratiques et anti-patterns multi-langages

### 🔍 Paquets Compétences Revue de Code

- ✅ **Revue Code Go** : Analyse statique, audit performance, vérifications sécurité concurrence
- ✅ **Revue Code Python** : Sécurité type, motifs asynchrones, normes gestion erreurs
- ✅ **Standardisation Processus Revue** : Review Request → Code Quality → Spec Compliance

### 🆕 Autres Améliorations

- ✅ Script validation synchronisation alias
- ✅ Automatisation scaffolding projet
- ✅ Compétence vérification implémentation
- ✅ Motifs test API avancés

---

## 🚀 Comment Utiliser Rapidement ?

### Installation 30 Secondes

**Méthode 1** : Copier contenu `altas-workflow/SKILL.md` dans Custom Instructions assistant IA

**Méthode 2** : Exécuter dans Cursor/Trae :
```bash
cp altas-workflow/SKILL.md .cursorrules
```

**Méthode 3** : Configuration projet
```bash
mkdir -p mydocs/{codemap,context,specs,micro_specs,archive}
```

### Utilisation Immédiate

**Modification Ultra Rapide (Size XS)**:
```
>> Changer MAX_RETRIES de 3 à 5 dans src/config.ts
```

**Petite Tâche (Size S)**:
```
FAST: Ajouter code verification image à interface connexion
```

**Développement Standard (Size M)**:
```
sdd_bootstrap: task=Ajouter fonction anti-scraping par code image à inscription utilisateur, goal=Amélioration sécurité
```

**Refactoring Architecture (Size L)**:
```
DEEP: Refactor module authentification pour séparer en microservices indépendants
```

**🆕 Analyse PRD**:
```
PRD: Analyser exigences panier e-commerce, sortie document PRD structuré
```

**🆕 Spécialité Test**:
```
TEST: Compléter cas test E2E module paiement
PERF: Stress test performance interface requête commande
REVIEW: Revue qualité code module authentification (Go/Python)
```

---

## 📚 Commandes Principales

### Aperçu des Commandes

| Commande | Usage | Taille Applicable | Impact Workflow |
|------|------|----------|----------|
| `>>` / `FAST` | Voie rapide, sauter Research/Plan | XS/S | Exécuter directement→vérifier→résumé |
| `sdd_bootstrap` | Démarrer workflow RIPER | M/L | Research→Plan→Execute→Review |
| `create_codemap` | Générer carte code | M/L | Analyse lecture seule, pas modification code |
| `DEBUG` | Mode debug système | - | Analyse cause racine→rapport diagnostic |
| `MULTI` | Collaboration multi-projet | L | Auto-découverte + isolation scope |
| `ARCHIVE` | Accumulation connaissances | L | Version humaine + version LLM double perspective |
| **`PRD`** | **🆕 Analyse PRD** | **M/L** | **Brainstorm→Discover→Document→Review→Validate** |
| **`TEST`** | **🆕 Spécialité Test** | **M/L** | **Stratégie test→Conception cas→Implémentation→Vérification** |
| **`PERF`** | **🆕 Optimisation Performance** | **L** | **Mesure baseline→Analyse goulot→Optimisation→Vérification régression** |
| **`REVIEW`** | **🆕 Revue Code** | **M/L** | **Demande revue→Vérification qualité→Validation conformité** |
| **`REFACTOR`** | **🆕 Spécialité Refactoring** | **L** | **CodeMap→Plan(TDD)→Execute→Review** |
| **`MIGRATE`** | **🆕 Spécialité Migration** | **L** | **Évaluation risque→Migration→Vérification** |

---

## ⚡ Adaptation Intelligente Profondeur

### Quatre Niveaux Profondeur Tâche

| Taille | Condition Déclencheur | Exigence Spec | Workflow | Scénarios Typiques |
|------|----------|----------|--------|----------|
| **XS (Ultra Rapide)** | typo, config valeur, <10 lignes | Sauter, résumé 1 ligne après | Direct exécuter→vérifier→résumé | Modifier config, corriger typo, logs |
| **S (Rapide)** | 1-2 fichiers, logique claire | micro-spec (1-3 phrases) | micro-spec→approuver→exécuter→réécrire | Ajouter paramètre, fonction simple |
| **M (Standard)** | 3-10 fichiers, dans module | Spec léger persisté | Research→Plan→Execute(TDD)→Review | Nouvelle interface, refactoring module |
| **L (Profond)** | Cross-module, >500 lignes, architecture | Spec complet + Innovate + Archive | Research→Innovate→Plan→Execute→Subagent→Review→Archive | Séparation architecture, transformation cross-équipe |

---

## 🛡️ Lois de Fer Qualité

| # | Loi de Fer | Signification |
|---|------|------|
| 1 | **No Spec, No Code** | Pas de code avant minimum Spec (Size XS exempté) |
| 2 | **No Approval, No Execute** | Pas de code si humain n'approuve pas phase Plan |
| 3 | **Spec is Truth** | Quand Spec conflit avec code, code a tort |
| 4 | **Reverse Sync** | Écart trouvé exécution → mettre à jour Spec → puis corriger code |
| 5 | **Evidence First** | Complétion prouvée par vérification, pas auto-déclaration modèle |
| 6 | **No Root Cause, No Fix** | Analyse cause racine requise avant fix bug, corrections aveugles interdites |
| 7 | **TDD Iron Law** | Size M/L: Pas de code production sans test échouant |
| 8 | **Resume Ready** | Laisser ancre récupération Spec avant pause tâche longue |

---

## 🎓 Scénarios d'Utilisation Typiques

### 🆕 Scénario 6 : Analyse PRD (v4.7)

**Entrée**:
```
PRD: Analyser exigences panier e-commerce, objectif=Augmenter taux conversion 20%
```

**Comportement IA**:
1. ✅ Entrer mode analyse PRD
2. ✅ **Brainstorm** → Collecter input parties prenantes, analyse concurrentielle
3. ✅ **Discover** → Recherche utilisateur, analyse données, faisabilité technique
4. ✅ **Document** → Sortir PRD structuré (Aperçu produit/Personas/Journey/Exigences fonctionnelles/Métriques succès)
5. ✅ **Review** → Revue parties prenantes
6. ✅ **Validate** → Validation métriques qualité (Intégrité structurelle/Qualité contenu/Validation frontières)

**Résultat**:
- Document PRD: `mydocs/prds/YYYY-MM-DD_hh-mm_OptimisationPanierECommerce.md`
- Rapport validation: Liste items passés/non passés

---

### 🆕 Scénario 7 : Spécialité Test E2E (v4.7)

**Entrée**:
```
TEST: Compléter tests E2E chemin critique module paiement
Scope: src/modules/payment
Objectif: Couvrir flux complet Commande→Paiement→Rappel
Contraintes: Utiliser Playwright, sans dépendance passerelle paiement réelle
```

**Comportement IA**:
1. ✅ Entrer mode TEST
2. ✅ **Strategy** → Référer [test-strategy-template.md](altas-workflow/references/testing/test-strategy-template.md) formuler stratégie test
3. ✅ **Design** → Référer [e2e-testing.md](altas-workflow/references/testing/e2e-testing.md) concevoir cas test
4. ✅ **Implement** → Utiliser [templates/](altas-workflow/references/testing/templates/) scaffolding implémentation rapide
5. ✅ **Verify** → Exécuter tests, générer rapports

**Résultat**:
- Fichier test: `src/modules/payment/e2e/checkout-flow.spec.ts`
- Rapport test: Couverture, taux passage, métriques performance

---

## 📋 Historique des Versions

| Version | Date | Nom | Statut | Changements Clés |
|------|------|------|------|----------|
| **v4.7** | 2026-04-18 | ALTAS Workflow | ✅ **Version Actuelle** | 🧪Optimisation spécialité ingénierie test, 🔍Paquets compétences revue code, 📋Workflow analyse PRD, 🛠️Amélioration automatisation |
| **v4.6** | 2026-04-16 | ALTAS Workflow | ✅ Version Stable | Affinement plan implémentation, guide sélection protocole |
| **v4.0** | 2026-04-13 | ALTAS Workflow | ✅ Version Historique | Intégration trois workflows, ajout adaptation profondeur intelligente, visualisation progression, chargement à la demande |
| **v1.0** | 2026-04-12 | SIGMA Workflow | ❌ Obsolète | Version initiale |

### Caractéristiques Principales v4.7

#### 🧪 Spécialité Ingénierie de Test
- ✅ Guide référence framework E2E (Playwright/Cypress)
- ✅ Méthodologie test performance/charge et stratégie stress test
- ✅ Processus complet API test (test contrat, test sécurité)
- ✅ Suite documents motifs Pytest (Fixture/paramétrage/Mock)
- ✅ Gestion données test et pattern usine
- ✅ Gestion environnement test et intégration Docker
- ✅ Intégration test CI/CD et portes qualité
- ✅ Modèles scaffolding test (prêt à l'emploi)
- ✅ Support test multi-langages Go/Python

#### 🔍 Paquets Compétences Revue de Code
- ✅ Revue code Go (analyse statique, sécurité concurrence, audit performance)
- ✅ Revue code Python (sécurité type, motifs asynchrones, gestion erreurs)
- ✅ Motifs test API avancés (idempotence, concurrence, test contrat)
- ✅ Standardisation processus revue (Request → Quality → Compliance)

#### 📋 Workflow Analyse PRD
- ✅ Processus cinq phases analyse exigences structurées
- ✅ Modèle PRD et standards validation
- ✅ Évaluation métriques qualité quatre dimensions
- ✅ Exemple bon PRD référence

#### 🛠️ Amélioration Automatisation
- ✅ Script validation synchronisation alias
- ✅ Automatisation scaffolding projet
- ✅ Compétence vérification implémentation
- ✅ Compétence spécification exigences

---

## 📊 Statistiques du Dépôt

```
Taille Dépôt: 8.3M
Fichiers Markdown: 200+
Matériaux Référence: 95+
  - Spec-Driven Development: 7
  - Checkpoint-Driven: 4
  - Superpowers: 50+
  - Agents: 22
  - Entry: 5
  - Special-Modes: 5
  - 🆕 PRD Analysis: 6
  - 🆕 Testing: 18+
Protocoles Centraux: 1 (SKILL.md v4.7)
Protocoles Spécialisés: 4 (RIPER-5/RIPER-DOC/DUAL-COOP/PROTOCOL-SELECTION)
Méthodologie: 5
Agents Indépendants: 2 (standard/léger)
🆕 Paquets Compétences: 6 (API Test/Revue Go/Revue Python/Pytest/Spécification Exigences/Vérification Implémentation)
Outils Automatisation: 3 (archive_builder/scaffold/validate_aliases)
Documents Wiki: 69 (.qoder/repowiki/)
```

---

## 📊 Compatibilité Stack Technique

### Support Langages Programmation

| Langage | Framework Test | Revue Code | Couverture Documentation |
|------|----------|----------|----------|
| **Python** | Pytest, unittest | ✅ Python Code Review | Sécurité type, motifs asynchrones, gestion erreurs |
| **Go** | testing, ginkgo | ✅ Go Code Review | Analyse statique, sécurité concurrence, audit performance |
| **JavaScript/TypeScript** | Jest, Playwright, Cypress | ⚠️ Via API Testing | E2E, test API |
| **Java** | JUnit, TestNG | ⚠️ Processus général | TDD, stratégie test |
| **Général** | - | Implementation Verify | Couverture, test acceptation |

### Compatibilité Plateforme

| Plateforme | Niveau Support | Notes |
|------|----------|------|
| **Cursor** | ✅ Support complet | Recommandé, intégration `.cursorrules` |
| **Trae** | ✅ Support complet | Intégration native |
| **Claude Desktop** | ✅ Support complet | Injection System Prompt |
| **OpenAI Agents** | ✅ Support complet | Injection System Prompt |
| **Qoder** | ✅ Support complet | Intégration `.qoder/skills/` |
| **VS Code + Copilot** | ⚠️ Support basique | Configuration manuelle requise |

---

*Propulsé par l'intégration de SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), Superpowers, et amélioré avec capacités Ingénierie de Test & Revue de Code.*

**Dernière mise à jour**: 2026-04-18
**Version actuelle**: v4.7
**Statut maintenance**: 🟢 Développement actif
