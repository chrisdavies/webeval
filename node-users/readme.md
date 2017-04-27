# Node

## Setup

- Install Node
- Run `npm install` to get the deps
- Run `NODE_ENV=production node src/app.js`
- Verify it is working at: http://localhost:3000/api/users/

Bench locally:

  ab -c 100 -n 5000 http://localhost:3000/api/users/
