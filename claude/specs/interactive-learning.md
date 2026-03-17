# spec: interactive-learning

## purpose

personal tutor workflow for learning a new topic through active recall.
inspired by the study method in github.com/sudo-goreng's interview prep.
copy this into `.claude/specs/interactive-learning.md` and fill in the fields.

---

## topic

- subject: [what you are learning]
- goal: [what you need to be able to do — e.g. "verbally explain X in an interview"]
- time available: [e.g. "this weekend", "2 hours per day for 3 days"]
- existing knowledge: [what you already know about this topic]

## reading material

[list source documents, urls, or paste content here]

if exa or web search is available, use it to find:
- official documentation
- academic papers if relevant
- practical tutorials

store summaries in `.claude/knowledge/<topic>.md`.

## learning loop

the agent runs this loop until progress.md shows mastery of all topics:

1. **present a concept** from the reading material not yet marked as mastered.
   explain it in 2-3 sentences. do not explain everything at once.

2. **ask a question** about that concept. the question should require the
   learner to retrieve from memory, not just recognise. use open-ended
   questions: "explain how X works" not "is X true or false?"

3. **wait for the learner's answer.** do not give hints unless explicitly asked.

4. **evaluate the answer:**
   - correct and complete → mark concept as mastered in progress.md
   - correct but incomplete → explain what was missing, do not re-ask
   - incorrect → explain the correct answer, re-queue the concept for later

5. **expand** with one related point or edge case the learner did not mention.
   keep this brief (2-3 sentences).

6. **move to the next concept.**

never lecture unprompted. the learner must attempt to answer before
receiving explanation.

## progress tracking

maintain `.claude/knowledge/progress.md`:

```markdown
# progress: [topic]

## mastered
- [concept name]: [date]

## in progress
- [concept name]: attempted [N] times, last answer: [brief note]

## not started
- [concept name]

## weak areas
- [concept name]: [why it keeps being missed]
```

update this file after every question-answer exchange.

## quiz mode

when the learner asks for a quiz:

1. generate 5-8 open-ended questions covering the in-progress and weak-areas
   concepts. mix difficulty.
2. present all questions at once.
3. wait for all answers before grading.
4. grade each answer: correct / partial / incorrect with brief explanation.
5. update progress.md based on results.
6. next quiz skips concepts marked mastered and adds more questions on
   weak areas.

## hands-on tasks

after a concept is explained and answered correctly, suggest one practical
task where relevant. examples:
- "set up X on a vm and verify it works"
- "implement Y from scratch without looking at the docs"
- "find a real example of Z in the codebase"

tasks are optional. the learner can skip them.

## session end

when the learner ends a session, summarise:
- concepts mastered this session
- concepts still in progress
- top 2 weak areas to focus on next session