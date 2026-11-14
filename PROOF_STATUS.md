
# Proof Status

This file tracks the proof status of every theorem and key definition in ZFC4Lean.

**Last updated**: 2026-11-13 (v0.1.0)

**Legend**:
- ✅ `proved` — complete machine-verified proof, no sorry
- ⚠️ `axiom` — declared as axiom, proof planned (see phase label)
- 🔲 `sorry` — placeholder proof, to be completed (see phase label)
- 📋 `statement` — theorem stated, proof not yet started
- 🏗️ `planned` — module not yet created

---

## Axiom Audit

The following non-standard axioms are currently in use. All are explicitly
declared with `axiom` (not `sorry`) and have clear proof obligations.

| Axiom | File | Phase | Mathematical Content |
|-------|------|-------|---------------------|
| `satisfies_subst` | FOL/Semantics.lean | P1 | satisfies σ (φ.subst t 0) ↔ satisfies (consAssign (evalTerm σ t) σ) φ |
| `satisfies_lift` | FOL/Semantics.lean | P1 | satisfies (consAssign a σ) (φ.lift 0 1) ↔ satisfies σ φ |

**Soundness axiom dependencies** (from `#print axioms soundness`):
```
propext            -- standard Lean axiom
Classical.choice   -- standard Lean axiom
Quot.sound         -- standard Lean axiom
satisfies_subst    -- declared axiom (P1 TODO)
satisfies_lift     -- declared axiom (P1 TODO)
```

---

## FOL/Syntax.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `Language` | ✅ proved | Structure definition |
| `Term` | ✅ proved | Inductive type with de Bruijn indices |
| `liftTerm` | ✅ proved | Mutual recursion with liftTermList |
| `liftTermList` | ✅ proved | Mutual recursion with liftTerm |
| `substTerm` | ✅ proved | Mutual recursion with substTermList |
| `substTermList` | ✅ proved | Mutual recursion with substTerm |
| `Formula` | ✅ proved | Inductive type |
| `Formula.iff` | ✅ proved | Defined as (φ→ψ)∧(ψ→φ) |
| `Formula.verum` | ✅ proved | Defined as ¬⊥ |
| `liftFormula` | ✅ proved | Mutual recursion |
| `substFormula` | ✅ proved | Mutual recursion |
| `Term.lift` | ✅ proved | Wrapper for liftTerm |
| `Term.subst` | ✅ proved | Wrapper for substTerm |
| `Formula.lift` | ✅ proved | Wrapper for liftFormula |
| `Formula.subst` | ✅ proved | Wrapper for substFormula |
| `Theory` | ✅ proved | Type alias |

---

## FOL/Proof.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `Prf` (22 axiom schemas) | ✅ proved | Hilbert-style proof relation |
| `Provable` (T ⊢ φ) | ✅ proved | Definition |
| `Consistent` | ✅ proved | Definition |
| `Independent` | ✅ proved | Definition |
| `Prf.weakening` | ✅ proved | Γ ⊆ Δ → Prf Γ φ → Prf Δ φ |
| `Prf.id_proof` | ✅ proved | Prf Γ (φ →ₗ φ) |
| `Prf.extendWith` | ✅ proved | Theory extension helper |
| `Prf.deduction` (mp/hyp cases) | ✅ proved | All cases except gen |
| `Prf.deduction` (gen case) | 🔲 sorry | P1: requires variable restriction condition |
| `Prf.imp_trans` | ✅ proved | Transitivity of implication |

---

## FOL/Semantics.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `Structure` | ✅ proved | First-order structure |
| `Assignment` | ✅ proved | Type alias |
| `consAssign` | ✅ proved | Assignment extension |
| `evalTerm` | ✅ proved | Mutual recursion with evalTermList |
| `evalTermList` | ✅ proved | Mutual recursion with evalTerm |
| `satisfies` | ✅ proved | Satisfaction relation |
| `isTrue` | ✅ proved | Truth in a structure |
| `modelsTheory` | ✅ proved | Model relation |
| `Entails` (T ⊨ φ) | ✅ proved | Semantic entailment |
| `satisfies_subst` | ⚠️ axiom | P1: structural induction on Formula |
| `satisfies_lift` | ⚠️ axiom | P1: structural induction on Formula |
| `soundness` (T ⊢ φ → T ⊨ φ) | ✅ proved | All 22 axiom cases; depends on 2 axioms above |
| `consistent_of_model` | ✅ proved | Consistency from model existence |

---

## ZFC/Language.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `ZFCFunc` | ✅ proved | 5 function symbols |
| `ZFCRel` | ✅ proved | 1 relation symbol (∈) |
| `L_ZFC` | ✅ proved | ZFC language |
| `L_ZFC.x`, `empty`, `pair`, `omega`, `powerset`, `union` | ✅ proved | Term constructors |
| `L_ZFC.mem`, `eq`, `subset` | ✅ proved | Formula constructors |
| `L_ZFC.singleton`, `orderedPair`, `succ` | ✅ proved | Derived constructors |

---

## ZFC/Axioms.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `axiom_extensionality` | ✅ proved | Formalized as FOL sentence |
| `axiom_empty_set` | ✅ proved | Formalized as FOL sentence |
| `axiom_pairing` | ✅ proved | Formalized as FOL sentence |
| `axiom_union` | ✅ proved | Formalized as FOL sentence |
| `axiom_powerset` | ✅ proved | Formalized as FOL sentence |
| `axiom_infinity` | ✅ proved | Formalized as FOL sentence |
| `axiom_foundation` | ✅ proved | Formalized as FOL sentence |
| `axiom_choice` | ✅ proved | Formalized as FOL sentence |
| `axiom_separation` (schema) | ✅ proved | Parameterized by Formula |
| `axiom_replacement` (schema) | ✅ proved | Parameterized by Formula |
| `ZFC` (theory predicate) | ✅ proved | Union of all axioms |
| `CH` | ✅ proved | Continuum Hypothesis as FOL sentence |
| `extensionality_in_ZFC` | ✅ proved | ZFC axiom_extensionality |
| `empty_set_in_ZFC` | ✅ proved | ZFC axiom_empty_set |
| `pairing_in_ZFC` | ✅ proved | ZFC axiom_pairing |
| `union_in_ZFC` | ✅ proved | ZFC axiom_union |
| `powerset_in_ZFC` | ✅ proved | ZFC axiom_powerset |
| `infinity_in_ZFC` | ✅ proved | ZFC axiom_infinity |
| `foundation_in_ZFC` | ✅ proved | ZFC axiom_foundation |
| `choice_in_ZFC` | ✅ proved | ZFC axiom_choice |
| `separation_in_ZFC` | ✅ proved | ∀φ, ZFC (axiom_separation φ) |
| `replacement_in_ZFC` | ✅ proved | ∀φ, ZFC (axiom_replacement φ) |

---

## ZFC/Theory.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `zfc_proves_extensionality` | ✅ proved | ZFC ⊢ axiom_extensionality |
| `zfc_proves_empty_has_no_elements` | ✅ proved | ZFC ⊢ ∀x (x∉∅) |
| `zfc_proves_separation` | ✅ proved | ∀φ, ZFC ⊢ axiom_separation φ |
| `zfc_proves_replacement` | ✅ proved | ∀φ, ZFC ⊢ axiom_replacement φ |
| `zfc_proves_infinity` | ✅ proved | ZFC ⊢ axiom_infinity |
| `zfc_proves_choice` | ✅ proved | ZFC ⊢ axiom_choice |
| `CH_independent` | 🔲 sorry | P2 (¬CH direction) + P3 (CH direction) |
| `ZF` (without choice) | ✅ proved | Definition |
| `relative_consistency_ZFC` | 🔲 sorry | P2: Con(ZF) → Con(ZFC) via L |
| `GCH` | ✅ proved | Placeholder formulation |
| `relative_consistency_GCH` | 🔲 sorry | P2: Con(ZFC) → Con(ZFC+GCH) via L |

---

## SetTheory/Ordinals.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `IsTransitive` | ✅ proved | Formula definition |
| `MemIrrefl` | ✅ proved | Formula definition |
| `MemTotal` | ✅ proved | Formula definition |
| `IsOrdinal` | ✅ proved | Formula definition |
| `OrdinalLt`, `OrdinalLe` | ✅ proved | Formula definitions |
| `ordinal_trichotomy` | 🔲 sorry | P1: from Foundation axiom |
| `transfinite_induction` | 🔲 sorry | P1: schema from Foundation axiom |
| `IsSuccessor`, `IsLimit` | ✅ proved | Formula definitions |
| `omega_is_limit` | 🔲 sorry | P1: from Infinity axiom |

---

## SetTheory/Cardinals.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `Equinumerous` | ✅ proved | Formula definition |
| `CardinalLe`, `CardinalLt` | ✅ proved | Formula definitions |
| `IsCardinal` | ✅ proved | Formula definition |
| `cantor_theorem` | 🔲 sorry | P1: diagonal argument |
| `schroeder_bernstein` | 🔲 sorry | P1: fixed-point argument, no Choice |
| `aleph0` | ✅ proved | ℵ₀ = ω |
| `konig_special` | 🔲 sorry | P1: ℵ₀ < 2^{ℵ₀} |

---

## SetTheory/ChoiceEquiv.lean

| Definition / Theorem | Status | Notes |
|----------------------|--------|-------|
| `AC` | ✅ proved | Axiom of Choice as FOL sentence |
| `WO` | ✅ proved | Well-Ordering Theorem as FOL sentence |
| `ZL` | ✅ proved | Zorn's Lemma as FOL sentence |
| `ZF` | ✅ proved | ZFC without choice |
| `AC_implies_WO` | 🔲 sorry | P1: transfinite recursion argument |
| `WO_implies_ZL` | 🔲 sorry | P1: standard argument |
| `ZL_implies_AC` | 🔲 sorry | P1: maximal partial choice function |
| `AC_WO_ZL_equivalent` | 🔲 sorry | P1: partial proof structure exists |

---

## Planned Modules (Phase 2–3)

| Module | Status | Phase | Content |
|--------|--------|-------|---------|
| `Constructible/Hierarchy.lean` | 🏗️ planned | P2 | Jensen J hierarchy, Δ₀ formulas |
| `Constructible/ConstructibleSet.lean` | 🏗️ planned | P2 | Constructible sets, absoluteness |
| `Constructible/ConstructibleUniverse.lean` | 🏗️ planned | P2 | L = ⋃ J_α, L ⊨ ZF, L ⊨ AC |
| `Constructible/GCH.lean` | 🏗️ planned | P2 | Condensation Lemma, L ⊨ GCH |
| `Forcing/PartialOrder.lean` | 🏗️ planned | P3 | Partial orders, dense sets |
| `Forcing/GenericFilter.lean` | 🏗️ planned | P3 | Generic filters |
| `Forcing/Names.lean` | 🏗️ planned | P3 | Forcing names |
| `Forcing/ForcingRelation.lean` | 🏗️ planned | P3 | Forcing relation, Truth Lemma |
| `Forcing/CHIndependence.lean` | 🏗️ planned | P3 | Cohen forcing, independence_of_CH |

---

## Summary Statistics (v0.1.0)

| Category | Count |
|----------|-------|
| Total definitions/theorems | 114 |
| Fully proved (no sorry, no axiom) | 95 |
| Declared as axiom (P1 TODO) | 2 |
| Uses sorry (P1 TODO) | 13 |
| Uses sorry (P2 TODO) | 3 |
| Uses sorry (P3 TODO) | 1 |
| Planned (not yet created) | 9 modules |
