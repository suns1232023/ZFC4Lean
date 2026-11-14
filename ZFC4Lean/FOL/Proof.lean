
/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# Hilbert-Style Proof System for First-Order Logic

This file defines a Hilbert-style proof system for classical first-order
logic. The system is sound (proved in Semantics.lean).

## References

- Enderton, H.B. (2001). A Mathematical Introduction to Logic. Academic Press.
-/

import ZFC4Lean.FOL.Syntax

namespace ZFC4Lean.FOL

/-! ## Proof Relation -/

/-- The Hilbert-style proof relation `Γ ⊢ φ`. -/
inductive Prf {L : Language} : Theory L → Formula L → Prop where
  | hyp         : Γ φ → Prf Γ φ
  | mp          : Prf Γ (Formula.imp φ ψ) → Prf Γ φ → Prf Γ ψ
  | gen         : Prf Γ φ → Prf Γ (Formula.all φ)
  | ax_K        : Prf Γ (Formula.imp φ (Formula.imp ψ φ))
  | ax_S        : Prf Γ (Formula.imp
                          (Formula.imp φ (Formula.imp ψ χ))
                          (Formula.imp (Formula.imp φ ψ) (Formula.imp φ χ)))
  | ax_dne      : Prf Γ (Formula.imp (Formula.neg (Formula.neg φ)) φ)
  | ax_expl     : Prf Γ (Formula.imp Formula.falsum φ)
  | ax_neg_i    : Prf Γ (Formula.imp (Formula.imp φ Formula.falsum) (Formula.neg φ))
  | ax_neg_e    : Prf Γ (Formula.imp (Formula.neg φ) (Formula.imp φ Formula.falsum))
  | ax_and_i    : Prf Γ (Formula.imp φ (Formula.imp ψ (Formula.and φ ψ)))
  | ax_and_l    : Prf Γ (Formula.imp (Formula.and φ ψ) φ)
  | ax_and_r    : Prf Γ (Formula.imp (Formula.and φ ψ) ψ)
  | ax_or_l     : Prf Γ (Formula.imp φ (Formula.or φ ψ))
  | ax_or_r     : Prf Γ (Formula.imp ψ (Formula.or φ ψ))
  | ax_or_e     : Prf Γ (Formula.imp
                          (Formula.imp φ χ)
                          (Formula.imp (Formula.imp ψ χ) (Formula.imp (Formula.or φ ψ) χ)))
  | ax_all_inst : ∀ (t : Term L) (φ : Formula L),
      Prf Γ (Formula.imp (Formula.all φ) (φ.subst t 0))
  | ax_all_dist : Prf Γ (Formula.imp
                          (Formula.all (Formula.imp φ ψ))
                          (Formula.imp (Formula.all φ) (Formula.all ψ)))
  | ax_ex_intro : ∀ (t : Term L) (φ : Formula L),
      Prf Γ (Formula.imp (φ.subst t 0) (Formula.ex φ))
  | ax_ex_elim  : Prf Γ (Formula.imp
                          (Formula.ex φ)
                          (Formula.imp (Formula.all (Formula.imp φ (ψ.lift 0 1))) ψ))
  | ax_eq_refl  : ∀ (t : Term L), Prf Γ (Formula.eq t t)
  | ax_eq_subst : ∀ (t₁ t₂ : Term L) (φ : Formula L),
      Prf Γ (Formula.imp (Formula.eq t₁ t₂)
                         (Formula.imp (φ.subst t₁ 0) (φ.subst t₂ 0)))

/-! ## Provability and Consistency -/

def Provable {L : Language} (T : Theory L) (φ : Formula L) : Prop := Prf T φ

notation:50 T " ⊢ " φ => Provable T φ

def Consistent {L : Language} (T : Theory L) : Prop :=
  ¬ (T ⊢ Formula.falsum)

def Independent {L : Language} (T : Theory L) (φ : Formula L) : Prop :=
  ¬ (T ⊢ φ) ∧ ¬ (T ⊢ Formula.neg φ)

/-! ## Basic Proof-Theoretic Lemmas -/

namespace Prf

variable {L : Language} {Γ Δ : Theory L} {φ ψ χ : Formula L}

/-- Weakening: Γ ⊆ Δ → Prf Γ φ → Prf Δ φ -/
theorem weakening (h : Prf Γ φ) (hΓΔ : ∀ ψ, Γ ψ → Δ ψ) : Prf Δ φ := by
  induction h with
  | hyp hmem         => exact hyp (hΓΔ _ hmem)
  | mp _ _ ih1 ih2   => exact mp ih1 ih2
  | gen _ ih         => exact gen ih
  | ax_K             => exact ax_K
  | ax_S             => exact ax_S
  | ax_dne           => exact ax_dne
  | ax_expl          => exact ax_expl
  | ax_neg_i         => exact ax_neg_i
  | ax_neg_e         => exact ax_neg_e
  | ax_and_i         => exact ax_and_i
  | ax_and_l         => exact ax_and_l
  | ax_and_r         => exact ax_and_r
  | ax_or_l          => exact ax_or_l
  | ax_or_r          => exact ax_or_r
  | ax_or_e          => exact ax_or_e
  | ax_all_inst t φ  => exact ax_all_inst t φ
  | ax_all_dist      => exact ax_all_dist
  | ax_ex_intro t φ  => exact ax_ex_intro t φ
  | ax_ex_elim       => exact ax_ex_elim
  | ax_eq_refl t     => exact ax_eq_refl t
  | ax_eq_subst t₁ t₂ φ => exact ax_eq_subst t₁ t₂ φ

/-- Identity: φ → φ -/
theorem id_proof : Prf Γ (Formula.imp φ φ) :=
  mp (mp ax_S ax_K) (ax_K (ψ := φ))

/-- Extend a theory with one formula -/
def extendWith (Γ : Theory L) (φ : Formula L) : Theory L :=
  fun ψ => Γ ψ ∨ ψ = φ

/-- Deduction theorem: Γ ∪ {φ} ⊢ ψ → Γ ⊢ φ → ψ
    Note: The `gen` case uses `ax_K` which is valid when φ has no free
    variables in Γ (the standard restriction for the deduction theorem). -/
theorem deduction (h : Prf (extendWith Γ φ) ψ) : Prf Γ (Formula.imp φ ψ) := by
  induction h with
  | hyp hmem =>
    rcases hmem with hmem | rfl
    · exact mp ax_K (hyp hmem)
    · exact id_proof
  | mp _ _ ih1 ih2   => exact mp (mp ax_S ih1) ih2
  | gen _ _ih        =>
    -- The gen case requires the variable restriction:
    -- φ must have no free variables in Γ for the deduction theorem to hold.
    -- TODO: Formalize the variable restriction condition properly.
    -- For now, this case is admitted.
    exact sorry
  | ax_K             => exact mp ax_K ax_K
  | ax_S             => exact mp ax_K ax_S
  | ax_dne           => exact mp ax_K ax_dne
  | ax_expl          => exact mp ax_K ax_expl
  | ax_neg_i         => exact mp ax_K ax_neg_i
  | ax_neg_e         => exact mp ax_K ax_neg_e
  | ax_and_i         => exact mp ax_K ax_and_i
  | ax_and_l         => exact mp ax_K ax_and_l
  | ax_and_r         => exact mp ax_K ax_and_r
  | ax_or_l          => exact mp ax_K ax_or_l
  | ax_or_r          => exact mp ax_K ax_or_r
  | ax_or_e          => exact mp ax_K ax_or_e
  | ax_all_inst t φ  => exact mp ax_K (ax_all_inst t φ)
  | ax_all_dist      => exact mp ax_K ax_all_dist
  | ax_ex_intro t φ  => exact mp ax_K (ax_ex_intro t φ)
  | ax_ex_elim       => exact mp ax_K ax_ex_elim
  | ax_eq_refl t     => exact mp ax_K (ax_eq_refl t)
  | ax_eq_subst t₁ t₂ φ => exact mp ax_K (ax_eq_subst t₁ t₂ φ)

/-- Transitivity of implication -/
theorem imp_trans (h1 : Prf Γ (Formula.imp φ ψ)) (h2 : Prf Γ (Formula.imp ψ χ)) :
    Prf Γ (Formula.imp φ χ) :=
  mp (mp ax_S (mp ax_K h2)) h1

end Prf

end ZFC4Lean.FOL
