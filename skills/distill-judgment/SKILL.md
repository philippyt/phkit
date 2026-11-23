---
name: distill-judgment
description: Turn a user correction or recurring review finding into a reusable rule in AGENTS.md or a project rule file ("teach the next decision"). Use when the user corrects a decision pattern and wants future sessions to follow the same judgment.
---

# distill-judgment

convert a session correction into a durable, concise rule without bloating project instructions or recording conversation history.

## procedure

1. classify the correction:
   - **how-level** (one-off fix to a single step): fix the code only; do not add a rule.
   - **what-level** (choice for the current feature): update the relevant feature spec or code comment if non-obvious.
   - **why-level** (reusable judgment, constraint, or taste): candidate for `AGENTS.md` or `rules/`.
2. extract the underlying constraint and its *because* — state *why* the rule exists so downstream decisions generalize cleanly.
3. check existing `AGENTS.md` and rule files first:
   - refine or replace an existing line if one overlaps; do not append duplicates.
   - keep each rule to 1-2 factual sentences.
   - never record conversation history, incident stories, or task logs in `AGENTS.md`.
4. place the rule at the narrowest scope that fits:
   - repo-specific convention -> project `AGENTS.md`
   - language/domain rule -> `phkit/rules/<domain>.md`
   - universal rule across all repos -> global `AGENTS.md`
