---
name: research-agent
description: Structured literature and topic survey for unfamiliar technical areas. Use when scoping a new subfield, preparing thesis background, or comparing approaches across multiple sources.
---

# research-agent

produce a theme-grouped, source-grounded survey for a technical question.

## inputs to establish

- research question
- depth (`surface overview`, `working knowledge`, or `deep understanding`)
- output format (`summary doc`, `structured notes`, `reading list`, or `draft section`)
- time/scope budget

## search strategy

if web search is available:
1. write 3-5 distinct search queries approaching the question from different angles rather than searching the question verbatim.
2. fetch the 2-3 most authoritative pages per query (official docs, survey papers, seminal papers, recent work within the last 2 years).
3. follow key authors, benchmarks, and systems referenced by those sources.

if no web search is available: work strictly from provided documents and state that limitation up front.

## extraction and synthesis

for each source, restate in your own words: main claim, methodology, quantitative findings, stated limitations, and contradictions with other sources.

synthesize by theme (never as a list of source-by-source summaries):
- answer the research question directly in the first paragraph
- note where sources agree and where they conflict
- identify open questions and contested claims
- recommend 2-3 sources for deeper reading with a concrete reason for each

## output structure

```markdown
# [topic] survey

## answer
[direct 2-3 sentence answer]

## background
[context needed to understand the field]

## key findings
[grouped by theme, not by source]

## open questions
[contested or unknown points]

## sources
[list with one-line description and URL/citation]

## recommended reading
[top 2-3 with reason for each]
```

## guardrails

- never copy-paste blocks from sources.
- never assert claims without a source.
- never present contested claims as settled.
