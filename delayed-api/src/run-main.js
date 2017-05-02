// The main process runs this logic
const cluster = require('cluster');

const cpuCount = require('os').cpus().length;

// Create a worker for each CPU
for (var i = 0; i < cpuCount; i += 1) {
  cluster.fork();
}
