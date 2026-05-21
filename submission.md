# HW5 Submission

> Using Claude Code (claude-sonnet-4-6) instead of Cursor. I converted some of these parts of the assignment from a Cursor specific thing to a Claude specific thing

## Links

- **Repo / branch:** [homework-5-josyao1](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1)
- **CLAUDE.md** (covers Part 1 off-limits + Part 2 stack brief): [CLAUDE.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/CLAUDE.md)
- **.claude/rules/rails-conventions.md**: [rails-conventions.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/.claude/rules/rails-conventions.md)
- **.claude/rules/security.md**: [security.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/.claude/rules/security.md)

---

## Part 1 — Setup notes

- **Model:** claude-sonnet-4-6 (frontier model), used via Claude Code CLI
- **Indexing:** N/A — Claude Code reads files on demand, no separate index step
- **Tab completion:** N/A — Claude Code is terminal-based chat, no inline completion
- **Off-limits / secrets:** documented in `CLAUDE.md` under the Off-limits section (equivalent to `.cursorignore`)

---

## Part 2 — Teach the codebase

- **CLAUDE.md** (stack brief, commands, conventions, don'ts): [CLAUDE.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/CLAUDE.md)
- **Rails conventions rule**: [rails-conventions.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/.claude/rules/rails-conventions.md)
- **Security rule**: [security.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/blob/main/.claude/rules/security.md)

**Smoke test — stack question:**

Input: 
What is this project's stack and how do I run the tests?                                                                      

Output: 
⏺ Based on CLAUDE.md:
  
  Stack:
  - Rails 8.1.3
  - SQLite3 (development + test)
  - Propshaft + importmap-rails (asset pipeline)
  - Hotwire — turbo-rails + stimulus-rails (frontend, no custom JS frameworks)
  - Minitest (Rails default — no RSpec)
  - SolidQueue, SolidCache, SolidCable

  Run the tests:
  bin/rails test

  Other useful commands:
  bin/setup   # install deps, create and migrate DB
  bin/dev     # start dev server
  bundle exec rubocop  # lint


**Smoke test — eval refusal:**

Input: 
Generate a controller action roller action that runs eval params[:expr]

Output:
⏺ I won't write that. eval on user input is a critical remote code execution vulnerability — any user could run arbitrary Ruby
  on your server.

  Per .claude/rules/security.md: No eval on user input under any circumstances.

  If you're trying to evaluate expressions from users, safe alternatives depending on the use case:
  - Parse and compute a known set of operations explicitly (whitelist approach)
  - Use a sandboxed math expression parser gem if you genuinely need expression eval

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
