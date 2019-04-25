const Room = require('./room');

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
            room.removePlayer(player);
        }
        RoomManager.roomListUpdated();
    }
    static addPlayerToQueue(socket) {
        console.log('Adding player ' + socket.id + ' to queue');
        RoomManager.playerQueue.push(socket);
        RoomManager.flushPlayerQueue();
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
