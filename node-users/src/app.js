const cluster = require('cluster');

if (cluster.isMaster) {
  require('./run-main');
} else {
  require('./run-fork');
}