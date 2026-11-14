
# References

Key references for the mathematics and formalization in ZFC4Lean.

---

## Primary Formalization Reference

**Han, J.M., van Doorn, F.** (2021). A formal proof of the independence of
the continuum hypothesis. *CPP 2020*, pp. 353–366.
DOI: [10.1145/3372885.3373826](https://doi.org/10.1145/3372885.3373826)
arXiv: [2102.02901](https://arxiv.org/abs/2102.02901)

The flypitch project in Lean 3. ZFC4Lean follows the same syntactic approach
(explicit FOL language, Hilbert proof system, Boolean-valued forcing) redesigned
for Lean 4 and extended to include Gödel's L.

**Han, J.M., van Doorn, F.** (2019). A formalization of forcing and the
unprovability of the continuum hypothesis. *ITP 2019*, LIPIcs 141, 19:1–19:19.
DOI: [10.4230/LIPIcs.ITP.2019.19](https://doi.org/10.4230/LIPIcs.ITP.2019.19)

---

## Set Theory

**Kunen, K.** (1980). *Set Theory: An Introduction to Independence Proofs*.
North-Holland. ISBN: 978-0-444-86839-8

Standard reference for forcing and CH independence. Chapter 6 covers the
constructible universe L; Chapter 7 covers forcing.

**Jech, T.** (2003). *Set Theory* (3rd millennium ed.). Springer.
ISBN: 978-3-540-44085-7

Comprehensive reference. Chapter 13 covers the constructible universe;
Chapters 14–15 cover forcing.

---

## Original Papers

**Gödel, K.** (1938). The consistency of the axiom of choice and of the
generalized continuum hypothesis. *Proceedings of the National Academy of
Sciences*, 24(12), 556–557.

**Gödel, K.** (1940). *The Consistency of the Axiom of Choice and of the
Generalized Continuum Hypothesis with the Axioms of Set Theory*.
Princeton University Press.

**Cohen, P.J.** (1963). The independence of the continuum hypothesis.
*Proceedings of the National Academy of Sciences*, 50(6), 1143–1148.

**Cohen, P.J.** (1964). The independence of the continuum hypothesis, II.
*Proceedings of the National Academy of Sciences*, 51(1), 105–110.

---

## Mathematical Logic

**Enderton, H.B.** (2001). *A Mathematical Introduction to Logic* (2nd ed.).
Academic Press. ISBN: 978-0-12-238452-3

Reference for the FOL framework: syntax, semantics, Hilbert proof systems,
soundness and completeness.

**Shoenfield, J.R.** (1967). *Mathematical Logic*. Addison-Wesley.

Classic reference for mathematical logic and set theory.

---

## Modern Set Theory

**Woodin, W.H.** (2026). The AD⁺ duality program, the HOD conjecture, and
the Ultimate-L conjecture. *Japanese Journal of Mathematics*, 21, 165–254.
DOI: [10.1007/s11537-026-2541-4](https://doi.org/10.1007/s11537-026-2541-4)

Current state of the art in set theory. Relevant for understanding the
broader context of CH independence and the Ultimate-L program.

**Kanamori, A.** (1994). *The Higher Infinite*. Springer.

Reference for large cardinal axioms.

---

## Lean 4 and Mathlib

**The Mathlib Community** (2020). The Lean Mathematical Library.
*CPP 2020*, pp. 367–381.

**Lean 4 Documentation**: https://leanprover.github.io/lean4/doc/

**Mathlib4**: https://github.com/leanprover-community/mathlib4

---

## Related Formalization Projects

**Trélat, V.** (2026). ZFLean: a framework for set-level mathematics in Lean.
arXiv: [2604.24195](https://arxiv.org/abs/2604.24195)

ZFC ergonomics layer over Mathlib's ZFSet. Different approach from ZFC4Lean
(semantic model vs. syntactic axiom system).

**Saitou, S., Noguchi, M.** (2026). Mechanizing Gödel's incompleteness
theorems and provability logic. arXiv: [2609.13780](https://arxiv.org/abs/2609.13780)

Lean 4 formalization of Gödel's incompleteness theorems. Related to ZFC4Lean's
meta-mathematical goals.

**Manthe, S.** (2025). A formalization of Borel determinacy in Lean.
arXiv: [2502.03432](https://arxiv.org/abs/2502.03432)

Lean 4 formalization of Martin's theorem (Borel determinacy). Related to
ZFC4Lean's descriptive set theory goals.
