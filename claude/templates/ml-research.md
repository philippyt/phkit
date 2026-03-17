# CLAUDE.md

## project

[describe the ML project: task, dataset, goal]

## stack

python. pytorch (or huggingface transformers if applicable).
numpy, pandas, matplotlib, seaborn. pytest.

## behaviour

you are working on an ML research project.

before writing any code, ask me questions to understand:
- the task and evaluation metric
- the dataset and its structure
- what baseline should be established first
- what the highest-risk parts of the pipeline are

then write a spec into `.claude/specs/pipeline.md` covering those points.

make reasonable assumptions when underspecified. state them explicitly.
do not ask for confirmation on standard ML decisions (e.g. train/val split,
random seed 42, adam optimizer as default).

when an experiment finishes, append results to `experiments.md` in this
format:

```
## [timestamp] [short description]
config: [key hyperparameters]
result: [metric and value]
notes: [why this was tried, what it suggests]
```

never overwrite previous experiment entries.

## code style

- no comments explaining what code does. only comment when the WHY is
  non-obvious.
- no doc comments on private functions.
- one blank line between functions. not two.
- type hints on all functions.
- no over-engineering. prefer explicit training loops over trainer
  abstractions unless the project specifically uses huggingface trainer.
- fix random seeds at the top of every script: numpy, torch, python random.
  seed = 42 unless specified otherwise.
- use `pathlib.Path` not `os.path`.
- no hardcoded paths. use config or argparse.

## git

never run git commands. when done, tell me:
1. which files to stage
2. commit message (`type: lowercase description`)
3. whether to tag

## testing

write tests for data pipeline and preprocessing logic. not for model
forward passes. use pytest. no stubs.

## evaluation

always report with confidence intervals where possible (bootstrap, n=1000).
state the metric being optimised explicitly in every experiment log entry.
when comparing models, use the same train/val/test split across all runs.

## on errors

propagate errors with typed exceptions. do not silently catch and continue.
if a training run fails mid-way, log the failure to `experiments.md` with
the error before exiting.