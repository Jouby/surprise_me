---
name: feedback_dart_format
description: Run dart format before every commit in this project
metadata:
  type: feedback
---

Always run `dart format .` (or the fvm equivalent) before creating a git commit.

**Why:** User explicitly requested this as part of the commit workflow.

**How to apply:** After all code changes and before `git commit`, run:
```
/Users/psykokwak/fvm/versions/3.35.7/bin/dart format .
```
Then stage any formatting changes before committing.
