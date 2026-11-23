## logging and observability

use Python's `logging` module (or structured logger in TS/Rust), never `print()` except for explicit CLI user output.

```python
import logging

logger = logging.getLogger(__name__)
```

levels:
- `DEBUG`: detailed trace, off in production
- `INFO`: normal operation milestones (job started, stage completed)
- `WARNING`: unexpected but recoverable condition
- `ERROR`: operation failed
- `CRITICAL`: system-level failure

include enough context to reproduce the issue without logging secrets, tokens, or PII:
```python
logger.error("failed to load file: path=%s error=%s", path, err)
```

### agent run logging

for multi-step agent runs, append one JSON object per step to a `.jsonl` log before processing the output so mid-step crashes leave a readable trace:

```json
{"run_id": "...", "step": 1, "tool": "tool_name", "input": {}, "output": {}, "latency_ms": 240, "ts": "2026-11-23T18:00:00+00:00"}
```
