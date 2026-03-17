# rule: rust coding style

append this block to CLAUDE.md when working in rust.

---

## rust

- no `unwrap()` except in tests. use `?` everywhere.
- no `.clone()` to satisfy the borrow checker. design proper ownership.
  use references, lifetimes, or restructure the data flow.
  if you find yourself adding `.clone()`, stop and rethink.
- `&str` not `String` in function arguments where possible.
  do not default to owned types to dodge lifetimes.
- `if let` and `map`/`and_then` over verbose match arms where 2+ arms
  are unreachable or trivial.
- keep trait bounds minimal. only add `Clone + Debug + Send + Sync`
  where actually required. do not pre-emptively add bounds.
- no over-engineering. no abstraction layers with one implementation.
  keep it direct.
- no monolithic files. 300 line limit. split into modules.
- use `thiserror` for error types. not string errors.
- run `cargo clippy -- -D warnings` before finishing. fix everything.
- run `cargo fmt` before finishing.
- run `cargo test` before finishing.

### errors

```rust
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    #[error("io error: {0}")]
    Io(#[from] std::io::Error),
    #[error("not found: {0}")]
    NotFound(String),
}
```

every function that can fail returns `Result<T, AppError>` or a
relevant sub-error type. never `Result<T, String>`.

### comments

no comments on obvious code. no `// create a new vector` above `Vec::new()`.
no `// return the result` above a return statement.
comment only when the WHY is non-obvious. most functions need zero comments.
no doc comments on private functions.
public API: one-line doc comment maximum. no fluff.
no module doc comments (`//!`) unless the module is genuinely non-obvious.

### git

never run git commands. when done, tell me:
1. which files to stage
2. commit message (`type: lowercase description`)
3. whether to tag

### when explaining rust errors

when i make a borrow checker or lifetime error, explain what the compiler
is complaining about and why before writing the fix. do not silently patch.