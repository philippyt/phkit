# phkit

personal agent configuration, rules, skills, and project templates for multi-harness workflows (T3 Code, Claude Code, Codex, Antigravity, OpenCode).

## structure

- [AGENTS.md](AGENTS.md) — global baseline instructions synced across harnesses
- [templates/](templates/) — lean project-level `AGENTS.md` starters (`general`, `ml-research`, `web-backend`, `data-pipeline`, `writing-latex`)
- [rules/](rules/) — opt-in rule blocks (`python`, `rust`, `typescript`, `comments`, `git-manual`, `git-agent`, `logging`)
- [skills/](skills/) — `SKILL.md` workflows loaded on demand (`problem-framing`, `distill-judgment`, `eda-workflow`, `experiment-tracking`, `interactive-learning`, `research-agent`)
- [references/](references/) — reference guides and scaffolds (`harness-patterns.md`, `evals.md`, `hooks.md`, `mcp-templates/`)
- [scripts/](scripts/) — `phkit.ps1` (Windows) and `phkit.sh` (macOS/Linux) for syncing global config and bootstrapping projects

## usage

### sync global rules and skills

syncs `AGENTS.md` and `skills/` into your local harness directories (`~/.claude`, `~/.codex`, `~/.gemini`, `~/.config/opencode`, `~/.agents/skills`) so new projects in T3 Code and CLI harnesses inherit them automatically.

Windows (PowerShell):
```powershell
.\scripts\phkit.ps1 sync
```

macOS / Linux:
```bash
./scripts/phkit.sh sync
```

### initialize a project `AGENTS.md`

composes a project template with optional rule blocks into a target directory.

```powershell
.\scripts\phkit.ps1 init ml-research -Target C:\path\to\project -Rules python,logging
```

```bash
./scripts/phkit.sh init ml-research /path/to/project --rules python,logging
```

add `-ClaudePointer` (PowerShell) or `--claude-pointer` (bash) to also create a `CLAUDE.md` containing `@AGENTS.md` for tools that look only for `CLAUDE.md`.
