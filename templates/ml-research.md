# AGENTS.md

extends global `AGENTS.md`.

## project

[task, dataset, primary evaluation metric, and goal]

## stack

python (`uv`), pytorch (or transformers/jax if applicable), polars or pandas, ruff, pytest.

## commands

- sync: `uv sync`
- test: `uv run pytest`
- lint: `uv run ruff check .`

## ml conventions

- fix random seeds at the top of every script (`random`, `numpy`, `torch`; default `42`).
- prefer explicit training loops over trainer abstractions unless the project specifically uses Hugging Face Trainer or Lightning.
- use `pathlib.Path`, never `os.path`. no hardcoded data or artifact paths — pass via config or CLI arguments.
- compare models on the exact same train/val/test split across all runs.
- report metrics with confidence intervals where possible (bootstrap, `n=1000`).
- write tests for data loading, splits, and preprocessing — not for model forward passes.

## experiments and eda

- use the `eda-workflow` skill before modelling on a new dataset.
- use the `experiment-tracking` skill to log every completed and failed run to `experiments.md` (append-only; never overwrite entries).
- state the primary metric explicitly in every experiment entry and log mid-run failures with the error before exiting.

## planning

for non-trivial pipeline or modelling changes, confirm before coding:
- task and evaluation metric
- dataset schema and split strategy
- baseline to establish first
- highest-risk parts of the pipeline
