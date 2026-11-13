# ZFC4Lean
### An Explicit First-Order Axiomatic Foundation for Set Theory in Lean 4

[![Lean 4](https://img.shields.io/badge/Lean-4.12.0-blue)](https://lean-lang.org/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache--2.0-green.svg)](LICENSE)
[![Research](https://img.shields.io/badge/Research-Active-orange.svg)](https://osf.io/m47re/overview)

**ZFC4Lean** is a research project to formalize Zermelo–Fraenkel set theory with the Axiom of Choice (ZFC) as an explicit first-order axiomatic system in Lean 4.

Unlike semantic set-theoretic models developed within Lean's type theory, ZFC4Lean aims to provide a syntactic framework in which the language, axioms, proof system, and model-theoretic semantics of ZFC are explicitly represented.

The long-term research objective is to develop a machine-verified Lean 4 formalization of Gödel's constructible universe \(L\), Cohen forcing, and the independence of the Continuum Hypothesis (CH) from ZFC.

**Research status:** Phase 0 framework reported complete; Phase 1 in progress. The full formalization of \(L\) and CH independence remains planned research.

---

## 1. Research Motivation

The Continuum Hypothesis (CH) asks whether there exists a cardinal strictly between the cardinality of the natural numbers and the cardinality of the real numbers:

\[
2^{\aleph_0}=\aleph_1.
\]

Gödel and Cohen established that CH is independent of ZFC, assuming ZFC is consistent:

- **Gödel (1938):** The constructible universe \(L\) provides a model of ZFC + GCH, establishing the relative consistency of CH.
- **Cohen (1963):** The forcing method establishes the relative consistency of ¬CH.

The formal verification of these results is a significant challenge in mathematical logic and interactive theorem proving.

The Lean 3 project *flypitch* by Han and van Doorn established an important precedent by formalizing CH independence using Boolean-valued models.

ZFC4Lean explores a Lean 4 implementation of an explicit first-order axiomatic framework for this type of metamathematical research.

## 2. Mathematical Approach

### 2.1 Explicit First-Order Logic

ZFC4Lean defines its own first-order language and proof system within Lean 4.

The framework includes:

- First-order terms and formulas.
- de Bruijn indices for variable representation.
- Variable lifting and substitution.
- A Hilbert-style deductive system.
- Syntactic provability and consistency.
- First-order structures and model-theoretic satisfaction.
- Semantic entailment and soundness.

### 2.2 Syntactic and Semantic Approaches

An important distinction is the difference between formalizing mathematics inside a set-theoretic model and formalizing the axiomatic system itself.

| Feature | Mathlib4 ZFSet | ZFC4Lean |
|---|---|---|
| Foundation | Lean type theory | Explicit first-order logic |
| ZFC axioms | Represented through the semantic framework | Explicit first-order sentences |
| Proof approach | Mathematics within a set model | Syntactic derivations |
| Main objective | General set-theoretic mathematics | Metamathematics of ZFC |

These approaches address different formalization objectives and are intended to be complementary.

### 2.3 Design Decisions

The framework adopts five principal design decisions:

1. **de Bruijn indices:** Represent bound variables using natural-number indices to avoid variable capture.
2. **List-based arguments:** Represent function and relation arguments using lists of terms.
3. **Mutual recursion:** Define lifting and substitution operations over terms, formulas, and argument lists.
4. **Hilbert-style proof system:** Use 22 logical axiom schemas and two inference rules: modus ponens and generalization.
5. **No Mathlib dependency:** Keep the foundational framework self-contained and make its logical dependencies transparent.

## 3. Current Implementation Status

The research documentation reports the following implementation snapshot, based on Lean 4.12.0:

| Metric | Reported status |
|---|---:|
| Lean source files | 9 |
| Total source lines | 1,064 |
| Definitions, theorems and axioms | 114 |
| Sorry instances | 17 |
| Mathlib dependency | None |
| Build status | Successful |

**Reproducibility note:** These figures describe the documented development snapshot. The public repository must contain the corresponding source files and build configuration before readers can independently reproduce these results.

### 3.1 First-Order Logic (FOL)

The FOL framework includes:

- `ZFC4Lean.FOL.Syntax`
  - Language
  - Term
  - Formula
  - liftTerm / liftFormula
  - substTerm / substFormula
  - Theory

- `ZFC4Lean.FOL.Proof`
  - Hilbert-style proof relation
  - Provable
  - Consistent
  - Independent
  - Weakening theorem
  - Identity theorem
  - Deduction theorem
  - Implication transitivity

- `ZFC4Lean.FOL.Semantics`
  - First-order structures
  - Term evaluation
  - Satisfaction relation
  - Semantic entailment
  - Soundness theorem
  - Consistency from model existence

### 3.2 ZFC Axiomatic System

The project defines a first-order language \(L_{\mathrm{ZFC}}\) containing five function symbols:

- Empty set
- Pairing
- Omega
- Power set
- Union

It also defines membership as its binary relation symbol.

The ten ZFC axioms are represented as explicit first-order sentences or axiom schemas:

1. Extensionality
2. Empty Set
3. Pairing
4. Union
5. Power Set
6. Infinity
7. Foundation
8. Choice
9. Separation Schema
10. Replacement Schema

The project also provides a first-order encoding of the Continuum Hypothesis.

### 3.3 Basic Set Theory

The current documented development includes:

- Ordinal predicates and ordinal comparisons.
- Successor and limit ordinals.
- Cardinal comparisons and equinumerosity.
- Cantor's theorem.
- Schröder–Bernstein theorem.
- Axiom of Choice (AC).
- Well-Ordering Theorem (WO).
- Zorn's Lemma (ZL).

Several associated theorems remain proof obligations.

### 3.4 Proof Status and Axiom Transparency

The current soundness theorem has five reported axiom dependencies:

- `propext`
- `Classical.choice`
- `Quot.sound`
- `satisfies_subst`
- `satisfies_lift`

The first three are standard Lean axioms. The last two are currently declared axioms pending formal proofs in Phase 1.

The documented implementation also contains 17 `sorry` instances across the research phases.

ZFC4Lean explicitly distinguishes:

- Definitions and formal statements.
- Machine-checked proofs.
- Declared axioms.
- Incomplete proofs represented by `sorry`.

The elimination of non-standard admitted assumptions from core theorems is a primary verification objective.

## 4. Research Roadmap

The project follows four research phases.

### Phase 0 — First-Order Logic Framework

**Status: Reported complete**

Objectives:

- Establish first-order syntax.
- Implement the Hilbert proof system.
- Define model-theoretic semantics.
- Establish the soundness framework.
- Formalize the ZFC language and axioms.
- Encode the Continuum Hypothesis.

### Phase 1 — Basic Set Theory

**Status: In progress**

Target: Approximately six months.

Research objectives:

- Prove the semantic substitution lemmas.
- Complete the deduction theorem.
- Establish ordinal trichotomy.
- Prove transfinite induction.
- Formalize Cantor's theorem.
- Prove Schröder–Bernstein.
- Establish AC ↔ WO ↔ ZL.

**Milestone:** Eliminate all remaining `sorry` instances in the FOL and SetTheory modules.

### Phase 2 — Gödel's Constructible Universe

**Status: Planned**

Target: Approximately 18 months.

Research objectives:

- Formalize Δ₀ definability and absoluteness.
- Construct the Jensen J hierarchy.
- Prove that \(L\) is an inner model of ZF.
- Establish the Axiom of Choice in \(L\).
- Formalize the Condensation Lemma.
- Prove \(L \models ZFC + GCH\).
- Establish the corresponding relative consistency result.

**Milestone:** A machine-verified Lean 4 formalization of Gödel's constructible universe.

### Phase 3 — Cohen Forcing and CH Independence

**Status: Planned**

Target: Approximately 36 months.

Research objectives:

- Formalize complete Boolean algebras.
- Construct Boolean-valued models.
- Define the forcing relation.
- Prove the Truth Lemma.
- Formalize Cohen forcing.
- Establish that the resulting model satisfies ZFC and ¬CH.
- Complete the formal independence result:

\[
\operatorname{Independent}(\mathrm{ZFC},\mathrm{CH}).
\]

**Milestone:** A machine-verified Lean 4 formalization of CH independence.

## 5. Verification Standards

Mathematical correctness and proof transparency are central to this project.

The intended verification standards are:

1. **No admitted proofs in core theorems:** Eliminate `sorry` from completed research milestones.
2. **Transparent axiom dependencies:** Audit important theorems using Lean's `#print axioms`.
3. **Minimal foundational assumptions:** Restrict dependencies to documented standard Lean axioms.
4. **Kernel verification:** Verify key results using `lean --trust=0`.
5. **Continuous integration:** Build the project and monitor incomplete proofs through GitHub Actions.

A successful compilation alone is not considered sufficient evidence that a mathematical result has been fully formalized.

## 6. Installation and Usage

### Requirements

- Lean 4.12.0
- elan
- Lake

The project is designed to operate without Mathlib.

### Installation

Once the corresponding source code and build configuration have been published:

```bash
git clone https://github.com/suns1232023/ZFC4Lean.git
cd ZFC4Lean
lake build
```

### Usage Examples

The following examples illustrate the intended API documented for the project. They should be checked against the published source before being treated as executable examples.

**Example 1: ZFC proves extensionality**

```lean
import ZFC4Lean.ZFC.Theory

open ZFC4Lean.ZFC

example : ZFC ⊢ axiom_extensionality :=
  Prf.hyp extensionality_in_ZFC
```

**Example 2: Applying soundness**

```lean
import ZFC4Lean.FOL.Semantics

open ZFC4Lean.FOL

example (h : ZFC ⊢ φ) : ZFC ⊨ φ :=
  soundness h
```

**Example 3: Inspecting theorem dependencies**

```lean
#print axioms soundness
```

This command provides an explicit record of the axioms on which the soundness theorem depends.

## 7. Project Architecture

The documented intended source organization is:

```text
ZFC4Lean/
├── ZFC4Lean/
│   ├── FOL/
│   │   ├── Syntax.lean
│   │   ├── Proof.lean
│   │   └── Semantics.lean
│   ├── ZFC/
│   │   ├── Language.lean
│   │   ├── Axioms.lean
│   │   └── Theory.lean
│   └── SetTheory/
│       ├── Ordinals.lean
│       ├── Cardinals.lean
│       └── ChoiceEquiv.lean
├── ZFC4Lean.lean
├── lakefile.toml
├── lean-toolchain
├── .github/
│   └── workflows/
│       └── lean.yml
├── LICENSE
└── README.md
```

This is the documented target structure and should be synchronized with the actual repository before release.

## 8. Relationship to Existing Work

ZFC4Lean is developed in the context of existing formalization efforts.

| Project | Language | Main contribution |
|---|---|---|
| flypitch | Lean 3 | Formal verification of CH independence |
| Mathlib ZFSet | Lean 4 | Semantic set-theoretic model |
| YesMetaZFC | Lean 4 | Active ZFC metamathematics project |
| ZFLean | Lean 4 | Set-theory interface over Mathlib |
| ZFC4Lean | Lean 4 | Explicit first-order axiomatic framework |

The project builds on the mathematical and formalization foundations established by earlier work, particularly flypitch.

Its intended contributions include a Lean 4 implementation of the explicit axiomatic framework and a research program extending toward Gödel's \(L\) and Cohen forcing.

## 9. Contributing

Contributions from the Lean 4, mathematical logic, and set theory communities are welcome.

Priority areas include:

1. Proving `satisfies_subst` and `satisfies_lift`.
2. Completing the deduction theorem.
3. Proving ordinal trichotomy.
4. Formalizing Cantor's theorem.
5. Proving Schröder–Bernstein.
6. Establishing the equivalence of AC, WO, and ZL.

Contributors are encouraged to open an issue before undertaking major changes, especially those involving the constructible universe or forcing.

All contributions should include:

- Clear mathematical statements.
- Complete Lean proofs where a theorem is claimed as completed.
- Explicit documentation of axiom dependencies.
- Successful build verification.
- Appropriate references to mathematical sources.

## 10. Research Registration and Documentation

The research plan is documented through the Open Science Framework (OSF).

- **OSF Research Registration:** https://osf.io/m47re/overview
- **GitHub Repository:** https://github.com/suns1232023/ZFC4Lean

The OSF registration records the research questions, hypotheses, methodology, milestones, and anticipated outcomes.

The GitHub repository serves as the primary location for source code, proof development, technical documentation, and community collaboration.

## 11. References

1. Han, J. M., & van Doorn, F. (2021). A formal proof of the independence of the continuum hypothesis. *CPP 2020*, 353–366. https://doi.org/10.1145/3372885.3373826

2. Han, J. M., & van Doorn, F. (2019). A formalization of forcing and the unprovability of the continuum hypothesis. *ITP 2019*, LIPIcs 141, 19:1–19:19. https://doi.org/10.4230/LIPIcs.ITP.2019.19

3. Gödel, K. (1938). The consistency of the axiom of choice and of the generalized continuum-hypothesis. *Proceedings of the National Academy of Sciences*, 24(12), 556–557.

4. Cohen, P. J. (1963). The independence of the continuum hypothesis. *Proceedings of the National Academy of Sciences*, 50(6), 1143–1148.

5. Jech, T. (2003). *Set Theory* (3rd millennium ed.). Springer.

6. Kunen, K. (1980). *Set Theory: An Introduction to Independence Proofs*. North-Holland.

7. The Mathlib Community. (2020). The Lean Mathematical Library. *CPP 2020*, 367–381.

---

## License

This project is released under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Acknowledgment

ZFC4Lean builds on the foundational contributions of Gödel, Cohen, Han and van Doorn, and the broader mathematical logic and formal verification communities.

The project welcomes constructive criticism, independent verification, and collaboration toward a transparent, reusable, and machine-checked foundation for axiomatic set theory in Lean 4.
