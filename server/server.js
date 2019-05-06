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
    socket.on('myping', function() {
        io.to(socket.id).emit('mypong');
    });
    socket.on('instantiate', function(details) {
        console.log('instantiate received from ' + details.owner);
        RoomManager.rooms[socket.roomId].instantiate(socket, details);
    });
    socket.on('update', function(command) {
        RoomManager.rooms[socket.roomId].update(command);
    });
    socket.on('hit', function(hit) {
        RoomManager.rooms[socket.roomId].hit(hit);
    });
    socket.on('destroy', function(id) {
        RoomManager.rooms[socket.roomId].destroy(id);
    });
});



// main
http.listen(config.port, function () {
    console.log('Server listening.');
});
console.log('Running at '+config.host+':' + config.port);

exports.io = io;
