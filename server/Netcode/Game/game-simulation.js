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
                    angle: (Math.random() * 2 - 1) * 45,
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
        var A, B;
        if (!(A = this.networkObjects[hit.A]) ||
            !(B = this.networkObjects[hit.B])) { return; }

        switch(hit.typeB) {
            case 'player':
                if (hit.typeA == 'laser') {
                    B.takeHit();
                    if (B.isDead) { this.room.gameOver(B.owner); }
                    this.destroy(A.id);
                    hit.data = {
                        health: B.health,
                    };
                }
                break;
            case 'asteroid':
                if (hit.typeA == 'laser') {
                    this.destroy(B.id);
                    if (hit.data.size == 'small') { break;}

                    let theta = 45 * Math.PI / 180;
                    let x = hit.data.x;
                    let y = hit.data.y;
                    let dx = hit.data.dx;
                    let dy = hit.data.dy;

                    var details = {
                        type: 'asteroid',
                        owner: this.room.masterClient,
                        data: {
                            x: x,
                            y: y,
                            size: 'small',
                        },
                    };
                    details.data.dx = dx * Math.cos(theta) - dy * Math.sin(theta);
                    details.data.dy = dx * Math.sin(theta) + dy * Math.cos(theta);
                    this.instantiate({}, details);

                    details.data.dx = dx * Math.cos(-theta) - dy * Math.sin(-theta);
                    details.data.dy = dx * Math.sin(-theta) + dy * Math.cos(-theta);
                    this.instantiate({}, details);

                    if (hit.data.size == 'large') {
                        details.data.dx = dx
                        details.data.dy = dy
                        this.instantiate({}, details);
                    }
                }
                break;
            default:
                console.log(hit);
                break;
        }
        server.io.to(this.room.id).emit('hit', hit);
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
