import asyncio
import asyncpg

from japronto import Application

async def apiUsers(request):
    conn = await asyncpg.connect(user='postgres',
                                 password='password',
                                 database='cgweb_dev',
                                 host='localhost')
    values = await conn.fetch('''SELECT id, email FROM users LIMIT 10''')
    await conn.close()
    users = [{'id': r['id'], 'email': r['email']} for r in values]
    return request.Response(json=users)

def apiTest(request):
    return request.Response(text='Hello world!')

app = Application()

app.router.add_route('/api/users', apiUsers)
app.router.add_route('/api/test', apiTest)

app.run(debug=False)