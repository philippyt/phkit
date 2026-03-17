# evals

how to write evals for agent workflows and prompts.

an eval is: a set of inputs, expected outputs, a scoring function,
and a script that runs your agent against all of them and reports a number.

---

## when to write an eval

write an eval when:
- you change a prompt and want to know if quality went up or down
- you change a tool and want to know if the agent uses it correctly
- you are iterating on a spec and want to measure the effect

you do not need an eval for every project. you need one when you are
iterating on something and "looks right" is not enough.

---

## structure

```
evals/
├── README.md               (this file)
├── <workflow-name>/
│   ├── cases.json          (input/expected output pairs)
│   ├── scorer.py           (scoring function)
│   └── run.py              (runs the agent on all cases, reports score)
```

---

## cases.json format

```json
[
  {
    "id": "case-001",
    "input": "what is the capital of france?",
    "expected": "paris",
    "tags": ["geography", "factual"]
  },
  {
    "id": "case-002",
    "input": "summarise this paper in one sentence: [abstract text]",
    "expected": "the paper proposes X and shows Y on Z benchmark",
    "tags": ["summarisation"]
  }
]
```

for open-ended outputs where exact match is wrong, expected can be
a rubric instead:

```json
{
  "id": "case-003",
  "input": "explain the bias-variance tradeoff",
  "expected": {
    "must_mention": ["bias", "variance", "tradeoff", "overfitting", "underfitting"],
    "must_not_mention": [],
    "max_sentences": 5
  },
  "tags": ["explanation"]
}
```

---

## scorer.py patterns

### exact match

```python
def score(output: str, expected: str) -> float:
    return 1.0 if output.strip().lower() == expected.strip().lower() else 0.0
```

### rubric match

```python
def score(output: str, expected: dict) -> float:
    text = output.lower()
    hits = sum(1 for term in expected["must_mention"] if term in text)
    misses = sum(1 for term in expected["must_not_mention"] if term in text)
    length_ok = len(output.split(". ")) <= expected.get("max_sentences", 999)
    total = len(expected["must_mention"])
    return (hits / total) * (0 if misses > 0 else 1) * (1 if length_ok else 0.5)
```

### llm-as-judge (for complex outputs)

```python
async def score(output: str, expected: str, criterion: str) -> float:
    prompt = f"""
    criterion: {criterion}
    expected: {expected}
    actual: {output}
    score from 0.0 to 1.0. respond with only the number.
    """
    response = await call_llm(prompt)
    return float(response.strip())
```

use llm-as-judge sparingly — it is slow and expensive. use it only
when the output is genuinely hard to score programmatically.

---

## run.py pattern

```python
import json
import asyncio
from pathlib import Path
from scorer import score

async def main():
    cases = json.loads(Path("cases.json").read_text())
    results = []

    for case in cases:
        output = await run_agent(case["input"])
        s = score(output, case["expected"])
        results.append({"id": case["id"], "score": s, "output": output})
        print(f"{case['id']}: {s:.2f}")

    avg = sum(r["score"] for r in results) / len(results)
    print(f"\naverage: {avg:.3f} ({len(results)} cases)")

    # save results for comparison
    Path("results.json").write_text(json.dumps(results, indent=2))

asyncio.run(main())
```

run this after every significant change to your prompt or tool.
compare the average score before and after. that is your signal.

---

## what makes a good eval set

- covers the cases you actually care about, not just easy ones
- includes edge cases that have caused failures before
- small enough to run in under 2 minutes (10-50 cases is fine to start)
- tagged so you can filter by category and see where failures cluster

start with 10 cases. add a new case every time you encounter a failure
in real usage. the eval set grows to reflect your real failure modes.

---

## storing results over time

append eval runs to `results_history.jsonl`:

```json
{"date": "2026-03-17", "score": 0.74, "n_cases": 12, "notes": "before tool refactor"}
{"date": "2026-03-18", "score": 0.81, "n_cases": 12, "notes": "after tool refactor"}
```

this gives you a trend line. if the score is going up, your changes
are working. if it drops, you introduced a regression.