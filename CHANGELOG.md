
# Changelog

All notable changes to ZFC4Lean are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.1.0] — 2026-11-13

### Phase 0: FOL Framework — Initial Release

#### Added

**FOL/Syntax.lean**
- `Language` structure: function and relation symbols indexed by arity
- `Term` inductive type: de Bruijn indexed variables + List-based function application
- `Formula` inductive type: rel, eq, falsum, neg, and, or, imp, all, ex
- `liftTerm` / `liftTermList`: variable lifting via mutual recursion
- `substTerm` / `substTermList`: substitution via mutual recursion
- `Formula.lift`: formula variable lifting
- `Formula.subst`: formula substitution
- `Theory`: predicate on formulas (set of formulas)
- Notation: ⊥ₗ, ⊤ₗ, ¬ₗ, ∧ₗ, ∨ₗ, →ₗ, ↔ₗ, ∀ₗ, ∃ₗ

**FOL/Proof.lean**
- `Prf` inductive type: Hilbert-style proof relation with 22 axiom schemas
  - Propositional: ax_K, ax_S, ax_dne, ax_expl, ax_neg_i, ax_neg_e,
    ax_and_i, ax_and_l, ax_and_r, ax_or_l, ax_or_r, ax_or_e
  - Quantifier: ax_all_inst, ax_all_dist, ax_ex_intro, ax_ex_elim
  - Equality: ax_eq_refl, ax_eq_subst
  - Inference rules: hyp, mp, gen
- `Provable` (T ⊢ φ): syntactic provability
- `Consistent`: consistency predicate
- `Independent`: independence predicate
- `Prf.weakening`: weakening theorem (proved)
- `Prf.id_proof`: identity theorem φ → φ (proved)
- `Prf.extendWith`: theory extension helper
- `Prf.deduction`: deduction theorem (proved; gen case uses sorry — P1 TODO)
- `Prf.imp_trans`: implication transitivity (proved)

**FOL/Semantics.lean**
- `Structure`: first-order structures with carrier, funInterp, relInterp
- `Assignment`: variable assignment type
- `consAssign`: assignment extension
- `evalTerm` / `evalTermList`: term evaluation via mutual recursion
- `satisfies`: satisfaction relation for all 9 formula constructors
- `isTrue`: truth in a structure
- `modelsTheory`: model relation
- `Entails` (T ⊨ φ): semantic entailment
- `soundness`: **Soundness theorem T ⊢ φ → T ⊨ φ** (proved for all 22 cases)
- `satisfies_subst`: substitution lemma (declared as axiom — P1 TODO)
- `satisfies_lift`: lift lemma (declared as axiom — P1 TODO)
- `consistent_of_model`: consistency from model existence (proved)

**ZFC/Language.lean**
- `ZFCFunc`: 5 function symbols (empty, pair, omega, powerset, union)
- `ZFCRel`: 1 relation symbol (mem / ∈)
- `L_ZFC`: the ZFC first-order language
- Term constructors: `x`, `empty`, `pair`, `omega`, `powerset`, `union`
- Formula constructors: `mem`, `eq`, `subset`
- Derived constructors: `singleton`, `orderedPair`, `succ`

**ZFC/Axioms.lean**
- `axiom_extensionality`: ∀x∀y (∀z (z∈x ↔ z∈y) → x=y)
- `axiom_empty_set`: ∀x (x ∉ ∅)
- `axiom_pairing`: ∀x∀y∀z (z ∈ {x,y} ↔ z=x ∨ z=y)
- `axiom_union`: ∀F∀x (x ∈ ⋃F ↔ ∃y (x∈y ∧ y∈F))
- `axiom_powerset`: ∀x∀y (y ∈ 𝒫(x) ↔ y⊆x)
- `axiom_infinity`: ∅∈ω ∧ ∀x (x∈ω → S(x)∈ω)
- `axiom_foundation`: ∀x (∃y (y∈x) → ∃y∈x ∀z∈y (z∉x))
- `axiom_choice`: choice function existence
- `axiom_separation`: separation schema (parameterized by formula)
- `axiom_replacement`: replacement schema (parameterized by formula)
- `ZFC`: the ZFC theory as a predicate
- `CH`: the Continuum Hypothesis as a first-order sentence
- Membership lemmas for all 10 axioms

**ZFC/Theory.lean**
- `zfc_proves_extensionality`, `zfc_proves_empty_has_no_elements`
- `zfc_proves_separation`, `zfc_proves_replacement`
- `zfc_proves_infinity`, `zfc_proves_choice`
- `CH_independent`: statement with sorry placeholders (P2/P3 TODO)
- `ZF`: ZFC without choice
- `relative_consistency_ZFC`: statement with sorry (P2 TODO)
- `GCH`: Generalized Continuum Hypothesis placeholder
- `relative_consistency_GCH`: statement with sorry (P2 TODO)

**SetTheory/Ordinals.lean**
- `IsTransitive`, `MemIrrefl`, `MemTotal`, `IsOrdinal`: ordinal predicates
- `OrdinalLt`, `OrdinalLe`: ordinal comparison
- `ordinal_trichotomy`: statement with sorry (P1 TODO)
- `transfinite_induction`: schema statement with sorry (P1 TODO)
- `IsSuccessor`, `IsLimit`: successor/limit ordinal predicates
- `omega_is_limit`: statement with sorry (P1 TODO)

**SetTheory/Cardinals.lean**
- `Equinumerous`, `CardinalLe`, `CardinalLt`: cardinal comparison
- `IsCardinal`: initial ordinal predicate
- `cantor_theorem`: statement with sorry (P1 TODO)
- `schroeder_bernstein`: statement with sorry (P1 TODO)
- `aleph0`: ℵ₀ = ω
- `konig_special`: ℵ₀ < 2^{ℵ₀}, statement with sorry (P1 TODO)

**SetTheory/ChoiceEquiv.lean**
- `AC`, `WO`, `ZL`: Axiom of Choice, Well-Ordering, Zorn's Lemma
- `ZF`: ZFC without choice
- `AC_implies_WO`, `WO_implies_ZL`, `ZL_implies_AC`: statements with sorry (P1 TODO)
- `AC_WO_ZL_equivalent`: partial proof

**Project infrastructure**
- `lakefile.toml`: Lake build configuration (no Mathlib dependency)
- `lean-toolchain`: Lean 4.12.0
- `ZFC4Lean.lean`: main entry point
- `.github/workflows/lean.yml`: CI with sorry count reporting
- `scripts/check_soundness.lean`: axiom dependency verification script

#### Build Status
- Build: successful (lake build, Lean 4.12.0)
- Sorry count: 17 (all labeled with phase TODO markers)
- Soundness axiom dependencies: propext, Classical.choice, Quot.sound,
  satisfies_subst, satisfies_lift

---

## Planned Releases

### [0.2.0] — Phase 1: Basic Set Theory (Target: May 2027)
- Prove substitution lemmas (satisfies_subst, satisfies_lift)
- Complete deduction theorem (gen case)
- Ordinal trichotomy from Foundation axiom
- Transfinite induction principle
- Cantor's theorem (diagonal argument)
- Schröder-Bernstein theorem
- AC ↔ Well-Ordering ↔ Zorn's Lemma
- Sorry count target: 0

### [0.3.0] — Phase 2: Gödel's Constructible Universe (Target: May 2028)
- Δ₀ formula definability and absoluteness
- Jensen J hierarchy
- L ⊨ ZF (including replacement — hardest step)
- L ⊨ AC (canonical well-ordering)
- Condensation Lemma
- L ⊨ GCH
- Con(ZF) → Con(ZFC + GCH)

### [1.0.0] — Phase 3: CH Independence (Target: November 2029)
- Complete Boolean algebras
- Boolean-valued models V^B
- Forcing relation and Truth Lemma
- Cohen forcing (adding ℵ₂ reals)
- V^B ⊨ ZFC
- independence_of_CH : Independent ZFC CH
