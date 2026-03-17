# rule: git

append this block to CLAUDE.md for any project with version control.

---

## git

never run git commands. this includes:
- `git commit`
- `git add`
- `git push`
- `git tag`
- `git init`
- `git config`

never configure git user, email, or authorship.
never add co-authored-by trailers.

when you have finished all changes, tell me exactly:
1. which files to stage (list them individually)
2. what commit message to use
3. whether to tag this commit and what tag name

i will run all git commands myself.

## commit message format

```
type: lowercase description
```

no period at the end. lowercase throughout. 72 character limit.

types:
- `feat`: new feature
- `fix`: bug fix
- `refactor`: restructuring without behaviour change
- `docs`: documentation only
- `ci`: ci/cd changes
- `test`: tests only
- `chore`: build system, dependencies

## gitignore strategy

for new projects, the `.gitignore` contains exactly one line:

```
*
```

this ignores everything by default. i manually `git add -f` only the
files i want tracked. this prevents ai metadata files, `.claude/`
directories, temp files, and build artifacts from ever reaching the repo.

do not create `.claude/`, `CLAUDE.md` inside subdirectories, or any
ai metadata files unless explicitly asked.

## tagging

suggest a version tag after sessions that complete a meaningful milestone.
use semver: `vMAJOR.MINOR.PATCH`.

- patch: bug fix or small improvement
- minor: new feature
- major: breaking change or public release