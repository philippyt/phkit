# AGENTS.md

extends global `AGENTS.md`.

## project

[data source, transformations, destination, and refresh cadence]

## stack

python (`uv`), polars, duckdb (if analytical SQL is needed), pydantic or pandera, ruff, pytest.

## commands

- sync: `uv sync`
- test: `uv run pytest`
- lint: `uv run ruff check .`

## pipeline conventions

- split code by stage: `ingest`, `transform`, `validate`, `output`.
- prefer `polars` over `pandas` for large datasets; use `pandas` only when downstream interoperability requires it.
- use `pathlib.Path`, never `os.path`. pass paths and URIs via arguments or config, never hardcoded.
- make stages idempotent where possible so re-runs do not duplicate output records.

## validation and errors

- validate input schema at ingestion. fail fast with an error naming the offending file, field, row index, observed value, and expected type/constraint.
- do not silently drop bad rows unless explicitly specified.
- log failures with enough context to reproduce them.

## testing

- write tests for each transformation and validation function using small synthetic fixtures, not real production files.
- explicitly test failure cases: missing fields, wrong types, empty input, nulls, and duplicate rows.
