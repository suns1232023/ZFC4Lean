
/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# First-Order Logic Syntax

This file defines the syntax of first-order logic using de Bruijn indices
for variable binding, following the approach of the flypitch project
(Han & van Doorn, CPP 2020) but redesigned for Lean 4.

## Design Decisions

1. **de Bruijn indices**: Variables are represented as natural numbers.
2. **List-based arguments**: Function/relation arguments use `List` for
   structural recursion (avoids termination issues with `Fin n → Term L`).
3. **Language parameterization**: Formulas are parameterized by a `Language`.

## References

- Han, J.M., van Doorn, F. (2021). arXiv:2102.02901
- Enderton, H.B. (2001). A Mathematical Introduction to Logic.
-/

namespace ZFC4Lean.FOL

/-! ## Language Structure -/

/-- A first-order language specifies function and relation symbols by arity. -/
structure Language where
  Functions : Nat → Type
  Relations : Nat → Type

/-! ## Terms -/

/-- Terms using de Bruijn indices and List-based arguments for structural recursion. -/
inductive Term (L : Language) : Type where
  | var  : Nat → Term L
  | func : {n : Nat} → L.Functions n → List (Term L) → Term L

/-! ## Formulas -/

/-- Formulas in a first-order language using de Bruijn indices. -/
inductive Formula (L : Language) : Type where
  | rel    : {n : Nat} → L.Relations n → List (Term L) → Formula L
  | eq     : Term L → Term L → Formula L
  | falsum : Formula L
  | neg    : Formula L → Formula L
  | and    : Formula L → Formula L → Formula L
  | or     : Formula L → Formula L → Formula L
  | imp    : Formula L → Formula L → Formula L
  | all    : Formula L → Formula L
  | ex     : Formula L → Formula L

/-! ## Lifting and Substitution (mutual recursion) -/

-- All four functions are mutually recursive because:
-- Term.lift calls liftTermList, Formula.lift calls Term.lift
-- Term.subst calls substTermList, Formula.subst calls Term.subst and Term.lift

mutual

/-- Lift free variables in a term by `k` starting from depth `d`. -/
def liftTerm {L : Language} (d k : Nat) : Term L → Term L
  | Term.var n       => if n ≥ d then Term.var (n + k) else Term.var n
  | Term.func f args => Term.func f (liftTermList d k args)

/-- Lift a list of terms. -/
def liftTermList {L : Language} (d k : Nat) : List (Term L) → List (Term L)
  | []      => []
  | t :: ts => liftTerm d k t :: liftTermList d k ts

/-- Lift free variables in a formula by `k` starting from depth `d`. -/
def liftFormula {L : Language} (d k : Nat) : Formula L → Formula L
  | Formula.rel r args => Formula.rel r (liftTermList d k args)
  | Formula.eq t₁ t₂  => Formula.eq (liftTerm d k t₁) (liftTerm d k t₂)
  | Formula.falsum     => Formula.falsum
  | Formula.neg φ      => Formula.neg (liftFormula d k φ)
  | Formula.and φ ψ    => Formula.and (liftFormula d k φ) (liftFormula d k ψ)
  | Formula.or φ ψ     => Formula.or (liftFormula d k φ) (liftFormula d k ψ)
  | Formula.imp φ ψ    => Formula.imp (liftFormula d k φ) (liftFormula d k ψ)
  | Formula.all φ      => Formula.all (liftFormula (d + 1) k φ)
  | Formula.ex φ       => Formula.ex (liftFormula (d + 1) k φ)

/-- Substitute term `s` for variable 0 in a term. -/
def substTerm {L : Language} (s : Term L) : Term L → Term L
  | Term.var 0       => s
  | Term.var (n + 1) => Term.var n
  | Term.func f args => Term.func f (substTermList s args)

/-- Substitute in a list of terms. -/
def substTermList {L : Language} (s : Term L) : List (Term L) → List (Term L)
  | []      => []
  | t :: ts => substTerm s t :: substTermList s ts

/-- Substitute term `s` for variable 0 in a formula. -/
def substFormula {L : Language} (s : Term L) : Formula L → Formula L
  | Formula.rel r args => Formula.rel r (substTermList s args)
  | Formula.eq t₁ t₂  => Formula.eq (substTerm s t₁) (substTerm s t₂)
  | Formula.falsum     => Formula.falsum
  | Formula.neg φ      => Formula.neg (substFormula s φ)
  | Formula.and φ ψ    => Formula.and (substFormula s φ) (substFormula s ψ)
  | Formula.or φ ψ     => Formula.or (substFormula s φ) (substFormula s ψ)
  | Formula.imp φ ψ    => Formula.imp (substFormula s φ) (substFormula s ψ)
  | Formula.all φ      => Formula.all (substFormula (liftTerm 0 1 s) φ)
  | Formula.ex φ       => Formula.ex (substFormula (liftTerm 0 1 s) φ)

end

/-! ## Dot notation wrappers -/

namespace Term

/-- Lift free variables in a term. -/
def lift {L : Language} (d k : Nat) (t : Term L) : Term L := liftTerm d k t

/-- Substitute `s` for variable 0 in a term. -/
def subst {L : Language} (s : Term L) (t : Term L) : Term L := substTerm s t

end Term

namespace Formula

/-- Biconditional: φ ↔ ψ defined as (φ → ψ) ∧ (ψ → φ) -/
def iff {L : Language} (φ ψ : Formula L) : Formula L :=
  and (imp φ ψ) (imp ψ φ)

/-- Verum: ⊤ defined as ¬⊥ -/
def verum {L : Language} : Formula L := neg falsum

/-- Lift free variables in a formula. -/
def lift {L : Language} (d k : Nat) (φ : Formula L) : Formula L := liftFormula d k φ

/-- Substitute term `s` for variable 0 in a formula.
    The `d` parameter is kept for API compatibility but substitution
    always targets variable 0 (callers should lift `s` appropriately). -/
def subst {L : Language} (s : Term L) (_d : Nat) (φ : Formula L) : Formula L :=
  substFormula s φ

end Formula

/-! ## Notation -/

scoped notation "⊥ₗ"       => Formula.falsum
scoped notation "⊤ₗ"       => Formula.verum
scoped notation "¬ₗ" φ     => Formula.neg φ
scoped notation φ " ∧ₗ " ψ => Formula.and φ ψ
scoped notation φ " ∨ₗ " ψ => Formula.or φ ψ
scoped notation φ " →ₗ " ψ => Formula.imp φ ψ
scoped notation φ " ↔ₗ " ψ => Formula.iff φ ψ
scoped notation "∀ₗ " φ    => Formula.all φ
scoped notation "∃ₗ " φ    => Formula.ex φ

/-! ## Theories -/

/-- A theory is a predicate on formulas (set of formulas). -/
def Theory (L : Language) := Formula L → Prop

/-! ## Example Languages -/

/-- The language with no symbols. -/
def emptyLanguage : Language where
  Functions _ := Empty
  Relations _ := Empty

end ZFC4Lean.FOL
