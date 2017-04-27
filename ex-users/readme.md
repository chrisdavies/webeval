# Phoenix

To start your Phoenix app:

- Install dependencies with `mix deps.get`
- Build with `MIX_ENV=prod mix compile`
- Run `PORT=3000 MIX_ENV=prod mix phoenix.server`
- Verify it is working at: http://localhost:3000/api/users/

Bench locally:

  ab -c 100 -n 5000 http://127.0.0.1:3000/api/users/
