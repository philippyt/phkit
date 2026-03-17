# CLAUDE.md

## project

[describe the project in 2-3 sentences]

## stack

[list languages, frameworks, key libraries]

## behaviour

you are working on [project name].

before writing any code on a new feature or task, ask clarifying questions
until you understand the requirements. then write a spec file into
`.claude/specs/<feature>.md` before implementing.

make reasonable assumptions when something is underspecified. state the
assumption explicitly before proceeding. do not ask for confirmation on
obvious things.

when you hit an error, explain what went wrong and why before fixing it.
do not silently patch errors.

## code style

- no comments explaining what code does. only comment when the WHY is
  non-obvious. most functions need zero comments.
- no doc comments on private functions. public API only, one line.
- no monolithic files. if a file exceeds 300 lines, split it.
- one blank line between functions. not two.
- type hints on all python functions.
- no over-engineering. no abstraction layers with one implementation.
- prefer explicit over implicit. no magic.

## git

never run git commands. when done with changes, tell me:
1. which files to stage
2. what commit message to use (format: `type: lowercase description`)
3. whether to tag this commit

commit types: feat, fix, refactor, docs, ci, test

## testing

write tests alongside implementation, not after. use pytest for python.
no test stubs with `pass` or `...`. write real tests or skip.

## on errors

do not unwrap errors silently. propagate with proper error types.
in python: raise typed exceptions, not bare strings.
in rust: use `thiserror`, use `?`, no `unwrap()` outside tests.