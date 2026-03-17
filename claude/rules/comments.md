# rule: comments

append this block to any CLAUDE.md where comment discipline is needed.
(it is already included in all templates — only add explicitly if overriding)

---

## comments

this rule is absolute.

do not write comments that explain what the code does.
the code explains what the code does.

only write a comment when the WHY is non-obvious: a workaround for a
known bug, a constraint imposed by an external system, a non-obvious
algorithmic choice. if you cannot point to a reason that is not visible
from reading the code, do not write the comment.

examples of banned comments:
```python
# create a new list
items = []

# loop through the results
for result in results:

# return the value
return value
```

examples of acceptable comments:
```python
# offset by 1 because the upstream api uses 1-indexed pages
page = page_number + 1

# baum-welch diverges on very short sequences — minimum window of 10
if len(sequence) < 10:
    return None
```

no doc comments on private functions in any language.
public API: one-line summary maximum. no parameter lists, no examples,
no "returns:" sections unless the return value is genuinely non-obvious.

no module-level doc comments unless the module's purpose is not clear
from its name and contents.