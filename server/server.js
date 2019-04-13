var config = require('./config');
var express = require('express');
var server = express();
var http = require('http').Server(server);
var io = require('socket.io').listen(http);


// socket.io
io.on('connect', function (socket) {
    console.log('Opening new socket.');
    io.to(socket.id).emit('messege', {messege: 'Welcome!'});
});

// main
http.listen(config.port, function () {
    console.log('Server listening.');
});
console.log('Running at localhost:' + config.port);
