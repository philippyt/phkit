## typescript

- `"strict": true` in `tsconfig.json` always.
- no `any`. use `unknown` and narrow it.
- no `!` non-null assertions. check for `null`/`undefined` explicitly.
- prefer `type` over `interface` for object shapes unless extending or implementing a class contract.
- `const` by default; `let` only when reassignment is required; never `var`.
- `async`/`await` over `.then().catch()` chains unless composing promise utilities (`Promise.all`, etc.).
- never swallow errors silently; rethrow with context or handle explicitly.
- validate all external data (API responses, env vars, tool inputs) at the boundary with `zod` (or `valibot`).

### naming and exports

- `PascalCase` for types, interfaces, classes, and components.
- `camelCase` for variables, functions, and methods.
- `SCREAMING_SNAKE_CASE` for true constants.
- `kebab-case.ts` for file names.
- named exports everywhere except framework-mandated defaults (Next.js pages, etc.).

### tests (vitest)

- co-locate tests as `<module>.test.ts`.
- mock external dependencies, not internal logic.
- no stubs with empty assertions.
