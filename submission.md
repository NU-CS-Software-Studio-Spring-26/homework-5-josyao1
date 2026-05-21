# HW5 Submission

> Using Claude Code (claude-sonnet-4-6) instead of Cursor. I converted some of these parts of the assignment from a Cursor specific thing to a Claude specific thing

## Links

- **Repo / branch:** https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1.git
- **CLAUDE.md** (covers Part 1 off-limits + Part 2 stack brief): <!-- add link -->
- **.claude/rules/rails-conventions.md**: <!-- add link -->
- **.claude/rules/security.md**: <!-- add link -->

---

## Part 1 — Setup notes

- **Model:** claude-sonnet-4-6 (frontier model), used via Claude Code CLI
- **Indexing:** N/A — Claude Code reads files on demand, no separate index step
- **Tab completion:** N/A — Claude Code is terminal-based chat, no inline completion
- **Off-limits / secrets:** documented in `CLAUDE.md` under the Off-limits section (equivalent to `.cursorignore`)

---

## Part 3 — Mode prompting

### Ask mode

**Prompt:**

**Files + line numbers returned:**

**Verified (real or hallucinated?):**

---

### Plan mode

**Prompt:**

**Plan returned:**

**My edits to the plan:**

---

### Agent mode

**Prompt:**

**Commit link:**

---

### Bad → good prompt rewrite

**Bad:**
```
fix the bug in todos
```

**Good:**
```
Context:      ...
Task:         ...
Expected:     ...
Actual:       ...
Constraints:  ...
Done when:    ...
```

---

## Part 4 — Turbo Streams

### My explanation of Turbo Streams

<!-- write your own explanation here -->

### What I verified against the Turbo Streams handbook

<!-- paste what the AI said, then what the handbook confirmed -->

### PR

**PR URL:** <!-- add link -->
