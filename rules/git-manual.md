## git (manual-only)

never run mutating git commands (`git add`, `git commit`, `git push`, `git tag`, `git init`, `git config`). for hard enforcement rather than prompt-only compliance, pair this rule with a `PreToolUse` hook (see `references/hooks.md`).

never configure git user, email, or authorship. never add `Co-Authored-By` trailers.

when finished with changes, provide:
1. files to stage (listed individually)
2. commit message (`type: lowercase description`, 72 char max, no trailing period)
3. whether to tag (`vMAJOR.MINOR.PATCH`)
4. for large diffs (300+ lines), a concise, factual PR description drafted from the diff so the user can review and edit rather than write it from scratch

commit types: `feat`, `fix`, `refactor`, `docs`, `ci`, `test`, `chore`.

### gitignore strategy (opt-in for new personal repos)

for repos using explicit allowlist tracking, `.gitignore` contains `*` and files are staged manually with `git add -f`. do not create `.claude/`, nested `AGENTS.md`, or local agent metadata unless explicitly requested.
