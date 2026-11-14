
# Research Roadmap

ZFC4Lean is a long-term research project to machine-verify the independence of
the Continuum Hypothesis in Lean 4. The project proceeds in four phases.

---

## Phase 0: FOL Framework ✅ Complete (November 2026)

**Goal**: Establish the explicit first-order logic foundation and ZFC axiom system.

### Completed

- [x] First-order logic syntax (de Bruijn indices, List-based arguments)
- [x] Hilbert-style proof system (22 axiom schemas, modus ponens, generalization)
- [x] Model-theoretic semantics (structures, satisfaction relation)
- [x] **Soundness theorem**: T ⊢ φ → T ⊨ φ (proved for all 22 axiom cases)
- [x] ZFC language L_ZFC (5 function symbols, 1 relation symbol)
- [x] All 10 ZFC axioms as explicit first-order sentences
- [x] Separation and Replacement axiom schemas (parameterized by formula)
- [x] Continuum Hypothesis CH as a first-order sentence
- [x] Ordinal and cardinal predicates (definitions)
- [x] AC, Well-Ordering, Zorn's Lemma (definitions)
- [x] CI configuration (GitHub Actions)

### Build Status

```
lake build  →  Build completed successfully
Lean 4.12.0, no Mathlib dependency
9 source files, 1,064 lines, 114 definitions
17 sorry instances (all labeled with phase TODO)
```

### Axiom Dependencies of Soundness

```
#print axioms soundness
-- propext, Classical.choice, Quot.sound  (standard Lean axioms)
-- satisfies_subst, satisfies_lift         (P1 TODO: prove by induction)
```

---

## Phase 1: Basic Set Theory (Target: May 2027)

**Goal**: Eliminate all sorry instances in FOL and SetTheory modules.
Prove the core theorems of basic set theory within the explicit ZFC framework.

### Mathematical Milestones

- [ ] **Substitution lemmas** (`satisfies_subst`, `satisfies_lift`)
  - Proof by structural induction on Formula
  - Eliminates the two non-standard axiom dependencies from soundness
  - *Highest priority contribution*

- [ ] **Deduction theorem** (gen case)
  - Requires formalizing the variable restriction condition
  - Completes the deduction theorem for sentences

- [ ] **Ordinal trichotomy**
  - For ordinals α, β: α < β ∨ α = β ∨ β < α
  - Proof from Foundation axiom via transfinite induction

- [ ] **Transfinite induction principle**
  - Schema: (∀α (∀β<α P(β)) → P(α)) → ∀α P(α)
  - Proof from Foundation axiom

- [ ] **Cantor's theorem**
  - |A| < |𝒫(A)| for all sets A
  - Proof: diagonal argument (D = {x ∈ A | x ∉ f(x)})

- [ ] **Schröder-Bernstein theorem**
  - |A| ≤ |B| ∧ |B| ≤ |A| → A ≈ B
  - Proof: fixed-point argument; does not require Choice

- [ ] **AC ↔ Well-Ordering ↔ Zorn's Lemma**
  - Three-way equivalence over ZF
  - Proof: transfinite recursion for AC → WO

### Deliverables

- Sorry count: 0 (all sorry instances eliminated)
- Axiom dependencies of soundness: propext, Classical.choice, Quot.sound only
- arXiv preprint: ZFC4Lean framework design and basic set theory results
- ITP 2027 submission

---

## Phase 2: Gödel's Constructible Universe (Target: May 2028)

**Goal**: Formalize Gödel's constructible universe L and prove L ⊨ ZFC + GCH.
This establishes Con(ZF) → Con(ZFC + GCH).

### Mathematical Milestones

- [ ] **Δ₀ formula definability**
  - Define Δ₀ formulas (bounded quantifiers only)
  - Prove absoluteness: Δ₀ formulas are absolute between transitive models

- [ ] **Jensen J hierarchy**
  - J₀ = ∅
  - J_{α+1} = Def(J_α) (Δ₀-definable subsets)
  - J_λ = ⋃_{α<λ} J_α (limit ordinals)

- [ ] **L is an inner model of ZF** (L ⊨ ZF)
  - L ⊨ Extensionality, Pairing, Union, Power Set, Infinity, Foundation
  - L ⊨ Separation (from Δ₀ absoluteness)
  - **L ⊨ Replacement** (hardest step; requires fine-structure analysis)

- [ ] **L satisfies AC** (L ⊨ AC)
  - Construct the canonical well-ordering of L
  - Derive AC from the well-ordering

- [ ] **Condensation Lemma**
  - Every countable elementary substructure of L_α is isomorphic to some L_β
  - Key technical lemma for GCH

- [ ] **L satisfies GCH** (L ⊨ GCH)
  - Use Condensation Lemma to show every real in L appears in some L_α (α countable)
  - Derive 2^{ℵ_α} = ℵ_{α+1} in L

- [ ] **Relative consistency**: Con(ZF) → Con(ZFC + GCH)

### New Modules

```
ZFC4Lean/Constructible/
├── Hierarchy.lean           -- J hierarchy, Δ₀ formulas, absoluteness
├── ConstructibleSet.lean    -- Constructible sets, definability
├── ConstructibleUniverse.lean -- L = ⋃ J_α, L ⊨ ZF, L ⊨ AC
└── GCH.lean                 -- Condensation Lemma, L ⊨ GCH
```

### Deliverables

- First peer-reviewed Lean 4 formalization of Gödel's L
- JSL (Journal of Symbolic Logic) submission

---

## Phase 3: Cohen Forcing and CH Independence (Target: November 2029)

**Goal**: Formalize Cohen's forcing method and prove CH independence.
This is the main long-term goal of the project.

### Mathematical Milestones

- [ ] **Complete Boolean algebras**
  - Define complete Boolean algebras
  - Construct the regular open algebra (Cohen forcing algebra)

- [ ] **Boolean-valued models V^B**
  - Define Boolean-valued sets (bSet)
  - Construct the Boolean-valued universe V^B
  - Define the truth value function [[φ]]_B ∈ B

- [ ] **Forcing relation**
  - Define p ⊩ φ (p forces φ)
  - Prove the Truth Lemma: M[G] ⊨ φ ↔ ∃p∈G, p ⊩ φ

- [ ] **V^B ⊨ ZFC**
  - Verify all ZFC axioms in the Boolean-valued model

- [ ] **Cohen forcing** (adding ℵ₂ reals)
  - Define the Cohen poset Fn(ω × ω₂, 2)
  - Construct the Cohen Boolean algebra
  - Prove the Cohen model satisfies ¬CH

- [ ] **CH independence**
  - Combine L ⊨ CH (from Phase 2, via GCH) and Cohen model ⊨ ¬CH
  - Prove: `independence_of_CH : Independent ZFC CH`

### New Modules

```
ZFC4Lean/Forcing/
├── PartialOrder.lean        -- Partial orders, dense sets, filters
├── GenericFilter.lean       -- Generic filters, ground models
├── Names.lean               -- Forcing names (Boolean-valued sets)
├── ForcingRelation.lean     -- Forcing relation, Truth Lemma
└── CHIndependence.lean      -- Cohen forcing, independence_of_CH
```

### Deliverables

- First peer-reviewed Lean 4 proof of CH independence
- `independence_of_CH : Independent ZFC CH` with axiom dependencies:
  propext, Classical.choice, Quot.sound only
- JSL (Journal of Symbolic Logic) publication

---

## Publication Strategy

| Phase | Target Venue | Paper Title (Planned) | Timeline |
|-------|-------------|----------------------|----------|
| P0+P1 | ITP 2027 | ZFC4Lean: An Explicit Axiomatic Foundation for Set Theory in Lean 4 | May 2027 |
| P2 | JSL | Formalizing Gödel's Constructible Universe in Lean 4 | May 2028 |
| P3 | JSL | A Lean 4 Proof of the Independence of the Continuum Hypothesis | Nov 2029 |

---

## Related Work

| Project | Language | Relation to ZFC4Lean |
|---------|----------|---------------------|
| [flypitch](https://github.com/flypitch/flypitch) | Lean 3 (archived) | Primary technical reference; same approach, different language |
| [Mathlib4 ZFSet](https://github.com/leanprover-community/mathlib4) | Lean 4 | Semantic ZFC model; ZFC4Lean provides the syntactic system |
| [YesMetaZFC](https://github.com/lanxinge/YesMetaZFC) | Lean 4 | Similar goals; no peer-reviewed publications yet |
| [ZFLean](https://arxiv.org/abs/2604.24195) | Lean 4 | Ergonomics layer over Mathlib ZFSet; different approach |

---

## OSF Preregistration

This research plan is preregistered on OSF:
- **OSF Project**: https://osf.io/ZFC4Lean *(link pending)*
- **Registration Date**: 2026-11-13
- **Registration Type**: Open-Ended Registration (Research Underway)
