
/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# Equivalences of the Axiom of Choice

AC ↔ Well-Ordering Theorem ↔ Zorn's Lemma (over ZF)
-/

import ZFC4Lean.SetTheory.Cardinals

namespace ZFC4Lean.ZFC.ChoiceEquiv

open ZFC4Lean.FOL
open L_ZFC
open Cardinals

-- Use fully qualified names to avoid conflicts with Lean builtins
private abbrev FA := @Formula.all L_ZFC
private abbrev FE := @Formula.ex  L_ZFC
private abbrev FN := @Formula.neg L_ZFC
private abbrev FI := @Formula.imp L_ZFC
private abbrev FAN := @Formula.and L_ZFC
private abbrev FOR := @Formula.or  L_ZFC
private abbrev FEQ := @Formula.eq  L_ZFC

/-! ## The Three Principles -/

/-- **Axiom of Choice (AC)**: ∀F (∀x∈F x≠∅ → ∃f ∀x∈F f(x)∈x) -/
def AC : Formula L_ZFC :=
  FA (FI
    (FA (FI (mem (x 0) (x 1)) (FE (mem (x 0) (x 1)))))
    (FE (FA (FI (mem (x 0) (x 2))
                (FE (FAN (mem (x 0) (x 1))
                         (mem (orderedPair (x 1) (x 0)) (x 2))))))))

/-- **Well-Ordering Theorem (WO)**: ∀A ∃R (R well-orders A) -/
def WO : Formula L_ZFC :=
  FA (FE (FAN
    -- Irreflexivity
    (FA (FI (mem (x 0) (x 2)) (FN (mem (orderedPair (x 0) (x 0)) (x 1)))))
    (FAN
      -- Totality
      (FA (FA (FI
        (FAN (mem (x 1) (x 3)) (mem (x 0) (x 3)))
        (FOR (mem (orderedPair (x 1) (x 0)) (x 2))
             (FOR (FEQ (x 1) (x 0))
                  (mem (orderedPair (x 0) (x 1)) (x 2)))))))
      -- Well-foundedness
      (FA (FI
        (FE (mem (x 0) (x 2)))
        (FE (FAN (mem (x 0) (x 3))
                 (FA (FI (FAN (mem (x 0) (x 4)) (FN (FEQ (x 0) (x 1))))
                         (mem (orderedPair (x 1) (x 0)) (x 3)))))))))))

/-- **Zorn's Lemma (ZL)**: Every chain-bounded partial order has a maximal element. -/
def ZL : Formula L_ZFC :=
  FA (FA (FI
    -- Every chain has an upper bound
    (FA (FI
      (FA (FA (FI
        (FAN (mem (x 1) (x 3)) (mem (x 0) (x 3)))
        (FOR (mem (orderedPair (x 1) (x 0)) (x 2))
             (mem (orderedPair (x 0) (x 1)) (x 2))))))
      (FE (FAN (mem (x 0) (x 3))
               (FA (FI (mem (x 0) (x 2))
                       (mem (orderedPair (x 0) (x 1)) (x 3))))))))
    -- Then there exists a maximal element
    (FE (FAN (mem (x 0) (x 2))
             (FA (FI (mem (x 0) (x 3))
                     (FN (FAN (mem (orderedPair (x 1) (x 0)) (x 2))
                              (FN (FEQ (x 1) (x 0)))))))))))

/-! ## ZF (without Choice) -/

def ZF : Theory L_ZFC := fun φ => ZFC φ ∧ φ ≠ axiom_choice

/-! ## Equivalence Statements (Future Work) -/

theorem AC_implies_WO : ZF ⊢ FI AC WO := by
  sorry  -- TODO: Transfinite recursion argument

theorem WO_implies_ZL : ZF ⊢ FI WO ZL := by
  sorry  -- TODO: Formalize

theorem ZL_implies_AC : ZF ⊢ FI ZL AC := by
  sorry  -- TODO: Formalize

/-- AC, WO, ZL are equivalent over ZF -/
theorem AC_WO_ZL_equivalent :
    ZF ⊢ FAN (FAN (FI AC WO) (FI WO AC))
             (FAN (FI WO ZL) (FI ZL WO)) := by
  -- Build the conjunction using mp + ax_and_i
  have h1 : ZF ⊢ FI AC WO := AC_implies_WO
  have h2 : ZF ⊢ FI WO AC := by sorry  -- WO → AC
  have h3 : ZF ⊢ FI WO ZL := WO_implies_ZL
  have h4 : ZF ⊢ FI ZL WO := by sorry  -- ZL → WO
  have h12 : ZF ⊢ FAN (FI AC WO) (FI WO AC) :=
    Prf.mp (Prf.mp Prf.ax_and_i h1) h2
  have h34 : ZF ⊢ FAN (FI WO ZL) (FI ZL WO) :=
    Prf.mp (Prf.mp Prf.ax_and_i h3) h4
  exact Prf.mp (Prf.mp Prf.ax_and_i h12) h34

end ZFC4Lean.ZFC.ChoiceEquiv
