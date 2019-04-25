var config = require('./config');
var express = require('express');
var server = express();
var http = require('http').Server(server);
var io = require('socket.io').listen(http);
const RoomManager = require('./Netcode/Room/room-manager');


// socket.io
io.on('connect', function (socket) {
    console.log('Opening new socket');
    RoomManager.addPlayerToQueue(socket);

    socket.on('disconnect', function() {
        console.log('Player '+socket.id+' has disconnected');
        RoomManager.leaveRoom(socket, socket.roomId);
    });
    socket.on('instantiate', function(details) {
        console.log('instantiate received from ' + details.owner);
        RoomManager.rooms[socket.roomId].instantiate(socket, details);
    });
    socket.on('command', function(command) {
        //console.log('Command ('+ command.frame + '): ' + command.id);
        RoomManager.rooms[socket.roomId].enqueueCommand(command);
    });
});



// main
http.listen(config.port, function () {
    console.log('Server listening.');
});
console.log('Running at '+config.host+':' + config.port);

exports.io = io;
