/-
Copyright (c) 2026 ZFC4Lean Contributors.
Released under Apache 2.0 license.
Authors: ZFC4Lean Project

# Semantics of First-Order Logic

Proves the soundness theorem: T ⊢ φ → T ⊨ φ.
-/

import ZFC4Lean.FOL.Proof

namespace ZFC4Lean.FOL

structure Structure (L : Language) where
  carrier   : Type
  nonempty  : Nonempty carrier
  funInterp : {n : Nat} → L.Functions n → List carrier → carrier
  relInterp : {n : Nat} → L.Relations n → List carrier → Prop

variable {L : Language}

abbrev Assignment (M : Structure L) := Nat → M.carrier

def consAssign {M : Structure L} (a : M.carrier) (σ : Assignment M) : Assignment M
  | 0     => a
  | n + 1 => σ n

mutual
def evalTerm {M : Structure L} (σ : Assignment M) : Term L → M.carrier
  | Term.var n       => σ n
  | Term.func f args => M.funInterp f (evalTermList σ args)

def evalTermList {M : Structure L} (σ : Assignment M) : List (Term L) → List M.carrier
  | []      => []
  | t :: ts => evalTerm σ t :: evalTermList σ ts
end

def satisfies {M : Structure L} (σ : Assignment M) : Formula L → Prop
  | Formula.rel r args => M.relInterp r (evalTermList σ args)
  | Formula.eq t₁ t₂  => evalTerm σ t₁ = evalTerm σ t₂
  | Formula.falsum     => False
  | Formula.neg φ      => ¬ satisfies σ φ
  | Formula.and φ ψ    => satisfies σ φ ∧ satisfies σ ψ
  | Formula.or φ ψ     => satisfies σ φ ∨ satisfies σ ψ
  | Formula.imp φ ψ    => satisfies σ φ → satisfies σ ψ
  | Formula.all φ      => ∀ a : M.carrier, satisfies (consAssign a σ) φ
  | Formula.ex φ       => ∃ a : M.carrier, satisfies (consAssign a σ) φ

def isTrue (M : Structure L) (φ : Formula L) : Prop :=
  ∀ σ : Assignment M, satisfies σ φ

def modelsTheory (M : Structure L) (T : Theory L) : Prop :=
  ∀ φ, T φ → isTrue M φ

-- Substitution lemmas (proved by induction on formula structure; TODO P1 phase)
axiom satisfies_subst {M : Structure L} (σ : Assignment M) (t : Term L) (φ : Formula L) :
    satisfies σ (Formula.subst t 0 φ) ↔ satisfies (consAssign (evalTerm σ t) σ) φ

axiom satisfies_lift {M : Structure L} (σ : Assignment M) (a : M.carrier) (φ : Formula L) :
    satisfies (consAssign a σ) (Formula.lift 0 1 φ) ↔ satisfies σ φ

def Entails {L : Language} (T : Theory L) (φ : Formula L) : Prop :=
  ∀ (M : Structure L), modelsTheory M T → isTrue M φ

notation:50 T " ⊨ " φ => Entails T φ

-- The soundness proof: T ⊢ φ → T ⊨ φ
-- We prove it by showing: for all M and σ, if M ⊨ T then M,σ ⊨ φ
theorem soundness {L : Language} {T : Theory L} {φ : Formula L}
    (h : T ⊢ φ) : T ⊨ φ := by
  intro M hM
  -- The induction gives us IH of the form: modelsTheory M T → isTrue M ψ
  -- i.e., IH : ∀ (M : Structure L), modelsTheory M T → isTrue M ψ
  -- We need to apply IH to M and hM to get isTrue M ψ, then apply to σ
  induction h with
  | hyp hmem =>
    exact hM _ hmem
  | mp _ _ ih1 ih2 =>
    intro σ
    exact ih1 σ (ih2 σ)
  | gen _ ih =>
    intro σ a
    exact ih (consAssign a σ)
  | ax_K =>
    intro σ h _; exact h
  | ax_S =>
    intro σ h1 h2 h3; exact h1 h3 (h2 h3)
  | ax_dne =>
    intro σ h; exact Classical.byContradiction (fun hn => h hn)
  | ax_expl =>
    intro σ h; exact False.elim h
  | ax_neg_i =>
    intro σ h hn; exact h hn
  | ax_neg_e =>
    intro σ h1 h2; exact h1 h2
  | ax_and_i =>
    intro σ h1 h2; exact ⟨h1, h2⟩
  | ax_and_l =>
    intro σ h; exact h.1
  | ax_and_r =>
    intro σ h; exact h.2
  | ax_or_l =>
    intro σ h; exact Or.inl h
  | ax_or_r =>
    intro σ h; exact Or.inr h
  | ax_or_e =>
    intro σ h1 h2 h3; exact h3.elim h1 h2
  | ax_all_inst t φ' =>
    intro σ hall
    exact (satisfies_subst σ t φ').mpr (hall (evalTerm σ t))
  | ax_all_dist =>
    intro σ h1 h2 a; exact h1 a (h2 a)
  | ax_ex_intro t φ' =>
    intro σ hφ
    exact ⟨evalTerm σ t, (satisfies_subst σ t φ').mp hφ⟩
  | ax_ex_elim =>
    intro σ ⟨a, ha⟩ hall
    exact (satisfies_lift σ a _).mp (hall a ha)
  | ax_eq_refl _ =>
    intro σ; simp [satisfies]
  | ax_eq_subst _ _ _ =>
    intro σ heq hφ
    simp only [satisfies] at heq
    rw [satisfies_subst] at hφ ⊢
    rw [← heq]; exact hφ

theorem consistent_of_model {L : Language} {T : Theory L}
    (M : Structure L) (hM : modelsTheory M T) : Consistent T := by
  intro h
  have hfalse : isTrue M Formula.falsum := soundness h M hM
  simp only [isTrue, satisfies] at hfalse
  obtain ⟨a⟩ := M.nonempty
  exact hfalse (fun _ => a)

end ZFC4Lean.FOL
