# harness patterns

reference patterns for custom agent execution loops. implement per project in whatever language fits; do not pre-emptively add components before hitting the failure they solve.

## core execution loop

```python
def run(task: str, tools: dict[str, Tool], max_steps: int = 50) -> str:
    state = State(task=task, step=0, history=[], context={})
    budget = Budget(max_steps=max_steps)

    for step in range(max_steps):
        action = agent.think(state)
        if action.type == "finish":
            return action.result

        result = execute(action, tools)
        state = state.update(step=step, action=action, result=result)

        if budget_exceeded(budget, step=step + 1, tokens_this_step=action.tokens_used):
            raise BudgetError(f"budget exceeded at step {step + 1}")

    raise MaxStepsError(f"did not finish within {max_steps} steps")
```

properties:
- the harness owns state; the agent receives a view of state and returns an action
- the harness validates and executes tools, then updates state
- hard caps on steps, tokens, and wall time

## state management

keep state explicit and serializable rather than letting raw chat history grow unboundedly.

```python
@dataclass
class StepRecord:
    step: int
    action: Action
    result: ToolResult
    ts: str

@dataclass
class State:
    run_id: str
    task: str
    step: int
    history: list[StepRecord]
    context: dict[str, Any]
```

compress completed phases into structured `context` once history exceeds your window:
```python
if len(state.history) > 20:
    state.context["phase_summary"] = summarise_history(state.history[:-5])
    state.history = state.history[-5:]
```

## tool execution and retries

intercept all tool calls for schema validation, logging, and structured error observations:

```python
def execute(action: Action, tools: dict[str, Tool]) -> ToolResult:
    tool = tools.get(action.tool)
    if tool is None:
        return ToolResult(error=f"unknown tool: {action.tool}")

    try:
        validated = tool.input_schema.model_validate(action.params)
    except ValidationError as err:
        return ToolResult(error=f"invalid params: {err}")

    try:
        output = tool.call(validated)
        return ToolResult(output=output)
    except ToolError as err:
        return ToolResult(error=str(err), retryable=err.retryable)
```

return errors as observations so the agent can recover, while the harness enforces retry limits per `(tool, params)` key.

## checkpointing

for runs lasting more than a few minutes, persist state after every step:

```python
def save_checkpoint(state: State, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(asdict(state), default=str), encoding="utf-8")

def load_checkpoint(path: Path) -> State | None:
    if not path.exists():
        return None
    return State(**json.loads(path.read_text(encoding="utf-8")))
```

## observability

append one JSONL record per step before processing the output:

```python
from datetime import datetime, timezone

def log_step(state: State, action: Action, result: ToolResult, log_dir: Path) -> None:
    log_dir.mkdir(parents=True, exist_ok=True)
    entry = {
        "run_id": state.run_id,
        "step": state.step,
        "tool": action.tool,
        "params": action.params,
        "result": result.output or result.error,
        "latency_ms": result.latency_ms,
        "ts": datetime.now(timezone.utc).isoformat(),
    }
    with (log_dir / f"{state.run_id}.jsonl").open("a", encoding="utf-8") as f:
        f.write(json.dumps(entry) + "\n")
```

## budget tracking

```python
@dataclass
class Budget:
    max_tokens: int = 100_000
    max_steps: int = 50
    max_seconds: int = 300
    tokens_used: int = 0
    started_at: float = field(default_factory=time.monotonic)

def budget_exceeded(budget: Budget, step: int, tokens_this_step: int) -> bool:
    budget.tokens_used += tokens_this_step
    elapsed = time.monotonic() - budget.started_at
    return (
        budget.tokens_used > budget.max_tokens
        or step >= budget.max_steps
        or elapsed > budget.max_seconds
    )
```

## when to add components

- run crashes and loses progress -> checkpointing
- failures are opaque -> JSONL step logging
- agent loops on the same error -> retry limits
- runs overrun cost or time -> budget tracking
- bad tool arguments cause crashes -> input validation layer
- high-autonomy runs drift from intent -> independent verification pass against acceptance criteria
