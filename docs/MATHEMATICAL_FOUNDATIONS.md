
# Mathematical Foundations

This document explains the mathematical content of ZFC4Lean for readers
who may be familiar with Lean 4 but less familiar with mathematical logic
and set theory, or vice versa.

---

## 1. Why Explicit First-Order Logic?

Lean 4's type theory (the Calculus of Inductive Constructions, CIC) is itself
a foundation for mathematics. Mathlib4 builds on this to provide a rich library
including a semantic model of ZFC (`ZFSet`). So why does ZFC4Lean define an
explicit first-order logic framework?

The answer is that **meta-mathematical results require a syntactic treatment**.

To prove that CH is *independent* of ZFC, we need to show:
1. There is no proof of CH from ZFC axioms.
2. There is no proof of ¬CH from ZFC axioms.

To state "there is no proof", we need an explicit notion of *proof* — a
syntactic object that can be reasoned about. Mathlib's `ZFSet` gives us a
semantic model of ZFC, but it does not give us a proof system for ZFC.

ZFC4Lean provides both:
- An explicit first-order language L_ZFC
- A Hilbert-style proof system for L_ZFC
- Model-theoretic semantics for L_ZFC
- A machine-verified soundness theorem

This is the same approach used by the flypitch project (Han & van Doorn, 2020)
in Lean 3, now redesigned for Lean 4.

---

## 2. The ZFC Language L_ZFC

The language L_ZFC is a first-order language with:

**Relation symbols**:
- `∈` (membership): the only primitive relation

**Function symbols** (for convenience; all definable from ∈):
- `∅` (empty set, 0-ary)
- `{·,·}` (unordered pair, 2-ary)
- `ω` (first infinite ordinal, 0-ary)
- `𝒫(·)` (power set, 1-ary)
- `⋃·` (union of a family, 1-ary)

The 5 function symbols are definable from ∈ alone, but including them
simplifies the formalization of ZFC axioms and the Continuum Hypothesis.
This follows the approach of flypitch.

---

## 3. de Bruijn Indices

Variables in ZFC4Lean use **de Bruijn indices**: a variable is represented
as a natural number indicating how many binders it is "inside".

For example, the formula ∀x∀y (x∈y) is represented as:
```
Formula.all (Formula.all (mem (Term.var 1) (Term.var 0)))
```
Here `var 0` refers to the innermost binder (y) and `var 1` refers to the
next binder (x).

**Advantages of de Bruijn indices**:
- No variable capture issues in substitution
- No need for alpha-equivalence
- Substitution is a simple recursive function
- Standard in machine-verified proof systems

**Disadvantage**: Formulas are harder to read. ZFC4Lean provides the `x n`
shorthand (`x 0`, `x 1`, `x 2`, ...) to make formulas more readable.

---

## 4. The Hilbert Proof System

ZFC4Lean uses a **Hilbert-style proof system** with 22 axiom schemas and
two inference rules:

**Inference rules**:
- **Modus Ponens** (mp): from T ⊢ φ → ψ and T ⊢ φ, derive T ⊢ ψ
- **Generalization** (gen): from T ⊢ φ, derive T ⊢ ∀x φ

**Propositional axiom schemas** (12):
- K: φ → (ψ → φ)
- S: (φ → ψ → χ) → (φ → ψ) → (φ → χ)
- Double negation elimination: ¬¬φ → φ
- Explosion: ⊥ → φ
- Negation introduction/elimination
- Conjunction introduction/elimination (×2)
- Disjunction introduction (×2) / elimination

**Quantifier axiom schemas** (4):
- Universal instantiation: ∀x φ → φ[t/x]
- Universal distribution: ∀x (φ → ψ) → (∀x φ → ∀x ψ)
- Existential introduction: φ[t/x] → ∃x φ
- Existential elimination: ∃x φ → (∀x (φ → ψ)) → ψ

**Equality axiom schemas** (2):
- Reflexivity: t = t
- Substitution: t₁ = t₂ → φ[t₁/x] → φ[t₂/x]

---

## 5. The Soundness Theorem

The **soundness theorem** states: if φ is provable from T, then φ is true
in every model of T.

```lean
theorem soundness {L : Language} {T : Theory L} {φ : Formula L}
    (h : T ⊢ φ) : T ⊨ φ
```

This is proved by induction on the proof `h`. Each of the 22 axiom schemas
is verified to be semantically valid, and the two inference rules are verified
to preserve semantic validity.

The soundness theorem currently depends on two substitution lemmas
(`satisfies_subst` and `satisfies_lift`) that are declared as axioms pending
proof in Phase 1. Once proved, the soundness theorem will depend only on the
three standard Lean axioms (propext, Classical.choice, Quot.sound).

---

## 6. The ZFC Axioms

ZFC consists of 10 axioms (8 individual axioms + 2 axiom schemas):

| # | Axiom | Informal Statement |
|---|-------|-------------------|
| 1 | Extensionality | Two sets are equal iff they have the same elements |
| 2 | Empty Set | There exists a set with no elements |
| 3 | Pairing | For any x, y, there exists {x, y} |
| 4 | Union | For any family F, there exists ⋃F |
| 5 | Power Set | For any x, there exists 𝒫(x) |
| 6 | Infinity | There exists an inductive set containing ω |
| 7 | Foundation | Every nonempty set has an ∈-minimal element |
| 8 | Choice | Every family of nonempty sets has a choice function |
| 9 | Separation (schema) | For any set x and property φ, {z ∈ x | φ(z)} exists |
| 10 | Replacement (schema) | The image of a set under a functional formula is a set |

In ZFC4Lean, each axiom is formalized as an explicit first-order sentence
in L_ZFC. The Separation and Replacement schemas are parameterized by a
`Formula L_ZFC`, yielding one axiom per formula.

---

## 7. The Continuum Hypothesis

The **Continuum Hypothesis** (CH) states that there is no set whose
cardinality is strictly between ℵ₀ and 2^{ℵ₀}.

In ZFC4Lean, CH is formalized as:

```
∀x (Ord(x) → x ≤ ω ∨ 𝒫(ω) ≤ x)
```

where:
- `Ord(x)` means x is an ordinal (transitive set well-ordered by ∈)
- `x ≤ ω` means there is an injection from x to ω
- `𝒫(ω) ≤ x` means there is an injection from 𝒫(ω) to x

This says: every ordinal either injects into ω (is countable) or 𝒫(ω)
injects into it (has cardinality at least 2^{ℵ₀}). There is nothing in between.

---

## 8. Independence

A formula φ is **independent** of a theory T if:
- T does not prove φ (¬(T ⊢ φ)), and
- T does not prove ¬φ (¬(T ⊢ ¬φ))

In ZFC4Lean:
```lean
def Independent (T : Theory L) (φ : Formula L) : Prop :=
  ¬ (T ⊢ φ) ∧ ¬ (T ⊢ Formula.neg φ)
```

The main goal of ZFC4Lean is to prove:
```lean
theorem CH_independent : Independent ZFC CH
```

This requires two directions:
1. **¬(ZFC ⊢ CH)**: Cohen forcing shows ZFC + ¬CH is consistent (Phase 3)
2. **¬(ZFC ⊢ ¬CH)**: Gödel's L shows ZFC + CH is consistent (Phase 2)

---

## 9. Gödel's Constructible Universe L (Phase 2)

Gödel (1938) proved Con(ZF) → Con(ZFC + GCH) by constructing the
**constructible universe** L:

- L₀ = ∅
- L_{α+1} = Def(L_α) = {x ⊆ L_α | x is first-order definable over (L_α, ∈)}
- L_λ = ⋃_{α<λ} L_α for limit ordinals λ
- L = ⋃_{α∈Ord} L_α

Key properties:
- L is a transitive class containing all ordinals
- L ⊨ ZF (L satisfies all ZF axioms)
- L ⊨ AC (L has a canonical well-ordering)
- L ⊨ GCH (by the Condensation Lemma)

The **Condensation Lemma** is the key technical result: every countable
elementary substructure of L_α is isomorphic to some L_β (β ≤ α).
This implies that every real number in L appears in some L_α with α countable,
which gives 2^{ℵ₀} = ℵ₁ in L.

---

## 10. Cohen Forcing (Phase 3)

Cohen (1963) proved Con(ZFC) → Con(ZFC + ¬CH) by inventing the **forcing**
method. ZFC4Lean uses the **Boolean-valued model** approach (equivalent to
Cohen's original, but more amenable to formalization):

1. Start with a model M of ZFC
2. Choose a complete Boolean algebra B (the "Cohen algebra")
3. Construct the Boolean-valued universe V^B
4. Every formula φ has a truth value [[φ]]_B ∈ B
5. The forcing relation p ⊩ φ means p ≤ [[φ]]_B
6. The Truth Lemma: M[G] ⊨ φ ↔ ∃p∈G, p ⊩ φ

For ¬CH: use the Cohen poset Fn(ω × ω₂, 2) (finite partial functions from
ω × ω₂ to {0,1}). The generic filter G encodes ℵ₂ distinct reals, making
2^{ℵ₀} ≥ ℵ₂ in M[G], so ¬CH holds.
