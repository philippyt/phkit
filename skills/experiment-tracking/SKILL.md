---
name: experiment-tracking
description: Append-only structured experiment logging in experiments.md for iterative ML work. Use before proposing new ML experiments and after every completed or failed training, preprocessing, or evaluation run.
---

# experiment-tracking

maintain a factual, append-only log in `experiments.md` at the project root. never overwrite or delete previous entries.

## before proposing a new experiment

1. read the full `experiments.md`.
2. identify the current best result and its split/metric setup.
3. do not propose configs already tried with the same setup unless explicitly testing reproducibility.
4. always log a clear baseline first (`baseline: [model] with default hyperparameters, no tuning`).

## when to log

append an entry after:
- every completed training run
- every failed run
- every significant preprocessing or feature change
- every change to the evaluation setup

do not number experiments; use timestamps and a description naming what changed (e.g. `add dropout 0.3 to layer 2`, `switch adam to adamw`).

## entry format

```markdown
## [YYYY-MM-DD HH:MM] [what changed]

**config**
- model: [architecture or model name]
- dataset: [dataset name and split sizes]
- key hyperparameters: [only those changed from the previous run]
- seed: [random seed]

**result**
- [primary metric]: [value] (95% CI: [lower], [upper] if available)
- [secondary metric]: [value]
- train time: [duration]

**notes**
[why this was tried, what the result indicates, and what to test next]
```

failed run format:

```markdown
## [YYYY-MM-DD HH:MM] [what changed] — FAILED

**config**
[same as above]

**error**
[error message and where it failed]

**notes**
[what to adjust before retrying]
```
