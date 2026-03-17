# rule: python coding style

append this block to CLAUDE.md when working in python.

---

## python

- type hints on all functions. no exceptions.
- one blank line between functions. not two.
- `pathlib.Path` not `os.path`.
- f-strings for formatting. not `.format()` or `%`.
- `dataclasses` or `pydantic` for structured data. not plain dicts.
- `enum.Enum` for fixed sets of values. not string constants.
- context managers (`with`) for file and resource handling.
- list/dict/set comprehensions over loops where the intent is clear.
  if the comprehension exceeds one line, use a loop.
- no mutable default arguments. use `None` and assign inside.
- `raise TypeError(...)` not `raise TypeError` with no message.
  error messages name the offending value and what was expected.

### imports

stdlib first, then third-party, then local. one blank line between groups.
no wildcard imports (`from x import *`).
no unused imports.

### types

use `from __future__ import annotations` at the top of files that use
forward references.
prefer `X | None` over `Optional[X]` (python 3.10+).
prefer `list[X]` over `List[X]`, `dict[K, V]` over `Dict[K, V]`.

### exceptions

define custom exception classes for domain errors:
```python
class PipelineError(Exception):
    pass
```

never `except Exception: pass`. always log or re-raise.
never use exceptions for control flow.

### tests (pytest)

- test file names: `test_<module>.py`
- test function names: `test_<what>_<condition>_<expected>`
- use fixtures for shared setup. not setUp/tearDown.
- parametrize repetitive cases with `@pytest.mark.parametrize`.
- no stubs with `pass` or `...`. write real assertions or skip with
  `@pytest.mark.skip(reason="...")`.
- use `tmp_path` fixture for file tests. never hardcode paths in tests.