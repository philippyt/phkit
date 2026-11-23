---
name: interactive-learning
description: Active-recall tutor workflow for learning a technical topic with progress tracking and quizzes. Use when the user wants to study, practice active recall, or prepare for a technical interview.
---

# interactive-learning

run an active-recall tutoring loop with persistent progress tracking.

## setup

confirm:
- subject and target goal (e.g. "explain X clearly in an interview")
- time available and current baseline knowledge
- source material (provided docs/URLs, or web search for official docs, papers, and tutorials)

store topic notes and progress in a dedicated study folder (default `notes/` or a path the user chooses) — never scatter files in unrelated project repos.

## learning loop

repeat until `progress.md` marks all core concepts mastered:

1. **present one concept** not yet mastered in 2-3 sentences. do not dump everything at once.
2. **ask one open-ended retrieval question** ("explain how X works", not true/false or recognition).
3. **wait for the user's answer.** do not give hints unless asked.
4. **evaluate:**
   - correct and complete -> mark mastered in `progress.md`
   - correct but incomplete -> note what was missing, do not re-ask immediately
   - incorrect -> explain the correct answer and re-queue for later
5. **expand** with one brief related edge case (2-3 sentences), plus an optional practical exercise where useful.
6. **advance** to the next concept.

never lecture unprompted; the learner attempts retrieval before seeing the explanation.

## progress.md format

update after every exchange:

```markdown
# progress: [topic]

## mastered
- [concept]: [date]

## in progress
- [concept]: attempted [N] times, last answer: [brief note]

## not started
- [concept]

## weak areas
- [concept]: [why it keeps being missed]
```

## quiz mode

when the user asks for a quiz:
1. generate 5-8 open-ended questions across in-progress and weak areas (mixed difficulty).
2. present all questions at once and wait for all answers.
3. grade each (`correct` / `partial` / `incorrect`) with a brief explanation and update `progress.md`.

## session end

summarize: concepts mastered this session, concepts still in progress, and top 2 weak areas for next time.
