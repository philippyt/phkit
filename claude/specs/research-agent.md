# spec: research-agent

## purpose

fast literature and topic survey for unfamiliar areas.
useful for: thesis background sections, understanding a new subfield,
preparing for a technical interview, scoping a new project.
copy this into `.claude/specs/research.md` and fill in the fields.

---

## research question

- question: [what do you need to understand?]
- depth: [surface overview / working knowledge / deep understanding]
- output format: [summary doc / structured notes / reading list / draft section]
- time budget: [how long should the agent spend on this?]

## search strategy

if exa or web search is available:

1. generate 3-5 search queries covering the question from different angles.
   write the queries before searching. do not just search the question verbatim.
2. for each query: retrieve top results, fetch full content of the 2-3 most
   relevant pages.
3. identify key papers, authors, and systems. search for those specifically.
4. look for: survey papers, authoritative tutorials, seminal papers,
   recent (last 2 years) work.

if no search is available: work from provided documents only.
state clearly that the research is limited to provided material.

## knowledge extraction

for each source:
- note the main claim or contribution in one sentence
- note the methodology in one sentence
- note the key result or finding with numbers where available
- note any limitations stated by the authors
- flag if the source contradicts another source

do not copy-paste from sources. extract and restate in your own words.

## synthesis

after collecting sources, write a synthesis that:
- answers the research question directly in the first paragraph
- groups related findings by theme, not by source
- notes where sources agree and where they disagree
- identifies open questions or contested claims
- recommends 2-3 sources for deeper reading

## output

write to `.claude/knowledge/<topic>-survey.md`:

```markdown
# [topic] survey

## answer

[direct 2-3 sentence answer to the research question]

## background

[context needed to understand the field]

## key findings

[grouped by theme, not by source]

## open questions

[what is contested or unknown]

## sources

[list with one-line description of each]

## recommended reading

[top 2-3 with reason for each]
```

## what not to do

do not produce a list of summaries of individual sources.
do not reproduce text from sources.
do not assert claims without a source.
do not present contested claims as settled.