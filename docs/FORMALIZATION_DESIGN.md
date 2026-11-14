
# Formalization Design

This document explains the key design decisions in ZFC4Lean and the
rationale behind each choice.

---

## 1. de Bruijn Indices vs. Named Variables

**Decision**: Use de Bruijn indices for variable binding.

**Rationale**: de Bruijn indices avoid variable capture issues in substitution.
With named variables, substituting `t` for `x` in `∀y φ` requires checking
that `y` does not appear free in `t` (to avoid capture). With de Bruijn
indices, this is handled automatically by the lifting operation.

**Implementation**: `Term.var n` refers to the variable bound by the `n`-th
enclosing binder (0-indexed from inside out). The `liftTerm d k` operation
increments all free variables at depth ≥ d by k, making room for new binders.

**Tradeoff**: Formulas are harder to read. We provide the `x n` shorthand
(`x 0`, `x 1`, ...) to improve readability.

---

## 2. List-Based Arguments vs. Fin-Indexed Arguments

**Decision**: Use `List (Term L)` for function and relation arguments.

**Rationale**: The natural representation `Fin n → Term L` causes termination
issues in Lean 4. When defining `liftTerm` by recursion on `Term L`, the
recursive call on `args i` (for `i : Fin n`) is not recognized as structurally
smaller than `Term.func f args` because Lean cannot automatically prove
`sizeOf (args i) < sizeOf (Term.func f args)` for the `Fin`-indexed case.

With `List (Term L)`, the recursive call on the tail of the list is
structurally smaller, enabling clean structural recursion.

**Tradeoff**: The arity constraint (that `args` has exactly `n` elements for
an `n`-ary function symbol) is not enforced by the type. This is acceptable
for our purposes since we only construct well-formed terms via the provided
constructors.

---

## 3. Mutual Recursion for Lift and Subst

**Decision**: Define `liftTerm`/`liftTermList` and `substTerm`/`substTermList`
as mutually recursive functions.

**Rationale**: With List-based arguments, `liftTerm` on `Term.func f args`
needs to lift each element of `args`. Using `List.map (liftTerm d k)` would
require Lean to recognize that the recursive call is on a structurally smaller
argument, which it cannot do automatically for `List.map` with a recursive
function.

The mutual recursion pattern makes the structural decrease explicit:
- `liftTerm` on `Term.func f (t :: ts)` calls `liftTerm` on `t` (smaller)
  and `liftTermList` on `ts` (smaller)
- `liftTermList` on `t :: ts` calls `liftTerm` on `t` and `liftTermList` on `ts`

This is a standard pattern for handling mutually recursive data types.

---

## 4. Hilbert-Style vs. Natural Deduction

**Decision**: Use a Hilbert-style proof system.

**Rationale**: Hilbert-style systems have fewer inference rules (only modus
ponens and generalization), making induction on proofs simpler. The soundness
proof has exactly 22 cases (one per axiom schema plus two for the inference
rules), all of which are straightforward.

Natural deduction systems have more inference rules but shorter proofs. For
our purposes (meta-mathematical results), the Hilbert style is more convenient.

**Reference**: This follows the approach of flypitch (Han & van Doorn, 2020).

---

## 5. Theory as Predicate vs. Set

**Decision**: Represent theories as predicates `Theory L = Formula L → Prop`.

**Rationale**: In Lean 4, `Set (Formula L)` is definitionally equal to
`Formula L → Prop`, so this is the same thing. Using the predicate form
directly avoids importing `Mathlib.Data.Set.Basic` and keeps the project
self-contained.

The ZFC theory is defined as:
```lean
def ZFC : Theory L_ZFC := fun φ =>
  φ = axiom_extensionality ∨ ... ∨ (∃ ψ, φ = axiom_replacement ψ)
```

---

## 6. No Mathlib Dependency

**Decision**: The project depends only on Lean 4's standard library.

**Rationale**: This ensures that the axiom dependencies of our theorems are
minimal and transparent. When we run `#print axioms soundness`, we want to
see only the standard Lean axioms (propext, Classical.choice, Quot.sound),
not a large collection of Mathlib axioms.

It also makes the project easier to build (no Mathlib download required)
and more stable (no dependency on Mathlib's evolving API).

**Tradeoff**: We cannot reuse Mathlib's existing ordinal and cardinal theory.
Our ordinal and cardinal definitions are formulated as first-order formulas
in L_ZFC, which is the correct approach for meta-mathematical work but
requires more work than using Mathlib's `Ordinal` type.

---

## 7. Axiom vs. Sorry for Unproved Lemmas

**Decision**: Use `axiom` (not `sorry`) for the two substitution lemmas.

**Rationale**: `axiom` declarations are explicit and auditable. When running
`#print axioms soundness`, axiom dependencies appear by name, making it clear
exactly what is assumed. `sorry` also appears in `#print axioms` output, but
as a less informative `sorryAx` entry.

More importantly, `axiom` communicates intent: these are not forgotten proofs
but explicit mathematical assumptions with clear proof obligations.

---

## 8. Namespace Structure

**Decision**: Use `ZFC4Lean.FOL`, `ZFC4Lean.ZFC`, `ZFC4Lean.ZFC.Ordinals`, etc.

**Rationale**: Clear namespace hierarchy matching the directory structure.
All definitions are inside `ZFC4Lean` to avoid conflicts with Lean's standard
library and potential future Mathlib imports.

The `open` statements in each file make the relevant namespaces available
locally without polluting the global namespace.

---

## 9. Soundness Proof Strategy

The soundness proof (`T ⊢ φ → T ⊨ φ`) proceeds by induction on the proof
derivation `h : Prf T φ`. There are 22 cases:

**Hypothesis case** (hyp): If φ ∈ T, then φ is true in every model of T
by definition of `modelsTheory`.

**Modus ponens** (mp): If T ⊢ φ → ψ and T ⊢ φ, then by induction hypotheses,
φ → ψ and φ are true in every model, so ψ is true in every model.

**Generalization** (gen): If T ⊢ φ, then by induction hypothesis, φ is true
in every model under every assignment. For any element `a` of the carrier,
`φ` is true under `consAssign a σ`, so `∀x φ` is true under `σ`.

**Axiom cases** (22 schemas): Each axiom schema is verified to be semantically
valid. For example:
- ax_K (φ → ψ → φ): given `h : satisfies σ φ` and `_ : satisfies σ ψ`,
  return `h`.
- ax_all_inst (∀x φ → φ[t/x]): given `hall : ∀a, satisfies (consAssign a σ) φ`,
  apply `satisfies_subst` to get `satisfies σ (φ.subst t 0)`.

The two substitution lemma cases (ax_all_inst, ax_ex_intro, ax_ex_elim) are
where `satisfies_subst` and `satisfies_lift` are used.
