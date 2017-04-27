# .NET

## Setup

- Install .NET Core
- Run `dotnet restore` to get the dependencies
- Run `dotnet publish -c Release`
- Run `dotnet run ./bin/Release/netcoreapp1.1/web.dll`
- Verify it is working at: http://localhost:5000/api/users/

Bench locally:

  ab -c 100 -n 5000 http://localhost:5000/api/users/

Bench the micro ORM:

  ab -c 100 -n 5000 http://localhost:5000/api/usersdapp/
