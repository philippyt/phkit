# harness patterns

reference document for agent execution loop design.
these are patterns, not runnable code. implement them per-project
in whatever language fits.

---

## core execution loop

the minimal viable harness:

```python
def run(task, tools, max_steps=50):
    state = State(task=task, history=[])

    for step in range(max_steps):
        action = agent.think(state)

        if action.type == "finish":
            return action.result

        result = execute(action, tools)
        state = state.update(step=step, action=action, result=result)

        if budget_exceeded(state):
            raise BudgetError(f"exceeded {max_steps} steps")

    raise MaxStepsError("did not finish within step budget")
```

key properties:
- state is owned by the harness, not the agent
- agent receives a view of state, returns an action
- harness executes the action, updates state
- hard cap on iterations — never infinite

---

## state management

state is explicit and serialisable. it is not the raw message history.

```python
@dataclass
class State:
    task: str
    step: int
    history: list[StepRecord]
    context: dict[str, Any]  # structured facts, not chat turns

@dataclass
class StepRecord:
    step: int
    action: Action
    result: ToolResult
    ts: str
```

why: raw message history grows unboundedly and degrades model quality.
structured state lets you summarise, checkpoint, and replay.

compress history by summarising completed phases into context:
```python
if len(state.history) > 20:
    summary = summarise_history(state.history[-20:])
    state.context["phase_summary"] = summary
    state.history = state.history[-5:]  # keep recent window only
```

---

## tool execution layer

the harness intercepts all tool calls. the agent never calls tools directly.

```python
def execute(action: Action, tools: dict[str, Tool]) -> ToolResult:
    if action.tool not in tools:
        return ToolResult(error=f"unknown tool: {action.tool}")

    tool = tools[action.tool]

    try:
        validated = tool.input_schema.parse(action.params)
    except ValidationError as e:
        return ToolResult(error=f"invalid params: {e}")

    try:
        output = tool.call(validated)
        log_tool_call(action, output)
        return ToolResult(output=output)
    except ToolError as e:
        log_tool_call(action, error=e)
        return ToolResult(error=str(e))
```

this gives you:
- validation before execution
- logging of every call
- consistent error format the agent can reason about
- swap real tools for mocks in tests

---

## error handling and retry

the agent receives errors as observations, not exceptions.
it can decide to retry, try a different tool, or give up.

```python
# in the tool result returned to the agent:
ToolResult(
    error="rate limited: retry after 30s",
    retryable=True,
    retry_after=30
)
```

the harness enforces retry limits:
```python
retry_counts: dict[str, int] = {}

if result.retryable:
    key = f"{action.tool}:{action.params}"
    retry_counts[key] = retry_counts.get(key, 0) + 1
    if retry_counts[key] > 3:
        result = ToolResult(error="max retries exceeded")
```

---

## checkpointing

for runs longer than a few minutes, save state after every step.

```python
def checkpoint(state: State, path: Path) -> None:
    path.write_text(json.dumps(asdict(state), default=str))

def load_checkpoint(path: Path) -> State | None:
    if not path.exists():
        return None
    return State(**json.loads(path.read_text()))
```

usage:
```python
checkpoint_path = Path(f".checkpoints/{run_id}.json")
state = load_checkpoint(checkpoint_path) or State(task=task)

for step in range(state.step, max_steps):
    ...
    state = state.update(step=step, ...)
    checkpoint(state, checkpoint_path)
```

if the run crashes at step 47, resume from step 46. no restarts.

---

## observability

log every step as a jsonl line. one object per step.

```python
def log_step(state: State, action: Action, result: ToolResult) -> None:
    entry = {
        "run_id": state.run_id,
        "step": state.step,
        "tool": action.tool,
        "params": action.params,
        "result": result.output or result.error,
        "latency_ms": result.latency_ms,
        "ts": datetime.utcnow().isoformat(),
    }
    with open(f"logs/{state.run_id}.jsonl", "a") as f:
        f.write(json.dumps(entry) + "\n")
```

minimum useful fields: run_id, step, tool, input, output/error, latency, ts.

this log is the ground truth for debugging. if something went wrong,
the log tells you exactly which step, which tool, what was passed, what came back.

---

## budget tracking

track token usage and wall time. fail before the provider cuts you off.

```python
@dataclass
class Budget:
    max_tokens: int = 100_000
    max_steps: int = 50
    max_seconds: int = 300
    tokens_used: int = 0
    started_at: float = field(default_factory=time.time)

def budget_exceeded(budget: Budget, tokens_this_step: int) -> bool:
    budget.tokens_used += tokens_this_step
    elapsed = time.time() - budget.started_at
    return (
        budget.tokens_used > budget.max_tokens
        or budget.step >= budget.max_steps
        or elapsed > budget.max_seconds
    )
```

---

## when to add complexity

start with the minimal loop. add components when you hit a real failure:

- run crashes and you lose progress → add checkpointing
- you cannot tell what went wrong → add observability
- agent spins on the same error → add retry limits
- run costs too much → add budget tracking
- tool calls fail in hard-to-diagnose ways → add validation layer

do not pre-emptively add all of this. build when needed.