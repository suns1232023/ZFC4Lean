
# Axiom Audit

This document provides a complete audit of all axioms used in ZFC4Lean.
It distinguishes standard Lean axioms, explicitly declared axioms (with proof
obligations), and sorry instances.

**Last updated**: 2026-11-13 (v0.1.0)

---

## Standard Lean Axioms

Every Lean 4 proof may use these three axioms. They are present in virtually
all Lean 4 mathematics and are not specific to ZFC4Lean.

| Axiom | Meaning | Used in |
|-------|---------|---------|
| `propext` | Propositional extensionality: (P ↔ Q) → P = Q | soundness, consistent_of_model |
| `Classical.choice` | Classical choice principle | soundness (via Classical.byContradiction) |
| `Quot.sound` | Quotient soundness | soundness |

---

## ZFC4Lean-Specific Declared Axioms

These are explicitly declared with the `axiom` keyword in ZFC4Lean source files.
They have clear mathematical content and proof obligations for Phase 1.

### `satisfies_subst`

**File**: `ZFC4Lean/FOL/Semantics.lean`
**Phase**: P1 (proof planned)

```lean
axiom satisfies_subst {M : Structure L} (σ : Assignment M) (t : Term L) (φ : Formula L) :
    satisfies σ (Formula.subst t 0 φ) ↔ satisfies (consAssign (evalTerm σ t) σ) φ
```

**Mathematical content**: Substituting term `t` for variable 0 in formula `φ`
and then evaluating under assignment `σ` is equivalent to evaluating `φ` under
the assignment extended with the value of `t`.

**Proof strategy**: Structural induction on `φ`. The base cases (rel, eq, falsum)
follow from the definition of `substTerm`. The inductive cases (neg, and, or, imp)
follow from the induction hypothesis. The quantifier cases (all, ex) require
careful handling of de Bruijn index arithmetic: substituting under a binder
requires lifting `t` by 1, which corresponds to the `consAssign` extension.

**Why declared as axiom rather than sorry**: Using `axiom` makes the dependency
explicit and auditable via `#print axioms`. It also prevents accidental use of
`sorry`-based proofs in downstream theorems.

---

### `satisfies_lift`

**File**: `ZFC4Lean/FOL/Semantics.lean`
**Phase**: P1 (proof planned)

```lean
axiom satisfies_lift {M : Structure L} (σ : Assignment M) (a : M.carrier) (φ : Formula L) :
    satisfies (consAssign a σ) (Formula.lift 0 1 φ) ↔ satisfies σ φ
```

**Mathematical content**: Lifting all free variables in `φ` by 1 (starting from
depth 0) and then evaluating under an extended assignment `consAssign a σ` is
equivalent to evaluating `φ` under the original assignment `σ`. In other words,
lifting "makes room" for the new variable `a` at index 0, which is then ignored.

**Proof strategy**: Structural induction on `φ`. The key insight is that
`liftFormula 0 1 φ` increments all free variable indices by 1, so variable `n`
in `φ` becomes variable `n+1` in the lifted formula. Under `consAssign a σ`,
variable `n+1` evaluates to `σ n`, which is the same as evaluating variable `n`
under `σ`.

**Why declared as axiom rather than sorry**: Same reason as `satisfies_subst`.

---

## Sorry Instances

The following theorems use `sorry` as a placeholder. Unlike the declared axioms
above, these are not used as dependencies by other theorems — they are leaf
theorems whose proofs are planned for future phases.

### Phase 1 (P1) Sorry Instances

| Theorem | File | Proof Strategy |
|---------|------|----------------|
| `Prf.deduction` (gen case) | FOL/Proof.lean | Variable restriction condition |
| `ordinal_trichotomy` | SetTheory/Ordinals.lean | Foundation axiom + transfinite induction |
| `transfinite_induction` | SetTheory/Ordinals.lean | Foundation axiom |
| `omega_is_limit` | SetTheory/Ordinals.lean | Infinity axiom |
| `cantor_theorem` | SetTheory/Cardinals.lean | Diagonal argument |
| `schroeder_bernstein` | SetTheory/Cardinals.lean | Fixed-point argument |
| `konig_special` | SetTheory/Cardinals.lean | Cantor's theorem applied to ω |
| `AC_implies_WO` | SetTheory/ChoiceEquiv.lean | Transfinite recursion |
| `WO_implies_ZL` | SetTheory/ChoiceEquiv.lean | Standard argument |
| `ZL_implies_AC` | SetTheory/ChoiceEquiv.lean | Maximal partial choice function |
| `AC_WO_ZL_equivalent` (partial) | SetTheory/ChoiceEquiv.lean | Combines above |
| `h2` in AC_WO_ZL_equivalent | SetTheory/ChoiceEquiv.lean | WO → AC |
| `h4` in AC_WO_ZL_equivalent | SetTheory/ChoiceEquiv.lean | ZL → WO |

### Phase 2 (P2) Sorry Instances

| Theorem | File | Proof Strategy |
|---------|------|----------------|
| `CH_independent` (¬CH direction) | ZFC/Theory.lean | Gödel L: L ⊨ CH via GCH |
| `relative_consistency_ZFC` | ZFC/Theory.lean | L is a model of ZFC within any model of ZF |
| `relative_consistency_GCH` | ZFC/Theory.lean | L ⊨ ZFC + GCH |

### Phase 3 (P3) Sorry Instances

| Theorem | File | Proof Strategy |
|---------|------|----------------|
| `CH_independent` (CH direction) | ZFC/Theory.lean | Cohen forcing: ¬CH consistent with ZFC |

---

## Axiom Dependency of Key Theorems

Run these commands to verify axiom dependencies:

```lean
-- Soundness theorem
#print axioms ZFC4Lean.FOL.soundness
-- Expected: propext, Classical.choice, Quot.sound,
--           ZFC4Lean.FOL.satisfies_subst, ZFC4Lean.FOL.satisfies_lift

-- Consistency from model
#print axioms ZFC4Lean.FOL.consistent_of_model
-- Expected: same as soundness

-- ZFC proves extensionality
#print axioms ZFC4Lean.ZFC.zfc_proves_extensionality
-- Expected: (none beyond standard Lean axioms)

-- CH independence (current state — uses sorry)
#print axioms ZFC4Lean.ZFC.CH_independent
-- Expected: ZFC4Lean.FOL.soundness.sorry (from sorry placeholders)
```

---

## Phase 1 Goal: Clean Axiom Audit

After Phase 1 is complete, the target axiom audit for the soundness theorem is:

```
#print axioms ZFC4Lean.FOL.soundness
-- 'ZFC4Lean.FOL.soundness' depends on axioms:
-- [propext, Classical.choice, Quot.sound]
```

This means `satisfies_subst` and `satisfies_lift` will be proved theorems,
not axioms, and the soundness theorem will depend only on the three standard
Lean axioms.
