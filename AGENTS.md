# AGENTS.md

global baseline rules for coding agents across harnesses. project-level `AGENTS.md` files override or extend these rules.

## abstraction and problem framing

match the abstraction level of the request:

- **why** (problem, intent, constraints, stakes): investigate the codebase and context first. reconstruct the problem, challenge the framing if warranted, and return candidate solutions plus unresolved decisions before writing code.
- **what** (chosen solution and acceptance criteria): design the implementation and execute.
- **how** (specific procedure): execute directly.

investigate before asking questions. never ask something the repository, logs, or configuration can answer.

every question must state *why* it is unresolved from available evidence. do not invent silent compromises for contradictory constraints — surface the contradiction for a decision.

when making a reasonable assumption on an underspecified detail, state the assumption and the reason (*because*) explicitly. do not ask for confirmation on standard defaults.

when writing a plan, state what each step accomplishes, why it exists, what it depends on, and how to verify it. do not paste speculative implementation code into plans.

## verification and errors

verify changes against acceptance criteria through actual execution (tests, typecheck, lint, build) rather than visual inspection alone.

when an error or test failure occurs, explain what went wrong and which layer failed (why, what, or how) before fixing it. do not silently patch errors.

propagate errors with typed exceptions or `Result` types. never swallow errors silently.

## comments

comments explain constraints or non-obvious decisions, never what the code does. if the reason is visible from reading the code, omit the comment.

- no doc comments on private functions in any language.
- public API: one-line summary maximum unless the return value or contract is non-obvious.
- no module-level doc comments unless the module's purpose is unclear from its name and contents.

## documentation

- keep task history and conversations out of code and all user documentation, including `README.md`.
- keep documentation concise and factual. no punchy slogans or promotional language.
- do not commit superfluous documentation or scatter unnecessary markdown files through the repository.
- new documents need a clear purpose beyond recording the current task.
- link to authoritative code and configuration instead of duplicating details.

## code discipline

- explicit over implicit. no hidden magic.
- no over-engineering. no abstraction layers with a single implementation.
- no monolithic files. split by responsibility once a file grows past ~300 lines.
- write real tests alongside implementation. no stub tests with `pass`, `...`, or empty assertions.

## git

- commit format: `type: lowercase description` (72 char max, no trailing period). types: `feat`, `fix`, `refactor`, `docs`, `ci`, `test`, `chore`.
- never force-push, rewrite shared history, or add `Co-Authored-By` trailers.
- never commit secrets, `.env` files, or local agent metadata unless explicitly tracked.
- for large diffs, draft the commit message or PR description from the actual diff so the user can review and edit rather than write it from scratch.
- if a project requires strict manual git (no agent git commands), override this section with `rules/git-manual.md` or enforce it with a `PreToolUse` hook.
