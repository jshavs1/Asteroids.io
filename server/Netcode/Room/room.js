var uuid = require('uuid/v1');
var server = require('../../server');
var config = require('../../config');
const GameSimulation = require('../Game/game-simulation');

module.exports = class Room {
    constructor() {
        this.id = uuid();
        this.players = {};
        this.masterClient = "";
        this.simulation = new GameSimulation(this);
    }

    addPlayer(player) {
        if (this.isEmpty) {
            this.masterClient = player.id;
        }

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
        player.leave(this.id);

        if (this.masterClient == player.id) {
            if (!this.isEmpty) {
                this.masterClient = Object.values(this.players)[0];
            }
        }

        this.simulation.removeObjectsFromOwner(player.id);

        if (this.isEmpty) {
            this.simulation.stop();
            delete this.simulation;
        }

        console.log('Removing player '+player.id+' from room '+this.id);
    }

    synchronizedStart() {
        var startTime = Date.now();
        startTime += 3000;

        server.io.to(this.id).emit('start', {time: startTime, deltaTime: config.deltaTime});

        setTimeout(() => { this.simulation.start(); }, (startTime - Date.now()));
        console.log('Starting game in ' + (startTime - Date.now()));
    }

    get isFull() {
        return Object.keys(this.players).length == config.roomSize;
    }

    get isOpen() {
        return Object.keys(this.players).length < config.roomSize;
    }

    get isEmpty() {
        return Object.keys(this.players).length == 0;
    }

    instantiate(socket, details) {
        this.simulation.instantiate(socket, details);
    }

    update(command) {
        this.simulation.update(command);
    }

    hit(hit) {
        this.simulation.hit(hit);
    }

    destroy(id) {
        this.simulation.destroy(id);
    }

    gameOver(loser) {
        console.log("Game over");
        server.io.to(this.id).emit('gameOver', {loser: loser});
    }
}
