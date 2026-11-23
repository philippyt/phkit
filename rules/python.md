## python

- use `uv` for environments and dependency management when starting new projects.
- run `ruff check` and `ruff format --check` before finishing; run the configured type checker (`ty` or `pyright`) if present.
- type hints on all functions. no exceptions.
- one blank line between functions. not two.
- `pathlib.Path`, never `os.path`.
- f-strings for formatting, not `.format()` or `%`.
- `dataclasses` or `pydantic` for structured data, not plain dicts.
- `enum.Enum` (or `StrEnum`) for fixed sets of values, not bare string constants.
- context managers (`with`) for file and resource handling.
- comprehensions over loops only when single-line and clear; otherwise use a loop.
- no mutable default arguments. use `None` and assign inside.
- exception messages name the offending value and what was expected (`raise TypeError(...)`, never bare `raise TypeError`).

### imports and types

- group imports: stdlib, third-party, local (one blank line between groups). no wildcard or unused imports.
- use `from __future__ import annotations` when forward references are needed.
- prefer `X | None` over `Optional[X]`, `list[X]` over `List[X]`, `dict[K, V]` over `Dict[K, V]`.

### exceptions

- define custom exception classes for domain errors.
- never `except Exception: pass`. always log or re-raise.
- never use exceptions for control flow.

### tests (pytest)

- file names: `test_<module>.py`; function names: `test_<what>_<condition>_<expected>`.
- use fixtures for shared setup, not `setUp`/`tearDown`.
- use `@pytest.mark.parametrize` for repetitive cases.
- use `tmp_path` for filesystem tests; never hardcode paths.
- no stubs with `pass` or `...`. write real assertions or `@pytest.mark.skip(reason="...")`.
