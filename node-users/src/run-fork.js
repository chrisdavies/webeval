// Child processes run this logic
const express = require('express');
const app = express();
const pgp = require('pg-promise')();
const rp = require('request-promise');

pgp.pg.defaults.poolSize = 50;

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

app.get('/api/proxy', (req, res) =>
  rp('http://127.0.0.1:8081?ms=500')
    .then(body => res.end(body))
    .catch(err => res.status(500).json(err)));

app.listen(3000, () => console.log('http://localhost:3000'));
