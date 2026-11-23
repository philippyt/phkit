## git (agent-assisted / worktree workflow)

compatible with T3 Code worktrees and branch-based PR workflows.

- commit format: `type: lowercase description` (72 char max, no trailing period). types: `feat`, `fix`, `refactor`, `docs`, `ci`, `test`, `chore`.
- stage only intended files explicitly — never `git add -A` over untracked scratch files, secrets, or local agent metadata.
- never push directly to `main`/`master`, never force-push shared branches, and never add `Co-Authored-By` trailers.
- before pushing or opening a PR on non-trivial diffs, run verification (tests, lint, typecheck) and an independent review pass (fresh subagent review or CLI reviewer such as CodeRabbit; see `references/hooks.md`).
- draft PR descriptions directly from the diff: concise, factual summary of what changed, why, and how it was verified.
