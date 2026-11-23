# evals

an eval is a set of test cases, a scoring function, and a runner that reports a score before and after a change.

write an eval when iterating on a prompt, tool, or skill where "looks right" is not enough.

## layout

```text
evals/
└── <workflow-name>/
    ├── cases.json
    ├── scorer.py
    ├── run.py
    └── results_history.jsonl
```

## cases.json

```json
[
  {
    "id": "case-001",
    "input": "explain the bias-variance tradeoff",
    "expected": {
      "must_mention": ["bias", "variance", "overfitting", "underfitting"],
      "must_not_mention": [],
      "max_sentences": 5
    },
    "tags": ["explanation"]
  }
]
```

## scoring patterns

prefer deterministic scorers (exact match, schema checks, rubric checks, unit tests) over LLM-as-judge. use LLM-as-judge only when programmatic scoring cannot capture the criterion.

```python
def score_rubric(output: str, expected: dict) -> float:
    text = output.lower()
    hits = sum(1 for term in expected["must_mention"] if term in text)
    misses = sum(1 for term in expected["must_not_mention"] if term in text)
    length_ok = len(output.split(". ")) <= expected.get("max_sentences", 999)
    total = max(len(expected["must_mention"]), 1)
    return (hits / total) * (0.0 if misses > 0 else 1.0) * (1.0 if length_ok else 0.5)
```

## diagnosing failures

when a case fails, tag which layer was missing so you fix the right thing:
- **why**: missing context, constraint, or acceptance criterion in the prompt/instructions
- **what**: agent chose the wrong approach given valid context
- **how**: agent chose the right approach but bungled execution or tool usage

## tracking over time

append one line per run to `results_history.jsonl`:

```json
{"date": "2026-11-23", "score": 0.84, "n_cases": 15, "notes": "after tightening tool schema"}
```

start with 10-20 real cases (under 2 minutes to run) and add a new case every time a real failure occurs.
