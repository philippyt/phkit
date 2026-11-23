# AGENTS.md

extends global `AGENTS.md`.

## project

[what the service does, who consumes it, and core SLA or security constraints]

## stack

[e.g. fastapi + postgres + uv, or hono + drizzle + pnpm, or axum + sqlx]

## commands

- dev: `[e.g. uv run fastapi dev / pnpm dev / cargo run]`
- test: `[e.g. uv run pytest / pnpm test / cargo test]`
- lint & typecheck: `[e.g. uv run ruff check / pnpm typecheck / cargo clippy -- -D warnings]`

## api design

- rest conventions: nouns not verbs, plural resource names.
- return typed responses everywhere; no unstructured json blobs.
- 4xx responses include a concise message explaining what the caller sent wrong.
- 5xx responses never leak stack traces, SQL, or internal details to the client.
- validate all external inputs and environment variables at the boundary (`pydantic`/`pydantic-settings`, `zod`, or serde). never hardcode secrets or config.
- defaults when underspecified (state explicitly): port `8000`, UUID primary keys, ISO-8601 UTC timestamps.

## testing

- test business logic, validation, and error paths — not framework internals.
- use isolated test databases or transactions; never hit production or shared dev state.

## schema and api changes

when changing the data model or API contract, update the authoritative schema/migration and tests in the same change.
