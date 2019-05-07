var server = require('../../server');
var config = require('../../config');
var PlayerObject = require('../Player/player-object');
var LaserObject = require('../Laser/laser-object');
var AsteroidObject = require('../Asteroid/asteroid-object');

class GameSimulation {
    constructor(room) {
        this.width = 4000;
        this.height = 4000;
        this.room = room;
        this.networkObjects = {};
    }

    start() {
        this.generateAsteroids();
    }

    stop() {
        clearTimeout(this.timer);
    }

    update(command) {
        var object;
        if (object = this.networkObjects[command.id]) {
            object.update(command);
            server.io.to(this.room.id).emit('update', object.getState());
        }
    }

    packageState() {
        var objectStates = [];
        for (var key in this.networkObjects) {
            objectStates.push(this.networkObjects[key].getState());
        }
        return {
            frame: this.frame,
            states: objectStates,
        };
    }

    broadcastState() {
        server.io.to(this.room.id).emit('state', this.packageState());
    }

    generateAsteroids() {
        let delay = Math.random() * (config.maxAsteroidInterval - config.minAsteroidInterval) + config.maxAsteroidInterval;
        this.timer = setTimeout(() => {
            let details = {
                owner: this.room.masterClient,
                type: 'asteroid',
                data: {
                    side: Math.floor(Math.random() * 4),
                    offset: (Math.random() * 2 - 1),
                    angle: (Math.random() * 2 - 1) * 30,
                    size: Math.random() < 0.5 ? 'medium' : 'large'
                }
            }
            this.instantiate({}, details);
            this.generateAsteroids();
        }, delay);
    }

    removeObjectsFromOwner(owner) {
        for (var key in this.networkObjects) {
            if (this.networkObjects[key].owner == owner) {
                this.destroy(key);
            }
        }
    }

    instantiate(socket, details) {
        console.log('emitting instantiate to ' + this.room.id);
        var object;
        var data;
            switch(details.type) {
            case 'player':
                object = new PlayerObject(socket.id);
                object.transform.setPosition(0, 0);
                break;
            case 'laser':
                object = new LaserObject(socket.id);
                object.transform.setPosition(details.data.x, details.data.y);
                data = {
                    dx: details.data.dx,
                    dy: details.data.dy
                }
                break;
            case 'asteroid':
                object = new AsteroidObject(this.room.masterClient);
                data = details.data;
                break;
            default:
                console.log(details);
        }

        if (typeof object !== 'undefined') {
            this.networkObjects[object.id] = object;
            server.io.to(this.room.id).emit('instantiate',
            {
                owner: details.owner,
                type: details.type,
                id: object.id,
                transform: object.transform,
                data: data
            });
        }
    }

    hit(hit) {
        console.log("Hit received");
        var A, B;
        if (!(A = this.networkObjects[hit.A]) ||
            !(B = this.networkObjects[hit.B])) { return; }

        switch(hit.typeB) {
            case 'player':
                if (hit.typeA == 'laser') {
                    B.takeHit();
                    if (B.isDead) { this.room.gameOver(B.owner); }
                    this.destroy(A.id);
                    server.io.to(B.id).emit('hit', hit);
                }
                break;
            default:
                console.log(hit);
                break;
        }
    }

    destroy(id) {
        var object;
        if (!(object = this.networkObjects[id])) { return; }

        delete this.networkObjects[id];
        server.io.to(this.room.id).emit('destroy', {id: id});
    }

    enqueueCommand(command) {
        this.commandQueue.push(command);
    }
}

module.exports = GameSimulation
