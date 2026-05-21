# CLAUDE.md — Project brief for Claude Code

@.claude/rules/rails-conventions.md
@.claude/rules/security.md

## Off-limits (do not read these files)

- .env
- .env.*
- config/master.key
- config/credentials/*.key
- tmp/
- log/
- storage/
- node_modules/
- .bundle/
- public/assets/

## Stack

- **Framework:** Rails 8.1.3
- **Database:** SQLite3 (development + test)
- **Asset pipeline:** Propshaft + importmap-rails
- **Frontend:** Hotwire (turbo-rails + stimulus-rails), no custom JS frameworks
- **Test framework:** Minitest (Rails default — no RSpec gem)
- **Background jobs:** SolidQueue
- **Cache / Cable:** SolidCache, SolidCable

## Commands

```
bin/setup          # install deps, create and migrate DB
bin/dev            # start dev server
bin/rails test     # run the full test suite
bundle exec rubocop  # lint
```

## Conventions

- Standard Rails scaffold naming: `TodosController`, `app/views/todos/`, `app/models/todo.rb`
- Strong parameters in every controller action that writes to the DB
- Controllers respond to HTML and JSON; Turbo Stream responses added per-action as needed
- Shared view partials live in `app/views/todos/` (e.g. `_todo.html.erb`, `_form.html.erb`)
- Migrations must be reversible (`change` method, or explicit `up`/`down`)
- Use `bin/rails generate` to scaffold boilerplate — do not hand-write it

## Don'ts

- No new gems without explicit approval
- No inline JavaScript in ERB templates
- No `skip_before_action :verify_authenticity_token`
- Do not seed real user data — use `db/seeds.rb` only
- Do not import models or migrations from other projects into this schema
