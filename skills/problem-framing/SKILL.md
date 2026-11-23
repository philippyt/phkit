---
name: problem-framing
description: Frame ambiguous problems before coding ("talk first, then harden"). Use at the start of a large or underspecified feature, architecture decision, or refactor when the why and constraints are not yet settled.
---

# problem-framing

reconstruct the problem space before proposing a solution, then harden settled judgments into a concise, verification-backed plan.

## phase 1: listen and investigate (why)

1. read the relevant code, config, tests, and docs first. never ask a question the repository can answer.
2. reconstruct the problem concisely:
   - intent and stakes (why this matters)
   - settled constraints and tradeoffs
   - what already exists or has been tried
3. surface contradictions and unresolved decisions.
   - every question must state *why* available evidence cannot settle it.
   - do not invent silent compromises for contradictory requirements.
4. if multiple viable solutions survive the constraints, present them with factual tradeoffs and stop for alignment. do not write implementation code yet.

## phase 2: harden (what -> plan)

once the user settles the open decisions:

1. convert settled judgments into a concise plan:
   - what each step accomplishes
   - why it exists
   - dependencies on other steps
   - how to verify it (command, test, or observable check)
2. do not paste speculative implementation code into the plan.
3. only write a durable spec file (e.g. `docs/specs/<topic>.md`) if the project genuinely benefits from a lasting reference beyond the current task. link to authoritative code and config instead of duplicating them.
