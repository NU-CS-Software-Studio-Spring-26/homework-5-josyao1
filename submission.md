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
```
Where in this codebase is the todos index rendering each todo row currently implemented?
Cite exact files and line numbers. Do not propose changes.
```

**Files + line numbers returned:**

The behavior is implemented across three layers:

1. **`app/controllers/todos_controller.rb`, line 6** — `@todos = Todo.all` loads every todo and assigns it to the instance variable the view iterates over.

2. **`app/views/todos/index.html.erb`, lines 7–13** — A `<div id="todos">` wraps a loop (`@todos.each`) at line 8. Line 9 calls `render todo` for each record; Rails resolves this to the `_todo` partial by convention.

3. **`app/views/todos/_todo.html.erb`, lines 1–7** — The actual row markup. Each todo is wrapped in a `<div>` whose `id` is set by `dom_id todo` (line 1), then renders `todo.description` inside a `<strong>` label (line 4).

**Verified (real or hallucinated?):**
All three citations are real and verified against the actual files.

---

### Plan mode

**Prompt:**
```
I want to change how the todos index renders each todo row so that completed todos are visually
separated from incomplete ones. Propose a plan as a numbered list including files to edit, new
tests to add, and any migration. Do not write code.
```

**Plan returned:**

1. **Migration** — add a `completed` boolean to `todos` with `default: false, null: false`. Run `bin/rails db:migrate`.
2. **Model (`app/models/todo.rb`)** — add two scopes: `incomplete` and `completed`, each ordered by `created_at`.
3. **Controller (`app/controllers/todos_controller.rb`)** — in `#index`, replace `Todo.all` with two instance variables `@incomplete_todos` and `@completed_todos` using the new scopes. Also add `:completed` to `todo_params`.
4. **Index view (`app/views/todos/index.html.erb`)** — replace the single loop with two labeled sections, one for each instance variable.
5. **Todo partial (`app/views/todos/_todo.html.erb`)** — add a visual treatment (inline style or CSS class) for completed todos.
6. **Tests:**
   - `test/models/todo_test.rb` — test that each scope returns only the right records
   - `test/controllers/todos_controller_test.rb` — test that `GET /todos` assigns both collections correctly

**My edits to the plan:**

Removed the `:completed` addition to `todo_params` from step 3 — that's scope creep. The prompt is only about visual separation on the index; toggling completion state belongs in a separate feature with its own action.

---

### Agent mode

**Prompt:**
```
Implement only step 2 from the plan: add incomplete and completed scopes to app/models/todo.rb.
Do not touch any other files.
```

**Commit link:** [fa36c4d](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-josyao1/commit/fa36c4d69204d5d95f627f96353b3eac33116298)

---

### Bad → good prompt rewrite

**Bad:**
```
fix the bug in todos
```

**Good:**
```
Context:      The todos table has a due_date column (db/schema.rb line 18) but the form
              partial (app/views/todos/_form.html.erb) has no due_date field, and the
              controller (app/controllers/todos_controller.rb line 75) only permits
              :description in todo_params.

Task:         Add a due_date datetime field to the form and permit :due_date in
              todo_params so users can set a due date when creating or editing a todo.

Expected:     Submitting the new/edit form with a due date persists that value to the DB.

Actual:       due_date is always nil after create/update — there is no field in the form
              and the param is stripped by strong parameters even if sent manually.

Constraints:  Only touch app/views/todos/_form.html.erb and
              app/controllers/todos_controller.rb. No new gems.

Done when:    bin/rails test passes and creating a todo with a due date in the browser
              saves a non-nil due_date to the database.
```

---

## Part 4 — Turbo Streams

### Claude's answers to the discover questions

**Q1: What is a Turbo Stream and how does it differ from a normal HTML response?**

A Turbo Stream is a server response that surgically updates one or more pieces of the page without a full reload. Instead of returning a complete HTML document, it returns one or more `<turbo-stream>` custom elements that each target a DOM element by ID and declare what to do to it.

- **MIME type:** `text/vnd.turbo-stream.html` (vs `text/html` for a normal response)
- **Controller pattern:** wrap in `respond_to` with a `format.turbo_stream` branch alongside `format.html`
- **View convention:** `app/views/todos/action_name.turbo_stream.erb` — Rails picks it up automatically when the request Accept header includes the Turbo Stream MIME type

**Q2: The 7 Turbo Stream actions:**

| Action | One-line use case |
|---|---|
| `append` | Add a newly created todo to the bottom of the list |
| `prepend` | Insert a new notification at the top of an inbox |
| `replace` | Swap out an entire todo row (element + wrapper) after editing |
| `update` | Refresh just the inner content of a row without replacing the wrapper div |
| `remove` | Delete a todo row from the list after destroying it |
| `before` | Insert a flash message above a specific element |
| `after` | Insert a related item below its parent |

**Q3: Existing Turbo Stream responses in this project?**

None. No `.turbo_stream.erb` files exist and no `format.turbo_stream` calls appear anywhere in `app/`.

**Q4: Where would `format.turbo_stream` go for `toggle_priority`?**

In `TodosController#toggle_priority`, inside a `respond_to` block. The matching view would live at `app/views/todos/toggle_priority.turbo_stream.erb`.

---

### My explanation of Turbo Streams

A Turbo Stream lets a server send back a small HTML fragment that patches a small part of the page without replacing the whole thing. The browser will know its a stream because the 
response comes back witha special MIME type that TUrbo automatically adds to the accept header on the form submision. On the server side, there will be a `forma.turbo_stream` branch which contains elements actions or targets for the DOM to update. The result is the nice page update without a full reload and no need for custom Javascript.

### What I verified against the Turbo Streams handbook

**What Claude said:** There are 7 Turbo Stream actions: `append`, `prepend`, `replace`, `update`, `remove`, `before`, `after`.

**What the handbook says:** There are actually **8** actions — the handbook explicitly lists `append`, `prepend`, `replace`, `update`, `remove`, `before`, `after`, and **`refresh`**. I missed `refresh`, which triggers a full page refresh without a navigation event (useful for cache invalidation).

**What was confirmed correct:** The MIME type (`text/vnd.turbo-stream.html`), the `respond_to` / `format.turbo_stream` controller pattern, and the `.turbo_stream.erb` view filename convention all match the handbook exactly.

### PR

**PR URL:** (https://github.com/NU-CS-Software-Studio-Spring-26/nu-cs-software-studio-spring-26-homework-5-hw5/pull/3/changes#diff-1535754a1086c28a443b1a1dc736ff3a3c0230f1182c7e9e7713fda188f445e3)
