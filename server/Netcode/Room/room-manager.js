var Room = require('./room');

class RoomManager {
    static createRoom() {
        var room = new Room();
        RoomManager.rooms[room.id] = room;

        console.log('Creating new room ' + room.id);
        return room;
    }
    static findOpenRoom() {
        for (var key in RoomManager.rooms) {
            var room = RoomManager.rooms[key];
            if (room.isOpen) {
                return room;
            }
        }
    }
    static joinRoom(player, roomId) {
        var room = RoomManager.rooms[roomId];
        if (room) {
            room.addPlayer(player);
        }
    }
    static leaveRoom(player, roomId) {
        var room = RoomManager.rooms[roomId];
        if (room) {
            room.playerDisconnected(player);
        }
    }
    static addPlayerToQueue(socket) {
        console.log('Adding player ' + socket.id + ' to queue');
        RoomManager.playerQueue.push(socket);
        RoomManager.flushPlayerQueue();
    }
    static closeRoom(room) {
        for (var key in room.players) {
            delete room.players[key].roomId;
            room.players[key].leave(room.id);
        }
        delete RoomManager.rooms[room.id];
        console.log('Closing room '+room.id);
    }
    static roomListUpdated() {
        console.log('Room list updated');
        for (var key in RoomManager.rooms) {
            var room = RoomManager.rooms[key];
            if (room.isEmpty) {
                console.log('Deleting room '+room.id);
                delete RoomManager.rooms[key];
            }
        }
    }
    static flushPlayerQueue() {
        var room;
        while (RoomManager.playerQueue.length > 0) {
            if (!(room = RoomManager.findOpenRoom())) {
                room = RoomManager.createRoom();
            }
            var player = RoomManager.playerQueue.shift();
            room.addPlayer(player);
        }
    }
}
RoomManager.rooms = {};
RoomManager.playerQueue = [];

module.exports = RoomManager;
