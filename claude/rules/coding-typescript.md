# rule: typescript coding style

append this block to CLAUDE.md when working in typescript.

---

## typescript

- strict mode always. `"strict": true` in tsconfig.
- no `any`. if you need an escape hatch, use `unknown` and narrow it.
- no `!` non-null assertions. check for null explicitly.
- prefer `type` over `interface` for object shapes unless the type
  needs to be extended or implemented by a class.
- no `var`. `const` by default. `let` only when reassignment is needed.
- no implicit returns in functions that return a value.
- async/await over raw promises. no `.then().catch()` chains unless
  composing promise utilities.
- no silent error swallowing:
  ```typescript
  // bad
  try { ... } catch (_) {}
  // good
  try { ... } catch (err) { throw new Error(`context: ${err}`) }
  ```
- `zod` for runtime validation of external data (api responses, env vars).
  never trust external data without parsing it.

### naming

- `PascalCase` for types, interfaces, classes, components
- `camelCase` for variables, functions, methods
- `SCREAMING_SNAKE_CASE` for constants that are truly constant
- file names: `kebab-case.ts`

### imports

no default exports except for react components and next.js pages.
named exports everywhere else. makes refactoring and grepping easier.

### comments

no comments on obvious code. only comment when the WHY is non-obvious.
no jsdoc on private functions. public API only, one line.

### tests (vitest)

- test file: `<module>.test.ts` co-located with the module
- no stubs with empty assertions. write real assertions or skip.
- mock external dependencies, not internal logic.