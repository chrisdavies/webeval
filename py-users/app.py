import asyncio
import asyncpg
import async_timeout
import aiohttp

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

async def apiProxy(request):
    async with aiohttp.ClientSession() as session:
        with async_timeout.timeout(10):
            async with session.get("http://127.0.0.1:8081/?ms=500") as response:
                body = await response.text()
                return request.Response(text=body)

def apiTest(request):
    return request.Response(text='Hello world!')

app = Application()

app.router.add_route('/api/users', apiUsers)
app.router.add_route('/api/proxy', apiProxy)
app.router.add_route('/api/test', apiTest)

app.run(debug=False)