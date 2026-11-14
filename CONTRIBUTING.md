
# Contributing to ZFC4Lean

Thank you for your interest in contributing to ZFC4Lean! This project formalizes
axiomatic set theory in Lean 4, with the long-term goal of machine-verifying the
independence of the Continuum Hypothesis.

## Code of Conduct

Be respectful, constructive, and mathematically precise. All contributions must
meet the verification standards described below.

---

## Verification Standards

Every contribution must satisfy all four standards:

**1. No sorry in submitted theorems.**
Core theorems must have zero `sorry` instances. If you are working on a theorem
that depends on an unproved lemma, use `axiom` with a clear TODO comment rather
than `sorry`, and open an issue tracking the dependency.

**2. Minimal axiom dependencies.**
Run `#print axioms <your_theorem>` and verify that the output contains only:
- `propext`
- `Classical.choice`
- `Quot.sound`
- Any explicitly declared `axiom` entries listed in `PROOF_STATUS.md`

If your theorem introduces new axiom dependencies not already in `PROOF_STATUS.md`,
explain why they are necessary in your pull request.

**3. Namespace consistency.**
All definitions must be inside the `ZFC4Lean` namespace. Use sub-namespaces
matching the module structure:
```
namespace ZFC4Lean.FOL      -- for FOL/
namespace ZFC4Lean.ZFC      -- for ZFC/
namespace ZFC4Lean.Ordinals -- for SetTheory/Ordinals.lean
```

**4. CI must pass.**
All pull requests must pass the GitHub Actions CI workflow (`lake build`).

---

## Priority Contribution Areas

The following areas are most needed and most impactful:

### Priority 1 — Substitution Lemmas (P1, High Impact)

The two substitution lemmas are currently declared as axioms:

```lean
-- ZFC4Lean/FOL/Semantics.lean
axiom satisfies_subst {M : Structure L} (σ : Assignment M) (t : Term L) (φ : Formula L) :
    satisfies σ (Formula.subst t 0 φ) ↔ satisfies (consAssign (evalTerm σ t) σ) φ

axiom satisfies_lift {M : Structure L} (σ : Assignment M) (a : M.carrier) (φ : Formula L) :
    satisfies (consAssign a σ) (Formula.lift 0 1 φ) ↔ satisfies σ φ
```

Proving these by structural induction on `Formula` would eliminate the two
non-standard axiom dependencies from the soundness theorem. This is the
single most impactful contribution possible.

### Priority 2 — Ordinal Trichotomy (P1)

```lean
-- ZFC4Lean/SetTheory/Ordinals.lean
theorem ordinal_trichotomy : ZFC ⊢ ... := by sorry
```

Proof strategy: derive from the Foundation axiom using transfinite induction.

### Priority 3 — Cantor's Theorem (P1)

```lean
-- ZFC4Lean/SetTheory/Cardinals.lean
theorem cantor_theorem : ZFC ⊢ all (CardinalLt (x 0) (powerset (x 0))) := by sorry
```

Proof strategy: formalize the diagonal argument within the explicit ZFC framework.

### Priority 4 — Schröder-Bernstein Theorem (P1)

```lean
-- ZFC4Lean/SetTheory/Cardinals.lean
theorem schroeder_bernstein : ZFC ⊢ ... := by sorry
```

Proof strategy: fixed-point argument; does not require Choice.

### Priority 5 — AC Equivalences (P1)

```lean
-- ZFC4Lean/SetTheory/ChoiceEquiv.lean
theorem AC_implies_WO : ZF ⊢ imp AC WO := by sorry
theorem WO_implies_ZL : ZF ⊢ imp WO ZL := by sorry
theorem ZL_implies_AC : ZF ⊢ imp ZL AC := by sorry
```

---

## Before Starting Work on Phase 2 or Phase 3

Please open an issue before starting work on:
- `ZFC4Lean/Constructible/` (Phase 2: Gödel's L)
- `ZFC4Lean/Forcing/` (Phase 3: Cohen forcing)

These modules require careful coordination to ensure the mathematical
architecture is consistent. The core team will create stub files and
design documents before implementation begins.

---

## Pull Request Process

1. **Open an issue first** for any non-trivial contribution, to discuss the
   approach before investing significant time.

2. **Fork the repository** and create a branch named after the theorem or
   feature: `feat/cantor-theorem`, `fix/substitution-lemma`, etc.

3. **Write the proof** following the verification standards above.

4. **Update `PROOF_STATUS.md`** to reflect the new proof status of any
   theorem you complete (change `sorry` to `proved`).

5. **Update `CHANGELOG.md`** under the `[Unreleased]` section.

6. **Submit a pull request** with:
   - A description of the mathematical content
   - The proof strategy used
   - The output of `#print axioms <main_theorem>`
   - Confirmation that CI passes

---

## Development Setup

```bash
# Install Lean 4 via elan
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh

# Clone the repository
git clone https://github.com/ZFC4Lean/ZFC4Lean.git
cd ZFC4Lean

# Build the project
lake build

# Verify the soundness theorem axiom dependencies
lake env lean --run scripts/check_soundness.lean
```

The project uses Lean 4.12.0 (fixed in `lean-toolchain`). Do not upgrade the
toolchain without opening an issue first.

---

## Mathematical Background

If you are new to the mathematical content, the following references are recommended:

- **Kunen, K.** (1980). *Set Theory: An Introduction to Independence Proofs*. North-Holland.
  (Standard reference for forcing and CH independence)
- **Jech, T.** (2003). *Set Theory* (3rd millennium ed.). Springer.
  (Comprehensive reference for all topics in this project)
- **Han, J.M., van Doorn, F.** (2021). *A formal proof of the independence of the
  continuum hypothesis*. arXiv:2102.02901.
  (The flypitch project in Lean 3 — the primary technical reference for this project)
- **Enderton, H.B.** (2001). *A Mathematical Introduction to Logic*. Academic Press.
  (Reference for the FOL framework)

---

## Questions

Open a GitHub issue or start a discussion in the GitHub Discussions tab.
For Lean-specific questions, the [Lean Zulip](https://leanprover.zulipchat.com/)
community is an excellent resource.
