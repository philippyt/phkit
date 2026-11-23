## rust

- no `unwrap()` outside tests. use `?` everywhere.
- no `.clone()` to satisfy the borrow checker. design proper ownership with references, lifetimes, or restructured data flow. if you reach for `.clone()`, stop and rethink.
- prefer `&str` over `String` and `&[T]` over `Vec<T>` in function arguments where ownership is not required.
- prefer `if let` and `map`/`and_then` over verbose `match` blocks with trivial or unreachable arms.
- keep trait bounds minimal; only add `Clone`, `Debug`, `Send`, `Sync` where required.
- use `thiserror` for library/domain errors (and `anyhow` only at binary/CLI boundaries if appropriate). never `Result<T, String>`.
- run `cargo clippy -- -D warnings`, `cargo fmt --check`, and `cargo test` before finishing.

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

### explaining borrow checker errors

when the user hits a borrow checker or lifetime error, explain what the compiler is rejecting and why before writing the fix. do not silently patch.
