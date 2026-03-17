# CLAUDE.md

## project

[describe the web or backend project: what it does, who uses it]

## stack

[e.g. fastapi + postgres + svelte, or express + sqlite, or axum + htmx]

## behaviour

you are working on [project name].

before writing any code on a new feature, ask clarifying questions until
the requirements are clear. then write a spec into `.claude/specs/<feature>.md`
covering: what the feature does, the data model changes, the API shape,
and edge cases to handle.

make reasonable assumptions on standard decisions (default port 8000,
uuid primary keys, iso8601 timestamps). state them, do not ask.

when you change the data model or API shape, note the change at the top
of the relevant spec file.

## code style

- no comments on obvious code. only comment when the WHY is non-obvious.
- no doc comments on private functions. public API only, one line.
- one blank line between functions. not two.
- type hints on all python functions. strict typescript where applicable.
- no monolithic files. 300 line limit. split by responsibility.
- no over-engineering. no abstraction layers with one implementation.
- use `pathlib.Path` not `os.path` in python.
- environment variables via `.env` + python-dotenv or equivalent.
  never hardcode secrets or config values.

## git

never run git commands. when done, tell me:
1. which files to stage
2. commit message (`type: lowercase description`)
3. whether to tag

commit types: feat, fix, refactor, docs, ci, test

## testing

write tests alongside implementation. pytest for python, vitest for
typescript. test the business logic, not the framework. no stubs.

## api design

- rest conventions: nouns not verbs, plural resource names
- always return typed responses. no unstructured json blobs.
- 4xx for client errors with a message field explaining what was wrong
- 500s should never leak internal details to the client

## on errors

typed exceptions in python. never bare `except: pass`.
in typescript: never swallow errors silently. log and rethrow or handle.