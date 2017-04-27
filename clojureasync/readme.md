# Clojure

## Setup

- Install Java, Clojure, Lein
- Run `lein deps`
- Check that it works by running `lein ring server`
- Verify it is working at: http://localhost:3000/api/users/
- Production build `lein do clean, ring uberjar`
- Production run: `java -jar target/server.jar`

Bench locally:

Note: Be sure to run this several times before tallying the results, as you need to give the JVM some warmup time.

  ab -c 100 -n 5000 http://localhost:3000/api/users/
