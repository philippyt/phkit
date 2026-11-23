## comments

comments explain constraints or non-obvious decisions, never what the code does. if the reason is visible from reading the code, omit the comment.

banned:
```python
# create a new list
items = []

# loop through results
for result in results:

# return the value
return value
```

acceptable:
```python
# upstream api uses 1-indexed pages
page = page_number + 1

# baum-welch diverges on very short sequences; minimum window is 10
if len(sequence) < 10:
    return None
```

- no doc comments on private functions in any language.
- public API: one-line summary maximum; omit parameter/return boilerplate unless non-obvious.
- no module-level doc comments unless the module's purpose is unclear from its name and contents.
- keep task history, issue chatter, and conversation references out of comments.
