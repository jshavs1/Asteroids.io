var uuid = require('uuid/v1');
var server = require('../../server');
var config = require('../../config');
const GameSimulation = require('../Game/game-simulation');

module.exports = class Room {
    constructor() {
        this.id = uuid();
        this.players = {};
        this.simulation = new GameSimulation(this.id);
    }

    addPlayer(player) {
        this.players[player.id] = player;
        player.roomId = this.id;

        player.join(this.id);

        console.log('Adding player '+player.id+' to room '+this.id);

        if (this.isFull) {
            this.synchronizedStart();
        }
    }

    removePlayer(player) {
        delete this.players[player.id];
        delete player.roomId;
        this.simulation.end()
        player.leave(this.id);

        console.log('Removing player '+player.id+' from room '+this.id);
    }

    synchronizedStart() {
        var startTime = Date.now();
        startTime += 3000;

        server.io.to(this.id).emit('start', {time: startTime, deltaTime: config.deltaTime});

        console.log('Starting game in ' + ((startTime - Date.now()) +
                config.serverFrameBuffer * config.deltaTime));

        setTimeout(() => { this.start() }, (startTime - Date.now()) +
                config.serverFrameBuffer * config.deltaTime);
    }

    start() {
        console.log('Game has started');
        this.simulation.start();
    }

    get isFull() {
        return Object.keys(this.players).length == 2;
    }

    get isOpen() {
        return Object.keys(this.players).length < 2;
    }

    get isEmpty() {
        return Object.keys(this.players).length == 0;
    }

    instantiate(socket, details) {
        this.simulation.instantiate(socket, details);
    }

    enqueueCommand(command) {
        this.simulation.enqueueCommand(command);
    }
}
