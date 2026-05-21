# Rails 8 conventions for the sample todo app

- Prefer Turbo Streams over custom JavaScript for partial page updates
- Keep all migrations reversible — use `change`, or explicit `up`/`down` with matching `down`
- Always use strong parameters (`params.expect(...)`) — never assign directly from `params`
- Use `bin/rails generate` to create controllers, models, and migrations — do not hand-write boilerplate
- Keep the schema scoped to this todo app — do not import models or migrations from other projects
- Wrap multi-format responses in `respond_to` blocks; add `format.turbo_stream` only where the action needs it
- Place shared view partials in `app/views/todos/`; name them `_thing.html.erb`
