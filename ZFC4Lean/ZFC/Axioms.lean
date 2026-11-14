
/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# The Axioms of ZFC Set Theory

This file formalizes all axioms of Zermelo-Fraenkel set theory with
Choice (ZFC) as explicit first-order sentences in L_ZFC.

## References

- Kunen, K. (1980). Set Theory: An Introduction to Independence Proofs.
- Jech, T. (2003). Set Theory (3rd millennium ed.). Springer.
-/

import ZFC4Lean.ZFC.Language

namespace ZFC4Lean.ZFC

open ZFC4Lean.FOL
open Formula
open L_ZFC

-- Shorthand aliases for formula constructors
private abbrev A  := @Formula.all L_ZFC
private abbrev E  := @Formula.ex  L_ZFC
private abbrev N  := @Formula.neg L_ZFC
private abbrev Im := @Formula.imp L_ZFC
private abbrev An := @Formula.and L_ZFC
private abbrev Or := @Formula.or  L_ZFC
private abbrev Eq := @Formula.eq  L_ZFC
private abbrev Bo := @Formula.falsum L_ZFC

/-! ## Individual Axioms -/

/-- **Axiom of Extensionality**:
    ∀x∀y (∀z (z∈x ↔ z∈y) → x=y)
    de Bruijn: A(A(Im(A(An(Im(mem(x0)(x2))(mem(x0)(x1)))(Im(mem(x0)(x1))(mem(x0)(x2))))) (Eq(x1)(x0))))
-/
def axiom_extensionality : Formula L_ZFC :=
  A (A (Im
    (A (An (Im (mem (x 0) (x 2)) (mem (x 0) (x 1)))
           (Im (mem (x 0) (x 1)) (mem (x 0) (x 2)))))
    (Eq (x 1) (x 0))))

/-- **Axiom of Empty Set**: ∀x (x ∉ ∅) -/
def axiom_empty_set : Formula L_ZFC :=
  A (N (mem (x 0) empty))

/-- **Axiom of Pairing**: ∀x∀y∀z (z ∈ {x,y} ↔ z=x ∨ z=y) -/
def axiom_pairing : Formula L_ZFC :=
  A (A (A (An
    (Im (mem (x 0) (pair (x 2) (x 1))) (Or (Eq (x 0) (x 2)) (Eq (x 0) (x 1))))
    (Im (Or (Eq (x 0) (x 2)) (Eq (x 0) (x 1))) (mem (x 0) (pair (x 2) (x 1)))))))

/-- **Axiom of Union**: ∀F∀x (x ∈ ⋃F ↔ ∃y (x∈y ∧ y∈F)) -/
def axiom_union : Formula L_ZFC :=
  A (A (An
    (Im (mem (x 0) (union (x 1))) (E (An (mem (x 1) (x 0)) (mem (x 0) (x 2)))))
    (Im (E (An (mem (x 1) (x 0)) (mem (x 0) (x 2)))) (mem (x 0) (union (x 1))))))

/-- **Axiom of Power Set**: ∀x∀y (y ∈ 𝒫(x) ↔ y⊆x) -/
def axiom_powerset : Formula L_ZFC :=
  A (A (An
    (Im (mem (x 0) (powerset (x 1))) (A (Im (mem (x 0) (x 1)) (mem (x 0) (x 2)))))
    (Im (A (Im (mem (x 0) (x 1)) (mem (x 0) (x 2)))) (mem (x 0) (powerset (x 1))))))

/-- **Axiom of Infinity**: ∅∈ω ∧ ∀x (x∈ω → S(x)∈ω) -/
def axiom_infinity : Formula L_ZFC :=
  An (mem empty omega)
     (A (Im (mem (x 0) omega) (mem (succ (x 0)) omega)))

/-- **Axiom of Foundation**: ∀x (∃y (y∈x) → ∃y∈x ∀z∈y (z∉x)) -/
def axiom_foundation : Formula L_ZFC :=
  A (Im
    (E (mem (x 0) (x 1)))
    (E (An (mem (x 0) (x 1))
           (N (E (An (mem (x 0) (x 2)) (mem (x 0) (x 1))))))))

/-! ## Axiom Schemas -/

/-- **Axiom Schema of Separation**: ∀x ∃y ∀z (z∈y ↔ z∈x ∧ φ(z))
    φ has variable 0 free. -/
def axiom_separation (φ : Formula L_ZFC) : Formula L_ZFC :=
  A (E (A (An
    (Im (mem (x 0) (x 1)) (An (mem (x 0) (x 2)) (φ.lift 1 2)))
    (Im (An (mem (x 0) (x 2)) (φ.lift 1 2)) (mem (x 0) (x 1))))))

/-- **Axiom Schema of Replacement**: ∀x (∀y∈x ∃!z φ(y,z) → ∃w ∀y∈x ∃z∈w φ(y,z))
    φ has variables 0 (z) and 1 (y) free. -/
def axiom_replacement (φ : Formula L_ZFC) : Formula L_ZFC :=
  A (Im
    (A (Im (mem (x 0) (x 1))
        (An (E (φ.lift 1 2))
            (A (A (Im (An (φ.lift 2 3) (φ.lift 2 3)) (Eq (x 1) (x 0))))))))
    (E (A (Im (mem (x 0) (x 2))
              (E (An (mem (x 0) (x 2)) (φ.lift 2 3)))))))

/-- **Axiom of Choice**: ∀F (∀x∈F x≠∅ → ∃f ∀x∈F f(x)∈x) -/
def axiom_choice : Formula L_ZFC :=
  A (Im
    (A (Im (mem (x 0) (x 1)) (E (mem (x 0) (x 1)))))
    (E (A (Im (mem (x 0) (x 2))
              (E (An (mem (x 0) (x 1))
                     (mem (orderedPair (x 1) (x 0)) (x 2))))))))

/-! ## The ZFC Theory -/

/-- The ZFC theory as a predicate on formulas. -/
def ZFC : Theory L_ZFC := fun φ =>
  φ = axiom_extensionality ∨
  φ = axiom_empty_set ∨
  φ = axiom_pairing ∨
  φ = axiom_union ∨
  φ = axiom_powerset ∨
  φ = axiom_infinity ∨
  φ = axiom_foundation ∨
  φ = axiom_choice ∨
  (∃ ψ, φ = axiom_separation ψ) ∨
  (∃ ψ, φ = axiom_replacement ψ)

/-! ## Membership Lemmas -/

theorem extensionality_in_ZFC : ZFC axiom_extensionality :=
  Or.inl rfl

theorem empty_set_in_ZFC : ZFC axiom_empty_set :=
  Or.inr (Or.inl rfl)

theorem pairing_in_ZFC : ZFC axiom_pairing :=
  Or.inr (Or.inr (Or.inl rfl))

theorem union_in_ZFC : ZFC axiom_union :=
  Or.inr (Or.inr (Or.inr (Or.inl rfl)))

theorem powerset_in_ZFC : ZFC axiom_powerset :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))

theorem infinity_in_ZFC : ZFC axiom_infinity :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl)))))

theorem foundation_in_ZFC : ZFC axiom_foundation :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))))

theorem choice_in_ZFC : ZFC axiom_choice :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl)))))))

theorem separation_in_ZFC (φ : Formula L_ZFC) :
    ZFC (axiom_separation φ) :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ⟨φ, rfl⟩))))))))

theorem replacement_in_ZFC (φ : Formula L_ZFC) :
    ZFC (axiom_replacement φ) :=
  Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨φ, rfl⟩))))))))

/-! ## The Continuum Hypothesis -/

/-- The Continuum Hypothesis (CH):
    ∀x (Ord(x) → x ≤ ω ∨ 𝒫(ω) ≤ x)
    where a ≤ b means there is an injection from a to b.
-/
def CH : Formula L_ZFC :=
  A (Im
    -- x is an ordinal (transitive + well-ordered by ∈)
    (An
      (A (A (Im (An (mem (x 0) (x 2)) (mem (x 1) (x 0))) (mem (x 1) (x 2)))))
      (A (A (Im (An (mem (x 1) (x 2)) (mem (x 0) (x 2)))
                (Or (mem (x 1) (x 0)) (Or (Eq (x 1) (x 0)) (mem (x 0) (x 1))))))))
    -- x ≤ ω ∨ 𝒫(ω) ≤ x
    (Or
      (E (A (Im (mem (x 0) (x 2))
                (E (An (mem (x 0) omega) (mem (orderedPair (x 1) (x 0)) (x 2)))))))
      (E (A (Im (mem (x 0) (powerset omega))
                (E (An (mem (x 0) (x 3)) (mem (orderedPair (x 1) (x 0)) (x 2)))))))))

end ZFC4Lean.ZFC
