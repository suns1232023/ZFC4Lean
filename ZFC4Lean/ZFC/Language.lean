
/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# The Language of ZFC Set Theory

This file defines the first-order language L_ZFC used to formalize
Zermelo-Fraenkel set theory with Choice.

## Language Design

Following the approach of flypitch (Han & van Doorn, CPP 2020), we use
a language with:
- 1 binary relation symbol: ∈ (membership)
- 5 constant/function symbols: ∅, pair, ω, 𝒫, ⋃

## References

- Han, J.M., van Doorn, F. (2021). arXiv:2102.02901
- Kunen, K. (1980). Set Theory: An Introduction to Independence Proofs.
-/

import ZFC4Lean.FOL.Syntax

namespace ZFC4Lean.ZFC

open ZFC4Lean.FOL

/-! ## ZFC Function Symbols -/

/-- The function symbols of L_ZFC, indexed by arity -/
inductive ZFCFunc : Nat → Type where
  /-- The empty set ∅ (0-ary) -/
  | empty     : ZFCFunc 0
  /-- Unordered pair {x, y} (2-ary) -/
  | pair      : ZFCFunc 2
  /-- The first infinite ordinal ω (0-ary) -/
  | omega     : ZFCFunc 0
  /-- Power set 𝒫(x) (1-ary) -/
  | powerset  : ZFCFunc 1
  /-- Union ⋃x (1-ary) -/
  | union     : ZFCFunc 1

/-! ## ZFC Relation Symbols -/

/-- The relation symbols of L_ZFC, indexed by arity -/
inductive ZFCRel : Nat → Type where
  /-- Membership relation ∈ (binary) -/
  | mem : ZFCRel 2

/-! ## The ZFC Language -/

/-- The first-order language of ZFC set theory -/
def L_ZFC : Language where
  Functions := ZFCFunc
  Relations := ZFCRel

/-! ## Convenient Term Constructors -/

namespace L_ZFC

/-- Variable shorthand: x₀, x₁, x₂, ... -/
def x (n : Nat) : Term L_ZFC := Term.var n

/-- The empty set term ∅ -/
def empty : Term L_ZFC :=
  Term.func ZFCFunc.empty []

/-- The pair term {t₁, t₂} -/
def pair (t₁ t₂ : Term L_ZFC) : Term L_ZFC :=
  Term.func ZFCFunc.pair [t₁, t₂]

/-- The omega term ω -/
def omega : Term L_ZFC :=
  Term.func ZFCFunc.omega []

/-- The power set term 𝒫(t) -/
def powerset (t : Term L_ZFC) : Term L_ZFC :=
  Term.func ZFCFunc.powerset [t]

/-- The union term ⋃t -/
def union (t : Term L_ZFC) : Term L_ZFC :=
  Term.func ZFCFunc.union [t]

/-! ## Convenient Formula Constructors -/

/-- Membership formula: t₁ ∈ t₂ -/
def mem (t₁ t₂ : Term L_ZFC) : Formula L_ZFC :=
  Formula.rel ZFCRel.mem [t₁, t₂]

/-- Equality formula: t₁ = t₂ -/
def eq (t₁ t₂ : Term L_ZFC) : Formula L_ZFC :=
  Formula.eq t₁ t₂

/-- Subset formula: t₁ ⊆ t₂, defined as ∀z (z ∈ t₁ → z ∈ t₂) -/
def subset (t₁ t₂ : Term L_ZFC) : Formula L_ZFC :=
  Formula.all (Formula.imp (mem (x 0) (t₁.lift 0 1)) (mem (x 0) (t₂.lift 0 1)))

/-- Notation for membership -/
scoped notation t₁ " ∈ₛ " t₂ => L_ZFC.mem t₁ t₂
scoped notation t₁ " =ₛ " t₂ => L_ZFC.eq t₁ t₂
scoped notation t₁ " ⊆ₛ " t₂ => L_ZFC.subset t₁ t₂

/-! ## Singleton and Ordered Pair -/

/-- Singleton {t} = pair(t, t) -/
def singleton (t : Term L_ZFC) : Term L_ZFC :=
  pair t t

/-- Ordered pair ⟨t₁, t₂⟩ = {{t₁}, {t₁, t₂}} (Kuratowski encoding) -/
def orderedPair (t₁ t₂ : Term L_ZFC) : Term L_ZFC :=
  pair (singleton t₁) (pair t₁ t₂)

/-! ## Successor -/

/-- Successor of t: S(t) = t ∪ {t} = ⋃{t, {t}} -/
def succ (t : Term L_ZFC) : Term L_ZFC :=
  union (pair t (singleton t))

end L_ZFC

end ZFC4Lean.ZFC
