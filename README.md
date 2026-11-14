# ZFC4Lean
 
**An Explicit First-Order Axiomatic Foundation for Set Theory in Lean 4**
 
[![Lean 4](https://img.shields.io/badge/Lean-4.14.0-blue)](https://lean-lang.org/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache--2.0-green.svg)](LICENSE)
[![Research](https://img.shields.io/badge/Research-Active-orange.svg)](https://osf.io/m47re/overview)
[![Preprint](https://img.shields.io/badge/Preprint-Zenodo-blue.svg)](https://zenodo.org/records/24215064)
 
**ZFC4Lean** is a research project to formalize Zermelo–Fraenkel set theory with the Axiom of Choice (ZFC) as an explicit first-order axiomatic system in Lean 4.
 
Unlike semantic set-theoretic models developed within Lean's type theory (such as Mathlib's `ZFSet`), ZFC4Lean provides a syntactic framework in which the language, axioms, proof system, and model-theoretic semantics of ZFC are explicitly represented as Lean objects. This enables metamathematical reasoning — about provability, consistency, and independence — to be stated and studied as Lean propositions.
 
The long-term research objective is to develop a machine-verified Lean 4 formalization of Gödel's constructible universe L, Cohen forcing, and the independence of the Continuum Hypothesis (CH) from ZFC.
 
**Research status:** Phase 0 complete; Phase 1 in progress. The full formalization of L and CH independence remains planned research.
 
---
 
## 1. Research Motivation
 
The Continuum Hypothesis (CH) asks whether there exists a cardinal strictly between the cardinality of the natural numbers and the cardinality of the real numbers:
 
$$2^{\aleph_0} = \aleph_1$$
 
Gödel and Cohen established that CH is independent of ZFC, assuming ZFC is consistent:
 
- **Gödel (1938):** The constructible universe L provides a model of ZFC + GCH, establishing the relative consistency of CH.
- **Cohen (1963):** The forcing method establishes the relative consistency of ¬CH. Cohen received the Fields Medal in 1966 for this work.
 
The formal verification of these results is a significant challenge in mathematical logic and interactive theorem proving. The Lean 3 project *flypitch* (Han & van Doorn, CPP 2020) established an important precedent by formalizing CH independence using Boolean-valued models. ZFC4Lean pursues a related program in Lean 4.
 
---
 
## 2. Mathematical Approach
 
### 2.1 Explicit First-Order Logic
 
ZFC4Lean defines its own first-order language and proof system within Lean 4. The framework includes:
 
- First-order terms and formulas (using de Bruijn indices)
- Variable lifting and substitution (via mutual recursion)
- A Hilbert-style deductive system with 18 axiom schemas
- Syntactic provability, consistency, and independence
- First-order structures and model-theoretic satisfaction
- Semantic entailment and a soundness theorem
 
### 2.2 Syntactic and Semantic Approaches
 
An important distinction is the difference between formalizing mathematics inside a set-theoretic model and formalizing the axiomatic system itself.
 
| Feature | Mathlib4 ZFSet | ZFC4Lean |
|---|---|---|
| Foundation | Lean type theory (CIC) | Explicit first-order logic |
| ZFC axioms | Represented through a constructed model within Lean's type theory | Explicit first-order sentences |
| Choice axiom | From `Classical.choice` | Explicit axiom |
| Proof approach | Mathematics within a set model | Syntactic derivations |
| Main objective | General set-theoretic mathematics | Metamathematics of ZFC |
 
These approaches address different formalization objectives and are intended to be complementary.
 
### 2.3 Design Decisions
 
The framework adopts five principal design decisions:
 
1. **de Bruijn indices:** Represent bound variables using natural-number indices to avoid variable capture.
2. **List-based arguments:** Use `List (Term L)` rather than `Fin n → Term L` to enable structural recursion without termination proof obligations.
3. **Mutual recursion:** Define lifting and substitution operations via `mutual` blocks over terms, formulas, and argument lists.
4. **Hilbert-style proof system:** 18 axiom schemas (12 propositional, 4 quantifier, 2 equality) and two inference rules: modus ponens and generalization.
5. **No Mathlib dependency:** Keep the foundational framework self-contained and make its logical dependencies transparent.
 
---
 
## 3. Current Implementation Status
 
**Lean toolchain:** `leanprover/lean4:v4.14.0` (see `lean-toolchain`)
**Mathlib dependency:** None
**Build:** `lake build` (no external dependencies required)
 
| Metric | Value |
|---|---:|
| Lean source files | 9 |
| Total source lines | ~1,064 |
| Definitions, theorems, and axioms | 114 |
| `sorry` instances | 17 |
| Declared non-standard axioms | 2 (`satisfies_subst`, `satisfies_lift`) |
 
> **Note on Lean version:** The repository previously referenced Lean 4.12.0 in documentation. The actual toolchain is `leanprover/lean4:v4.14.0` as specified in `lean-toolchain`.
 
> **Note on axiom schemas:** The Hilbert proof system contains 18 axiom schemas (12 propositional + 4 quantifier + 2 equality), plus 3 inference rule constructors (hyp, mp, gen). Earlier documentation incorrectly stated 22.
 
### 3.1 First-Order Logic (FOL)
 
The FOL framework includes:
 
**`ZFC4Lean.FOL.Syntax`**
- `Language`, `Term`, `Formula`, `Theory` — Defined
- `liftTerm` / `liftTermList` / `liftFormula` — Defined (mutual recursion)
- `substTerm` / `substTermList` / `substFormula` — Defined (mutual recursion)
 
**`ZFC4Lean.FOL.Proof`**
- `Prf` — Defined (Hilbert-style proof relation, 18 axiom schemas)
- `Provable` (`T ⊢ φ`), `Consistent`, `Independent` — Defined
- `Prf.weakening`, `Prf.id_proof`, `Prf.imp_trans` — Kernel-checked
- `Prf.deduction` — Kernel-checked for mp/hyp/axiom cases; gen case Pending (Phase 1)
 
**`ZFC4Lean.FOL.Semantics`**
- `Structure`, `Assignment`, `consAssign` — Defined
- `evalTerm` / `evalTermList` — Defined (mutual recursion)
- `satisfies` — Defined (satisfaction relation, 9 cases)
- `satisfies_subst` — Declared axiom (Phase 1 TODO)
- `satisfies_lift` — Declared axiom (Phase 1 TODO)
- `soundness` (`T ⊢ φ → T ⊨ φ`) — Project-axiom-dependent
- `consistent_of_model` — Project-axiom-dependent
 
### 3.2 ZFC Axiomatic System
 
The project defines a first-order language L_ZFC containing five function symbols (∅, {·,·}, ω, 𝒫, ⋃) and one binary relation symbol (∈).
 
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
 
The project also provides a first-order encoding of the Continuum Hypothesis. A formal adequacy lemma connecting this syntax to the intended cardinal semantics remains future work.
 
### 3.3 Basic Set Theory
 
The current documented development includes:
 
- Ordinal predicates and ordinal comparisons — Defined
- Successor and limit ordinals — Defined
- Cardinal comparisons and equinumerosity — Defined
- Cantor's theorem — Pending (Phase 1)
- Schröder–Bernstein theorem — Pending (Phase 1)
- Axiom of Choice (AC), Well-Ordering Theorem (WO), Zorn's Lemma (ZL) — Defined; equivalences Pending (Phase 1)
 
Several associated theorems remain proof obligations.
 
### 3.4 Proof Status and Axiom Transparency
 
ZFC4Lean uses a five-level taxonomy for verification status:
 
| Status | Meaning |
|---|---|
| **Defined** | Lean definition/type accepted; not a theorem proof |
| **Kernel-checked** | Complete proof, no `sorry`, standard Lean axioms only |
| **Project-axiom-dependent** | Complete proof, but depends on declared non-standard axioms |
| **Partial** | Proof exists but contains `sorry` in some cases |
| **Pending** | Theorem stated; main proof not yet provided |
 
The current soundness theorem has five axiom dependencies (from `#print axioms soundness`):
 
- `propext` — standard Lean axiom
- `Classical.choice` — standard Lean axiom
- `Quot.sound` — standard Lean axiom
- `satisfies_subst` — declared axiom (Phase 1 TODO)
- `satisfies_lift` — declared axiom (Phase 1 TODO)
 
The first three are standard Lean axioms. The last two are currently declared axioms pending formal proofs in Phase 1. Once proved, the soundness theorem will depend only on the three standard axioms.
 
The documented implementation also contains 17 `sorry` instances across the research phases:
 
| Phase | Count | Location |
|---|---|---|
| P1 | 12 | FOL/Proof.lean (gen case), SetTheory modules, ZFC/Theory.lean (Con ZF→Con ZFC) |
| P2 | 3 | ZFC/Theory.lean (GCH, CH_independent direction 1, Con ZFC→Con ZFC+GCH) |
| P3 | 1 | ZFC/Theory.lean (CH_independent direction 2) |
 
ZFC4Lean explicitly distinguishes:
 
- Definitions and formal statements
- Machine-checked proofs (Kernel-checked)
- Declared axioms (Project-axiom-dependent)
- Incomplete proofs represented by `sorry` (Partial / Pending)
 
The elimination of non-standard admitted assumptions from core theorems is a primary verification objective.
 
> **Important:** A successful `lake build` confirms type consistency and kernel acceptance of non-sorry proofs. It does not verify the mathematical content of `sorry` placeholders or the mathematical truth of declared axioms.
 
---
 
## 4. Research Roadmap
 
The project follows four research phases.
 
### Phase 0 — First-Order Logic Framework
 
**Status: Complete**
 
Objectives:
 
- Establish first-order syntax (de Bruijn indices, List-based arguments)
- Implement the Hilbert proof system (18 axiom schemas)
- Define model-theoretic semantics
- Establish the soundness framework
- Formalize the ZFC language and axioms
- Encode the Continuum Hypothesis
 
### Phase 1 — Basic Set Theory
 
**Status: In progress**
 
Target: Approximately six months.
 
Research objectives:
 
- Prove `satisfies_subst` and `satisfies_lift` (structural induction on `Formula`)
- Complete the deduction theorem (gen case: variable restriction condition)
- Establish ordinal trichotomy from the Foundation axiom
- Prove transfinite induction
- Formalize Cantor's theorem (diagonal argument)
- Prove Schröder–Bernstein (fixed-point argument, no Choice)
- Establish AC ↔ WO ↔ ZL
 
**Milestone:** Eliminate all remaining `sorry` instances in the FOL and SetTheory modules; soundness theorem depends only on standard Lean axioms.
 
### Phase 2 — Gödel's Constructible Universe
 
**Status: Planned**
 
Target: Approximately 18 months.
 
Research objectives:
 
- Formalize Δ₀ definability and absoluteness
- Construct the Jensen J hierarchy
- Prove that L is an inner model of ZF (including Replacement — the hardest step)
- Establish the Axiom of Choice in L via the canonical well-ordering
- Formalize the Condensation Lemma
- Prove L ⊨ ZFC + GCH
- Establish the corresponding relative consistency result: Con(ZF) → Con(ZFC + GCH)
 
**Milestone:** A transparent and independently auditable Lean 4 formalization of Gödel's constructible universe.
 
### Phase 3 — Cohen Forcing and CH Independence
 
**Status: Planned**
 
Target: Approximately 36 months.
 
Research objectives:
 
- Formalize complete Boolean algebras
- Construct Boolean-valued models V^B
- Define the forcing relation and prove the Truth Lemma
- Formalize Cohen forcing (adding ℵ₂ reals)
- Establish that the resulting model satisfies ZFC and ¬CH
- Complete the formal independence result: `independence_of_CH : Independent ZFC CH`
 
**Milestone:** A fully audited Lean 4 proof of CH independence within the ZFC4Lean framework.
 
---
 
## 5. Verification Standards
 
Mathematical correctness and proof transparency are central to this project.
 
The intended verification standards are:
 
1. **No admitted proofs in core theorems:** Eliminate `sorry` from completed research milestones.
2. **Transparent axiom dependencies:** Audit important theorems using Lean's `#print axioms`.
3. **Minimal foundational assumptions:** Restrict dependencies to documented standard Lean axioms.
4. **Kernel verification:** Verify key results using `lean --trust=0`.
5. **Continuous integration:** Build the project and monitor incomplete proofs through GitHub Actions.
 
A successful compilation alone is not considered sufficient evidence that a mathematical result has been fully formalized.
 
---
 
## 6. Installation and Usage
 
### Requirements
 
- Lean 4.14.0 (install via [elan](https://github.com/leanprover/elan))
- Lake (included with Lean)
 
The project is designed to operate without Mathlib.
 
### Installation
 
```bash
git clone https://github.com/suns1232023/ZFC4Lean.git
cd ZFC4Lean
lake build
```
 
### Usage Examples
 
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
-- 'ZFC4Lean.FOL.soundness' depends on axioms:
-- [propext, Classical.choice, Quot.sound,
--  ZFC4Lean.FOL.satisfies_subst,
--  ZFC4Lean.FOL.satisfies_lift]
```
 
---
 
## 7. Project Architecture
 
The documented source organization is:
 
```text
ZFC4Lean/
├── ZFC4Lean/
│   ├── FOL/
│   │   ├── Syntax.lean       -- Language, Term, Formula, lift/subst
│   │   ├── Proof.lean        -- Hilbert system, Prf, Provable, Consistent
│   │   └── Semantics.lean    -- Structure, satisfies, soundness
│   ├── ZFC/
│   │   ├── Language.lean     -- L_ZFC: 5 function symbols + ∈
│   │   ├── Axioms.lean       -- All 10 ZFC axioms + CH
│   │   └── Theory.lean       -- Basic derivations, independence goals
│   └── SetTheory/
│       ├── Ordinals.lean     -- Ordinal predicates
│       ├── Cardinals.lean    -- Cardinal predicates, Cantor, S-B
│       └── ChoiceEquiv.lean  -- AC, WO, ZL and equivalences
├── ZFC4Lean.lean             -- Main entry point
├── lakefile.toml             -- Lake configuration (no Mathlib)
├── lean-toolchain            -- leanprover/lean4:v4.14.0
├── PROOF_STATUS.md           -- Detailed proof status tracking
├── ROADMAP.md                -- Research roadmap
├── CONTRIBUTING.md           -- Contribution guidelines
├── CHANGELOG.md              -- Version history
├── docs/                     -- Additional documentation
│   ├── AXIOM_AUDIT.md
│   ├── MATHEMATICAL_FOUNDATIONS.md
│   ├── FORMALIZATION_DESIGN.md
│   └── REFERENCES.md
├── LICENSE                   -- Apache 2.0
└── README.md
```
 
---
 
## 8. Relationship to Existing Work
 
ZFC4Lean is developed in the context of existing formalization efforts.
 
| Project | Language | Main contribution | Status |
|---|---|---|---|
| [flypitch](https://github.com/flypitch/flypitch) | Lean 3 | Formal verification of CH independence (CPP 2020) | Completed |
| [Mathlib ZFSet](https://github.com/leanprover-community/mathlib4) | Lean 4 | Semantic set-theoretic model | Active |
| [YesMetaZFC](https://github.com/lanxinge/YesMetaZFC) | Lean 4 | Active ZFC metamathematics project | Active |
| [ZFLean](https://arxiv.org/abs/2604.24195) | Lean 4 | Set-theory interface over Mathlib | Active |
| **ZFC4Lean** | **Lean 4** | **Explicit first-order axiomatic framework** | **Active** |
 
The project builds on the mathematical and formalization foundations established by earlier work, particularly flypitch. ZFC4Lean follows the same syntactic approach (explicit FOL language, Hilbert proof system) but is redesigned for Lean 4 and extended to include Gödel's L (which flypitch did not formalize). ZFC4Lean and Mathlib's `ZFSet` are complementary: the former targets metamathematical formalization, the latter targets set-theoretic mathematics.
 
---
 
## 9. Contributing
 
Contributions from the Lean 4, mathematical logic, and set theory communities are welcome.
 
Priority areas include:
 
1. **Highest priority:** Proving `satisfies_subst` and `satisfies_lift` (structural induction on `Formula`) — this eliminates the two non-standard axiom dependencies from the soundness theorem.
2. Completing the deduction theorem gen case (variable restriction condition in de Bruijn setting).
3. Proving ordinal trichotomy from the Foundation axiom.
4. Formalizing Cantor's theorem (diagonal argument).
5. Proving Schröder–Bernstein (fixed-point argument, no Choice).
6. Establishing the equivalence of AC, WO, and ZL.
 
Contributors are encouraged to open an issue before undertaking major changes, especially those involving the constructible universe or forcing.
 
All contributions should include:
 
- Clear mathematical statements
- Complete Lean proofs where a theorem is claimed as completed
- Explicit documentation of axiom dependencies (via `#print axioms`)
- Successful build verification (`lake build`)
- Appropriate references to mathematical sources
 
See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines and verification standards.
 
---
 
## 10. Research Registration and Documentation
 
The research plan is documented through the Open Science Framework (OSF).
 
- **OSF Research Registration:** https://osf.io/m47re/overview
- **GitHub Repository:** https://github.com/suns1232023/ZFC4Lean
- **Zenodo Preprint:** https://zenodo.org/records/24215064
 
The OSF registration records the research questions, hypotheses, methodology, milestones, and anticipated outcomes.
 
The GitHub repository serves as the primary location for source code, proof development, technical documentation, and community collaboration.
 
---
 
## 11. References
 
1. Han, J. M., & van Doorn, F. (2020). A formal proof of the independence of the continuum hypothesis. *CPP 2020*, 353–366. https://doi.org/10.1145/3372885.3373826
2. Han, J. M., & van Doorn, F. (2019). A formalization of forcing and the unprovability of the continuum hypothesis. *ITP 2019*, LIPIcs 141, 19:1–19:19. https://doi.org/10.4230/LIPIcs.ITP.2019.19
3. Gödel, K. (1938). The consistency of the axiom of choice and of the generalized continuum-hypothesis. *Proceedings of the National Academy of Sciences*, 24(12), 556–557.
4. Cohen, P. J. (1963). The independence of the continuum hypothesis. *Proceedings of the National Academy of Sciences*, 50(6), 1143–1148.
5. Jech, T. (2003). *Set Theory* (3rd millennium ed.). Springer.
6. Kunen, K. (1980). *Set Theory: An Introduction to Independence Proofs*. North-Holland.
7. The Mathlib Community. (2020). The Lean Mathematical Library. *CPP 2020*, 367–381.
 
---
 
## License
 
This project is released under the Apache License 2.0. See [LICENSE](LICENSE) for details.
 
---
 
## Acknowledgment
 
ZFC4Lean builds on the foundational contributions of Gödel, Cohen, Han and van Doorn, and the broader mathematical logic and formal verification communities.
 
The project welcomes constructive criticism, independent verification, and collaboration toward a transparent, reusable, and machine-checked foundation for axiomatic set theory in Lean 4.
 
---
 
## Citation
 
```bibtex
@misc{zfc4lean2026,
  title  = {{ZFC4Lean}: An Explicit First-Order Axiomatic Foundation
             for Set Theory in {Lean 4}},
  author = {Sun, Scott},
  year   = {2026},
  url    = {https://github.com/suns1232023/ZFC4Lean},
  note   = {OSF Registration: https://osf.io/m47re/overview.
             Preprint: https://zenodo.org/records/24215064}
}
```
 
---
 
*Author: Scott Sun (Independent Researcher) | ORCID: 0009-0002-1095-6228*
 
