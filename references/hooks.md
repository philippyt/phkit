# hooks and review gates

instructions in `AGENTS.md` guide model behavior, but deterministic boundaries belong in hooks.

## pre-tool hooks for git safety

harnesses that support `PreToolUse` hooks (such as Claude Code) can inspect shell commands before execution and block forbidden actions deterministically (exit code `2` blocks the tool call and returns stderr to the model).

example `.claude/settings.json` hook entry:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash path/to/git-guard.sh"
          }
        ]
      }
    ]
  }
}
```

example `git-guard.sh` (blocks force-push, direct push to `main`, and `Co-Authored-By` trailers; extend with `git\s+(add|commit|push|tag)` if enforcing strict `git-manual.md`):

```bash
#!/usr/bin/env bash
set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

if echo "$cmd" | grep -Eq 'git\s+push.*(--force|-f)|git\s+push\s+\S+\s+(main|master)\b'; then
  echo "blocked: force-push or direct push to main/master is not allowed" >&2
  exit 2
fi

if echo "$cmd" | grep -Eqi 'co-authored-by'; then
  echo "blocked: Co-Authored-By trailers are not allowed" >&2
  exit 2
fi
```

## pre-push and PR review gates

before pushing or opening a PR on non-trivial diffs (especially 300+ lines):
1. run an independent review pass before `git push` / `gh pr create`:
   - **CLI reviewer**: run `coderabbit review --plain` (or equivalent CLI review tool) locally and address findings before creating the PR.
   - **independent agent review**: delegate `git diff` to a fresh subagent with no shared session history so it reviews the diff cold against the acceptance criteria.
2. let the agent draft the PR description directly from the diff (concise, factual: what changed, why, verification run) rather than writing large PR descriptions manually.
