# rule: logging and observability

append this block to CLAUDE.md for agent workflows, long-running scripts,
or any project where you need to understand what happened after the fact.

---

## logging

use python's `logging` module. not `print()` for anything other than
explicit user-facing output.

```python
import logging
logger = logging.getLogger(__name__)
```

log levels:
- `DEBUG`: detailed trace, off in production
- `INFO`: normal operation milestones (job started, step completed)
- `WARNING`: something unexpected but recoverable
- `ERROR`: something failed, operation did not complete
- `CRITICAL`: system-level failure

log messages include enough context to reproduce the issue:
```python
# bad
logger.error("failed to load file")

# good
logger.error("failed to load file: path=%s, error=%s", path, err)
```

never log sensitive data: api keys, passwords, personal data.

## experiment logging (ml projects)

every experiment run appends to `experiments.md`:

```markdown
## [ISO timestamp] [short description]
config: key=value, key=value
result: metric=value (ci: lower, upper)
notes: why this was tried and what it suggests
```

never overwrite previous entries. the file is append-only.
if a run fails, log it:

```markdown
## [ISO timestamp] [short description] — FAILED
config: key=value
error: [error message]
notes: what to try instead
```

## agent run logging

for multi-step agent runs, log to a jsonl file: one json object per step.

```json
{"step": 1, "action": "tool_name", "input": {...}, "output": {...}, "latency_ms": 240, "ts": "..."}
```

this gives you full replay capability. always write the log before
processing the output, so a crash mid-step leaves a partial but
readable trace.