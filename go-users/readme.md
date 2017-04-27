# Clojure

## Setup

- Install Go
- Run `go get github.com/lib/pq` to get the postgres driver
- Run `go build`
- Run `./go-users`
- Verify it is working at: http://localhost:3000/api/users/

Bench locally:

  ab -c 100 -n 5000 http://localhost:3000/api/users/
