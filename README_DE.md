# ALTAS Workflow

> **Drei Vorteile integriert | Intelligente Tiefenanpassung | Progressive Offenlegung | Schritt-für-Schritt-Feedback | Testingenieur-freundlich**

**Version:** 4.7 (2026-04-18)
**Repository-Größe:** 8.3M, 200+ Markdown-Dateien, 95+ Referenzdokumente

---

## 🌐 Sprache / Language

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | [Français](README_FR.md) | **Deutsch**

---

## 🎯 Was ist das?

**ALTAS Workflow** ist eine umfassende AI-native Entwicklungs-Workflow-Spezifikation, die das Wesen von drei hervorragenden Workflows integriert: **SDD-RIPER**, **SDD-RIPER-Optimized (Checkpoint-Driven)** und **Superpowers**.

### Kernmission

Dediziert an die Lösung vier großer Ingenieurs-Herausforderungen in der AI-Programmierung:

| Herausforderung | ALTAS-Lösung |
|------|-----------|
| **Kontextverfall** | CodeMap-Indexierung + progressive Offenlegung, Referenzmaterialien bei Bedarf laden |
| **Review-Lähmung** | 4-stufige intelligente Tiefe (XS/S/M/L), kleine Aufgaben blockieren nicht Genehmigung |
| **Code-Misstrauen** | Spec-zentriert + Drei-Achsen-Review, Spec is Truth |
| **Schwer wartbar** | Archive-Wissensakkumulation + TDD-Eisernes Gesetz, Fertigstellung = Vermögen |

### Kern-Eiserne Gesetze

1. **No Spec, No Code** — Kein Code vor Bildung des Minimums Specs (Size XS ausgenommen)
2. **No Approval, No Execute** — Niemals Code, wenn Mensch in Plan-Phase nicht nickt
3. **Spec is Truth** — Wenn Spec mit Code kollidiert, ist Code falsch
4. **Reverse Sync** — Abweichung während Ausführung entdeckt → zuerst Spec aktualisieren → dann Code korrigieren
5. **Evidence First** — Fertigstellung durch Verifizierungsergebnisse bewiesen, nicht Modell-Selbstdeklaration
6. **No Root Cause, No Fix** — Ursachenanalyse vor Bug-Fix erforderlich, blinde Korrekturen verboten
7. **TDD Iron Law** — Size M/L: Kein Produktionscode ohne fehlgeschlagenen Test
8. **Resume Ready** — Wiederherstellungsanker in Spec vor langer Aufgabenpause hinterlassen

---

## 📦 Was ist enthalten?

### Repository-Strukturübersicht

```
altas/
├── altas-workflow/              # Hauptprotokollverzeichnis (8.3M, 120+ Dateien)
│   ├── SKILL.md                 # ⭐ Kernsystemprompt (AI liest) - v4.7
│   ├── README.md                # ALTAS-Detailbeschreibung
│   ├── QUICKSTART.md            # Szenariobasierter Schnellstartleitfaden
│   ├── reference-index.md       // Masterindex für Referenzmaterialien
│   ├── workflow-diagrams.md     // Mermaid-Flussdiagrammsammlung
│   ├── protocols/               // Spezialisierte Protokolle (4)
│   │   ├── RIPER-5.md           // Strengmodus-Protokoll
│   │   ├── RIPER-DOC.md         // Dokumentations-Experten-Protokoll
│   │   └── SDD-RIPER-DUAL-COOP.md // Dual-Modell-Kooperationsprotokoll
│   │   └── PROTOCOL-SELECTION.md // Protokoll-Auswahl-Leitfaden
│   ├── docs/                    // Methodologie-Dokumente (5)
│   ├── references/              // Bedarfgesteuerte Referenzmaterialien (95+ Dateien)
│   │   ├── spec-driven-development/  // Spec-gesteuerte Entwicklung (7 Kerndokumente)
│   │   ├── checkpoint-driven/        // Checkpoint-Leichtgewichtsmodus (4 Dokumente)
│   │   ├── superpowers/              // Superkräfte (50+ Dokumente)
│   │   │   ├── test-driven-development/  // TDD Eisernes Gesetz
│   │   │   ├── systematic-debugging/     // Systematisches Debugging
│   │   │   ├── subagent-driven-development/ // Subagent-gesteuert
│   │   │   ├── brainstorming/            // Design-Brainstorming
│   │   │   ├── writing-plans/            // Best Practices für Plan-Schreiben
│   │   │   ├── code-review/              // Code-Review (Go/Python)
│   │   │   └── ... (mehr Superkräfte)
│   │   ├── agents/                       // Agent-Definitionen (22 Dokumente)
│   │   ├── entry//                        // Eingabekonfiguration (5 Dokumente)
│   │   ├── special-modes/                // Spezialmodi (5 Dokumente)
│   │   ├── prd-analysis/                 // 🆕 PRD-Analyse-Workflow (6 Dokumente)
│   │   └── testing/                      // 🆕 Test-Ingenieurwesen-Spezialität (18+ Dokumente)
│   │       ├── test-strategy-template.md    // Test-Strategie-Vorlage
│   │       ├── pytest-patterns.md           // Pytest-Best Practices
│   │       ├── e2e-testing.md               // E2E-Test-Leitfaden
│   │       ├── api-testing.md               // API-Test-Referenz
│   │       ├── performance-testing.md       // Performance-Test-Methodik
│   │       ├── security-testing.md          // Sicherheitstest
│   │       ├── contract-testing.md          // Vertragstest
│   │       ├── test-data-management.md      // Testdatenmanagement
│   │       ├── test-environment.md          // Test-Umgebungsmanagement
│   │       ├── ci-cd-integration.md         // CI/CD-Integration
│   │       └── templates/                   // Test-Gerüst-Vorlagen
│   └── scripts/                 // Automatisierungswerkzeuge
├── .agents/skills/              // 🆕 Unabhängige Skill-Pakete (6)
│   ├── advanced-api-testing/   // Erweitertes API-Testing
│   ├── go-code-review/         // Go-Code-Review
│   ├── python-code-review/     // Python-Code-Review
│   ├── pytest-patterns/        // Pytest-Muster
│   ├── specify-requirements/   // Anforderungsspezifikation
│   └── implementation-verify/  // Implementierungsüberprüfung
├── .qoder/repowiki/             // Wiki-Dokumente (69 Dokumente)
├── AGENTS.md                    // Allgemeine AI-Verhaltensrichtlinien
├── CLAUDE.md                    // Claude-spezifische Verhaltensrichtlinien
├── EXAMPLES.md                  // Vier Prinzipien Codebeispiele
└── skills-lock.json             // Skill-Paket-Versionsperrung
```

### Kern-Vermögensstatistiken

| Kategorie | Anzahl | Beschreibung |
|------|------|------|
| **Kernprotokoll** | 1 | SKILL.md (ALTAS Workflow Hauptprotokoll) v4.7 |
| **Spezialisierte Protokolle** | 4 | RIPER-5 / RIPER-DOC / DUAL-COOP / PROTOCOL-SELECTION |
| **Methodik** | 5 | Traditionell zu LLM / AI-natives Paradigma / Team-Einführung / Schritt-für-Schritt-Tutorial / v4.6 Implementierungsplan |
| **Referenzmaterialien** | 95+ | Spec-driven (7) / Checkpoint (4) / Superpowers (50+) / Agents (22) / Entry (5) / Special-Modes (5) / PRD Analyse (6) / Testing (18+) |
| **Unabhängige Agenten** | 2 | SDD-RIPER-ONE (Standard/Leicht) |
| **🆕 Skill-Pakete** | 6 | API-Test / Go-Review / Python-Review / Pytest / Anforderungsspezifikation / Implementierungsprüfung |
| **Codebeispiele** | 1 | EXAMPLES.md (Vier Prinzipien Praxisbeispiele) |
| **Automatisierungswerkzeuge** | 3 | archive_builder.py / scaffold.py / validate_aliases_sync.py |

---

## 🚀 v4.7 Neuheiten (2026-04-18)

### 🧪 Test-Ingenieurwesen-Spezialitätsoptimierung

- ✅ **E2E-Test-Framework-Referenzleitfaden**: End-to-End-Test-Best Practices mit Playwright/Cypress-Integration
- ✅ **Performance-/Lasttest-Methodik**: Stresstest-Strategie, Benchmark-Test, Performance-Metrikensystem
- ✅ **API-Test-vollständiger Prozess**: Vertragstest, Sicherheitstest, API-Test-Matrix-Vorlagen
- ✅ **Pytest-Test-Muster-Dokumentensuite**: Fixture-Design, Parametrisierung, Mock-Strategien, Abdeckung
- ✅ **Testdatenmanagement**: Factory-Pattern, Fixture-Hierarchie, Test-Isolation
- ✅ **Test-Umgebungsmanagement**: Docker Compose, Dependency Injection, Umgebungskonsistenz
- ✅ **CI/CD-Integrationstest**: Automatisierte Pipeline, Quality Gates, Testberichte
- ✅ **Test-Gerüst-Vorlagen**: Sofort einsatzbereit conftest.py / factories / fixtures
- ✅ **Go/Python-Test-Unterstützung**: Mehrsprachige Test-Best Practices und Anti-Pattern

### 🔍 Code-Review-Skill-Pakete

- ✅ **Go-Code-Review**: Statische Analyse, Performance-Audit, Parallelitäts-Sicherheitsprüfungen
- ✅ **Python-Code-Review**: Typsicherheit, Asynchrone Muster, Fehlerbehandlungsstandards
- ✅ **Review-Prozessstandardisierung**: Review Request → Code Quality → Spec Compliance

### 📋 PRD-Analyse-Workflow

- ✅ **Strukturierte Anforderungenalyse**: Brainstorm → Discover → Document → Review → Validate
- ✅ **PRD-Vorlage & Validierung**: Produktübersicht, User Personas, Journey, Funktionsanforderungen, Erfolgsmetriken
- ✅ **Qualitätsmetrik-Standards**: Strukturelle Vollständigkeit, Inhaltqualität, Grenzvalidierung, Querschnittskonsistenz

### 🛠️ Andere Verbesserungen

- ✅ **Alias-Synchronisierungsvalidierungsskript**: Automatische Konsistenzprüfung von Triggerwörtern
- ✅ **Projekt-Gerüst-Automatisierung**: Schnelle Initialisierung von Projektstruktur und Konventionen
- ✅ **Implementierungsprüfung-Skill**: Automatisierte Akzeptanztests und Abdeckungsprüfung
- ✅ **Erweiterte API-Test-Muster**: Idempotenz, Eingabevalidierung, Fehlerbehandlung, Parallelitätstests

---

## 🚀 Wie schnell verwenden?

### 30-Sekunden-Installation

**Methode 1**: `altas-workflow/SKILL.md` Inhalt in Custom Instructions des AI-Assistenten kopieren

**Methode 2**: In Cursor/Trae ausführen:
```bash
cp altas-workflow/SKILL.md .cursorrules
```

**Methode 3**: Projektkonfiguration
```bash
mkdir -p mydocs/{codemap,context,specs,micro_specs,archive}
```

### Plattformanpassung

| Plattform | Installationsmethode |
|------|----------|
| **Cursor / Trae** | `SKILL.md` Inhalt in `.cursorrules` oder globale AI Rules kopieren |
| **Claude / OpenAI Agent** | `SKILL.md` Inhalt als System Prompt injizieren |
| **Qoder** | `SKILL.md` in Projekt `.qoder/skills/` Verzeichnis platzieren |

---

### Sofortige Verwendung

**Ultra-schnelle Änderung (Size XS)**:
```
>> MAX_RETRIES in src/config.ts von 3 auf 5 ändern
```

**Kleine Aufgabe (Size S)**:
```
FAST: Bildverifizierungscode zur Login-Oberfläche hinzufügen
``**

**Standardentwicklung (Size M)**:
```
sdd_bootstrap: task=Anti-Scraping-Funktion durch Bildcode zur Benutzerregistrierung hinzufügen, goal=Sicherheitsverbesserung
```

**Architektur-Refactoring (Size L)**:
```
DEEP: Authentifizierungsmodul refaktorisieren, um in unabhängige Microservices aufzuteilen
```

**Bug-Untersuchung**:
```
DEBUG: log_path=./logs/error.log, issue=Autorisierung nach Genehmigung nicht erhalten
``**

**Multi-Projekt-Zusammenarbeit**:
```
MULTI: task=Frontend-Backend-Joint-Funktionsfreigabe
```

**🆕 PRD-Analyse**:
```
PRD: E-Commerce-Warenkorb-Anforderungen analysieren, strukturiertes PRD-Dokument ausgeben
```

**🆕 Test-Spezialität**:
```
TEST: E2E-Testfälle für Zahlungsmodul ergänzen
PERF: Performance-Stresstest auf Auftragsabfrage-Schnittstelle
REVIEW: Authentifizierungsmodul Codequalität prüfen (Go/Python)
```

---

## 📚 Kernbefehle

### Befehlsübersicht

| Befehl | Zweck | Anwendbare Größe | Workflow-Auswirkung |
|------|------|----------|----------|
| `>>` / `FAST` | Fast Track, Research/Plan überspringen | XS/S | Direkt ausführen→überprüfen→Zusammenfassung |
| `sdd_bootstrap` | RIPER-Workflow starten | M/L | Research→Plan→Execute→Review |
| `create_codemap` | Codekarte generieren | M/L | Nur-Lese-Analyse, keine Codeänderungen |
| `DEBUG` | System-Debug-Modus | - | Ursachenanalyse→Diagnosebericht |
| `MULTI` | Multi-Projekt-Zusammenarbeit | L | Auto-Entdeckung + Scope-Isolation |
| **`PRD`** | **🆕 PRD-Analyse** | **M/L** | **Brainstorm→Discover→Document→Review→Validate** |
| **`TEST`** | **🆕 Test-Spezialität** | **M/L** | **Test-Strategie→Fall-Design→Implementierung→Verifizierung** |
| **`PERF`** | **🆕 Performance-Optimierung** | **L** | **Baselinemessung→Engpassanalyse→Optimierung→Regressionverifizierung** |
| **`REVIEW`** | **🆕 Code-Review** | **M/L** | **Review-Anfrage→Qualitätsprüfung→Compliance-Validierung** |
| **`REFACTOR`** | **🆕 Refactoring-Spezialität** | **L** | **CodeMap→Plan(TDD)→Execute→Review** |
| **`MIGRATE`** | **🆕 Migration-Spezialität** | **L** | **Risikobewertung→Migration→Verifizierung** |

---

## ⚡ Intelligente Tiefenanpassung

### Vierstufige Task-Tiefe

| Größe | Triggerbedingung | Spec-Anforderung | Workflow | Typische Szenarien |
|------|----------|----------|--------|----------|
| **XS (Ultraschnell)** | typo, Konfigurationswert, <10 Zeilen | Überspringen, 1-Zeilen-Zusammenfassung danach | Direkt ausführen→überprüfen→Zusammenfassung | Konfiguration ändern, typo korrigieren, Logs |
| **S (Schnell)** | 1-2 Dateien, klare Logik | micro-spec (1-3 Sätze) | micro-spec→genehmigen→ausführen→zurückschreiben | Parameter hinzufügen, einfache Funktion |
| **M (Standard)** | 3-10 Dateien, innerhalb Modul | Leichtes Spec persistiert | Research→Plan→Execute(TDD)→Review | Neue Schnittstelle, Modul-Refactoring |
| **L (Tief)** | Cross-Modul, >500 Zeilen, Architektur-Ebene | Vollständiges Spec + Innovate + Archive | Research→Innovate→Plan→Execute→Subagent→Review→Archive | Architekturaufteilung, Cross-Team-Transformation |

---

## 🛡️ Qualitäts-Eiserne Gesetze

| # | Eisernes Gesetz | Bedeutung |
|---|------|------|
| 1 | **No Spec, No Code** | Kein Code vor Minimum Spec-Bildung (Size XS ausgenommen) |
| 2 | **No Approval, No Execute** | Kein Code wenn Mensch in Plan-Phase nicht genehmigt |
| 3 | **Spec is Truth** | Wenn Spec mit Code kollidiert, ist Code falsch |
| 4 | **Reverse Sync** | Abweichung während Ausführung → erst Spec aktualisieren → dann Code korrigieren |
| 5 | **Evidence First** | Fertigstellung durch Verifizierungsergebnisse bewiesen, nicht Selbstdeklaration des Modells |
| 6 | **No Root Cause, No Fix** | Ursachenanalyse vor Bug-Fix erforderlich, blinde Korrekturen verboten |
| 7 | **TDD Iron Law** | Size M/L: Kein Produktionscode ohne fehlgeschlagenen Test |
| 8 | **Resume Ready** | Wiederherstellungsanker in Spec vor langer Aufgabenpause hinterlassen |

---

## 🎓 Typische Verwendungsszenarien

### 🆕 Szenario 6: PRD-Analyse (v4.7)

**Eingabe**:
```
PRD: E-Commerce-Warenkorb-Anforderungen analysieren, Ziel=Konversionsrate um 20% steigern
```

**AI-Verhalten**:
1. ✅ PRD-Analyse-Modus betreten
2. ✅ **Brainstorm** → Stakeholder-Eingaben sammeln, Wettbewerbsanalyse
3. ✅ **Discover** → Nutzerforschung, Datenanalyse, technische Machbarkeit
4. ✅ **Document** → Strukturiertes PRD ausgeben (Produktübersicht/User Personas/Journey/Funktionale Anforderungen/Erfolgsmetriken)
5. ✅ **Review** → Stakeholder-Review
6. ✅ **Validate** → Qualitätsmetrik-Validierung (Strukturelle Vollständigkeit/Inhaltsqualität/Grenzvalidierung)

**Ergebnis**:
- PRD-Dokument: `mydocs/prds/YYYY-MM-DD_hh-mm_ECommerceWarenkorbOptimierung.md`
- Validierungsbericht: Liste bestandener/nicht bestandener Punkte

---

### 🆕 Szenario 7: E2E-Test-Spezialität (v4.7)

**Eingabe**:
```
TEST: Kritische Pfad-E2E-Tests für Zahlungsmodul ergänzen
Bereich: src/modules/payment
Ziel: Kompletten Ablauf Bestellung→Zahlung→Callback abdecken
Einschränkungen: Playwright verwenden, keine echte Zahlungs-Gateway-Abhängigkeit
```

**AI-Verhalten**:
1. ✅ TEST-Modus betreten
2. ✅ **Strategy** → [test-strategy-template.md](altas-workflow/references/testing/test-strategy-template.md) referenzieren, Test-Strategie formulieren
3. ✅ **Design** → [e2e-testing.md](altas-workflow/references/testing/e2e-testing.md) referenzieren, Testfälle entwerfen
4. ✅ **Implement** → [templates/](altas-workflow/references/testing/templates/) Gerüst für schnelle Implementierung verwenden
5. ✅ **Verify** → Tests ausführen, Berichte generieren

**Ergebnis**:
- Testdatei: `src/modules/payment/e2e/checkout-flow.spec.ts`
- Testbericht: Abdeckung, Durchlaufquote, Performance-Metriken

---

## 📋 Versionshistorie

| Version | Datum | Name | Status | Schlüsseländerungen |
|------|------|------|------|----------|
| **v4.7** | 2026-04-18 | ALTAS Workflow | ✅ **Aktuelle Version** | 🧪Test-Ingenieurwesen-Spezialitätsoptimierung, 🔍Code-Review-Skill-Pakete, 📋PRD-Analyse-Workflow, 🛠️Automatisierungsverbesserung |
| **v4.6** | 2026-04-16 | ALTAS Workflow | ✅ Stabile Version | Implementierungsplan-Verfeinerung, Protokoll-Auswahl-Leitfaden |
| **v4.0** | 2026-04-13 | ALTAS Workflow | ✅ Historische Version | Drei Workflows integriert, intelligente Tiefenanpassung, Fortschrittsvisualisierung, Bedarfsladen hinzugefügt |
| **v1.0** | 2026-04-12 | SIGMA Workflow | ❌ Veraltet | Initialversion |

### v4.7 Kernmerkmale

#### 🧪 Test-Ingenieurwesen-Spezialität
- ✅ E2E-Test-Framework-Referenzleitfaden (Playwright/Cypress)
- ✅ Performance-/Lasttest-Methodik und Stress-Test-Strategie
- ✅ API-Test-vollständiger Prozess (Vertragstest, Sicherheitstest)
- ✅ Pytest-Test-Muster-Dokumentensuite (Fixture/Parametrisierung/Mock)
- ✅ Testdatenmanagement und Factory-Pattern
- ✅ Test-Umgebungsmanagement und Docker-Integration
- ✅ CI/CD-Integrationstest und Quality Gates
- ✅ Test-Gerüst-Vorlagen (Sofort einsatzbereit)
- ✅ Go/PHP/Mehrsprachige Test-Unterstützung

#### 🔍 Code-Review-Skill-Pakete
- ✅ Go-Code-Review (Statische Analyse, Parallelitätssicherheit, Performance-Audit)
- ✅ Python-Code-Review (Typsicherheit, Asynchrone Muster, Fehlerbehandlung)
- ✅ Erweiterte API-Test-Muster (Idempotenz, Parallelität, Vertragstest)
- ✅ Review-Prozessstandardisierung (Request → Quality → Compliance)

#### 📋 PRD-Analyse-Workflow
- ✅ Strukturierte Anforderungenanalyse fünf Phasen Prozess
- ✅ PRD-Vorlage und Validierungsstandards
- ✅ Qualitätsmetrik vier Dimensionen Bewertung
- ✅ Gutes PRD-Beispielreferenz

#### 🛠️ Automatisierungsverbesserung
- ✅ Alias-Synchronisierungsvalidierungsskript
- ✅ Projekt-Gerüst-Automatisierung
- ✅ Implementierungsprüfung-Skill
- ✅ Anforderungsspezifikations-Skill

---

## 📊 Repository-Statistiken

```
Repository-Größe: 8.3M
Markdown-Dateien: 200+
Referenzmaterialien: 95+
  - Spec-Driven Development: 7
  - Checkpoint-Driven: 4
  - Superpowers: 50+
  - Agents: 22
  - Entry: 5
  - Special-Modes: 5
  - 🆕 PRD Analysis: 6
  - 🆕 Testing: 18+
Kernprotokolle: 1 (SKILL.md v4.7)
Spezialisierte Protokolle: 4 (RIPER-5/RIPER-DOC/DUAL-COOP/PROTOCOL-SELECTION)
Methodik: 5
Unabhängige Agenten: 2 (Standard/Leicht)
🆕 Skill-Pakete: 6 (API-Test/Go-Review/Python-Review/Pytest/Anforderungsspezifikation/Implementierungsprüfung)
Automatisierungswerkzeuge: 3 (archive_builder/scaffold/validate_aliases)
Wiki-Dokumente: 69 (.qoder/repowiki/)
```

---

## 📊 Technologie-Stack-Kompatibilität

### Programmiersprachenunterstützung

| Sprache | Test-Framework | Code-Review | Dokumentationsabdeckung |
|------|----------|----------|----------|
| **Python** | Pytest, unittest | ✅ Python Code Review | Typsicherheit, asynchrone Muster, Fehlerbehandlung |
| **Go** | testing, ginkgo | ✅ Go Code Review | Statische Analyse, Parallelitätssicherheit, Performance-Audit |
| **JavaScript/TypeScript** | Jest, Playwright, Cypress | ⚠️ Über API Testing | E2E, API-Test |
| **Java** | JUnit, TestNG | ⚠️ Allgemeiner Prozess | TDD, Test-Strategie |
| **Allgemein** | - | Implementation Verify | Abdeckung, Akzeptanztest |

### Plattformkompatibilität

| Plattform | Unterstützungsgrad | Hinweise |
|------|----------|------|
| **Cursor** | ✅ Volle Unterstützung | Empfohlen, `.cursorrules` Integration |
| **Trae** | ✅ Volle Unterstützung | Native Integration |
| **Claude Desktop** | ✅ Volle Unterstützung | System Prompt Injektion |
| **OpenAI Agents** | ✅ Volle Unterstützung | System Prompt Injektion |
| **Qoder** | ✅ Volle Unterstützung | `.qoder/skills/` Integration |
| **VS Code + Copilot** | ⚠️ Grundlegende Unterstützung | Manuelle Konfiguration erforderlich |

---

*Angetrieben durch die Integration von SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), Superpowers und erweitert mit Test-Ingenieurwesen- & Code-Review-Fähigkeiten.*

**Letzte Aktualisierung**: 2026-04-18
**Aktuelle Version**: v4.7
**Wartungsstatus**: 🟢 Aktive Entwicklung
