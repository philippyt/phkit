# spec: experiment-tracking

## purpose

structured experiment logging for iterative ml work.
copy this into `.claude/specs/experiment-tracking.md`.

---

## experiments.md format

every experiment run appends one entry to `experiments.md` in the project root.
the file is append-only. never overwrite or delete entries.

```markdown
## [YYYY-MM-DD HH:MM] [short description of what changed]

**config**
- model: [architecture or model name]
- dataset: [dataset name and split sizes]
- key hyperparameters: [only the ones that changed from last run]
- seed: [random seed used]

**result**
- [metric name]: [value] (95% CI: [lower], [upper] if available)
- [secondary metric]: [value]
- train time: [duration]

**notes**
[one paragraph: why this was tried, what the result suggests,
what to try next]
```

failed runs use this format:

```markdown
## [YYYY-MM-DD HH:MM] [description] — FAILED

**config**
[same as above]

**error**
[error message and where it occurred]

**notes**
[what to try instead]
```

## when to log

log an entry:
- after every complete training run
- after every failed run
- after every significant preprocessing change
- after any change to the evaluation setup

## experiment numbering

do not number experiments. use timestamps and descriptions.
the description should name what changed: "add dropout 0.3 to layer 2",
"switch from adam to adamw", "increase batch size to 256".

## baseline

always log the baseline first before any experiments.
the baseline entry should state clearly what it is:
"baseline: [model] with default hyperparameters, no tuning".

## reading experiments.md

before suggesting a new experiment, read the full `experiments.md`.
do not suggest experiments that have already been tried with the same config.
identify the current best result and build from it.