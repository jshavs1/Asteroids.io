var server = require('../../server');
var config = require('../../config');
var PlayerObject = require('../Player/player-object');

class GameSimulation {
    constructor(roomId) {
        this.width = 4000;
        this.height = 4000;
        this.roomId = roomId;
        this.networkObjects = {};
        this.commandQueue = [];
        this.frame = 0;
    }

    start() {
        this.loop = setInterval(() => { this.gameLoop() }, config.deltaTime);
    }

    gameLoop() {
        var futureCommands = this.commandQueue.filter((command) => {
            return command.frame > this.frame;
        });
        var upcomingCommands = this.commandQueue.filter((command) => {
            return command.frame <= this.frame;
        });
        upcomingCommands.forEach((command) => {
            var object;
            if (object = this.networkObjects[command.id]) {
                object.update(this.frame, command);
            }
        });

        this.commandQueue = futureCommands;

        this.broadcastState();

        this.frame++;
    }

    end() {
        this.networkObjects = {}
        this.commandQueue = []
        this.frame = 0
        clearInterval(this.loop);
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
        server.io.to(this.roomId).emit('state', this.packageState());
    }

    instantiate(socket, details) {
        console.log('emitting instantiate to ' + this.roomId);
        switch(details.type) {
            case 'player':
                var player = new PlayerObject(socket.id);
                player.transform.setPosition(0, 0);
                this.networkObjects[player.id] = player;

                server.io.to(this.roomId).emit('instantiate',
                {
                    owner: details.owner,
                    type: details.type,
                    id: player.id,
                    transform: player.transform,
                });

                break;
            default:
                console.log(details);
        }
    }

    enqueueCommand(command) {
        this.commandQueue.push(command);
    }
}

module.exports = GameSimulation
