const http = require("http");

http.createServer(function (request, response) {
   const delay = request.url.split('=')[1] || 250;
   setTimeout(() => {
    response.writeHead(200, {'Content-Type': 'application/json'});
    response.end('{"hello": "World!"}\n');
   }, delay);
}).listen(8081);

console.log('Server running at http://127.0.0.1:8081/');