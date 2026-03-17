# phkit

personal agent infrastructure for claude code and llm workflows.

## structure

```
phkit/
├── claude/
│   ├── templates/          # CLAUDE.md templates per project type
│   │   ├── ml-research.md
│   │   ├── web-backend.md
│   │   ├── data-pipeline.md
│   │   ├── writing-latex.md
│   │   └── general.md
│   └── rules/              # composable rule blocks
│       ├── coding-python.md
│       ├── coding-rust.md
│       ├── coding-typescript.md
│       ├── git.md
│       ├── comments.md
│       └── logging.md
├── specs/                  # reusable agent spec files
│   ├── eda-workflow.md
│   ├── experiment-tracking.md
│   ├── interactive-learning.md
│   └── research-agent.md
├── harness/                # agent loop patterns (reference, not runnable)
│   ├── patterns.md
│   └── checkpointing.md
├── tools/
│   └── templates/          # MCP tool scaffolds
│       ├── mcp-tool-python.py
│       └── mcp-tool-ts.ts
└── evals/
    └── README.md           # how to write evals
```

## how to use

### starting a new project

1. pick the right template from `claude/templates/`
2. copy it to the root of your new project as `CLAUDE.md`
3. open that project in claude code
4. begin with a planning conversation before touching code:

```
before writing any code, ask me questions to understand the requirements.
then write spec files into .claude/specs/. one file per concern.
read CLAUDE.md first.
```

### composing rules

templates pull from `claude/rules/`. if you need custom behaviour for a
project, append the relevant rule block to that project's `CLAUDE.md`.

### using specs

specs in `specs/` are starting points. copy the relevant one into your
project's `.claude/specs/` folder and edit it for the specific task.

### writing evals

see `evals/README.md`.