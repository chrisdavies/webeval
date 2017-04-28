# Python

- Install python3, pip
- Run `pip install asyncpg`
- Run `pip install japronto`
- Run `python3 app.py`
- Visit http://127.0.0.1:8080/api/users to see if it's working

Bench with:

  ab -c 100 -n 5000 http://127.0.0.1:8080/api/users