# Go

## Setup

- Install Go
- Run `go get github.com/jackc/pgx github.com/valyala/fasthttp`
- Run `go build`
- Run `./go-users`
- Verify it is working at: http://localhost:3000/api/users/

Bench locally:

  ab -c 200 -n 5000 http://localhost:3000/api/users/

