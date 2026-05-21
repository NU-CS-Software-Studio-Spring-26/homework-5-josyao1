# Security rules — always apply

- Never write, log, or echo secrets, API keys, or production credentials in any file or output
- No `eval` on user input under any circumstances
- No `html_safe` or `raw` on untrusted or user-supplied input
- Use parameterized queries (ActiveRecord finders) — never string-interpolate values into SQL
- Do not disable CSRF protection (`protect_from_forgery` must stay enabled)
- Do not disable mass assignment protection — always use strong parameters
- Do not disable or bypass Devise session checks if Devise is added in future
