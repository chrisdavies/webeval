// Child processes run this logic
const express = require('express');
const app = express();
const pgp = require('pg-promise')();
const db = pgp({
  driver: 'pg',
  user: 'postgres',
  password: 'password',
  host: 'localhost',
  database: 'cgweb_dev'
});

app.get('/api/users', (req, res) =>
  db.any('select id, email from users limit 10')
    .then(o => res.json(o))
    .catch(err => res.status(500).json(err)));

app.listen(3000, () => console.log('http://localhost:3000'));
