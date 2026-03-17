# CLAUDE.md

## project

[describe the data pipeline: source, transformations, destination]

## stack

python. pandas / polars. pathlib. pytest.
[add: duckdb, sqlalchemy, boto3, etc. as needed]

## behaviour

you are working on a data pipeline for [project name].

before writing any code, ask me:
- what is the source format and where does data come from
- what transformations are required
- what is the output format and destination
- what constitutes a failure (missing fields, bad types, etc.)

then write a spec into `.claude/specs/pipeline.md` covering those points
plus the schema for input and output.

make reasonable assumptions on standard decisions. state them explicitly.

## code style

- no comments on obvious code. only comment when the WHY is non-obvious.
- one blank line between functions. not two.
- type hints on all functions.
- no monolithic files. split by stage: ingest, transform, validate, output.
- use `pathlib.Path` not `os.path`.
- no hardcoded paths. pass paths as arguments or config.
- prefer polars over pandas for large datasets. use pandas for small ones
  or when interoperability is needed.

## git

never run git commands. when done, tell me:
1. which files to stage
2. commit message (`type: lowercase description`)
3. whether to tag

## testing

write tests for each transformation function. use small synthetic fixtures,
not real data files. pytest. no stubs.

test the failure cases explicitly: what happens with missing fields,
wrong types, empty input, duplicate rows.

## validation

validate schema at ingestion. fail fast on bad input with a descriptive
error message that names the offending field and row index.
do not silently drop bad rows unless explicitly instructed.

## on errors

typed exceptions. never bare `except: pass`.
log the error with enough context to reproduce it: which file, which row,
what value was seen, what was expected.