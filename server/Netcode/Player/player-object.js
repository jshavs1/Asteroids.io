var NetworkObject = require('../NetworkObject/network-object');
var config = require('../../config');

module.exports = class PlayerObject extends NetworkObject {
    constructor(owner) {
        super(owner);
        this.health = 10;
    }

    update(command) {
        this.apply(command)
    }

    apply(command) {
        var dx = command.actions.x;
        var dy = command.actions.y;

        var x = this.transform.position.x + dx;
        var y = this.transform.position.y + dy;

        if (x > config.mapWidth / 2) {
            x = -config.mapWidth / 2;
        }
        else if (x < -config.mapWidth / 2) {
            x = config.mapWidth / 2;
        }

        if (y > config.mapHeight / 2) {
            y = -config.mapHeight / 2;
        }
        else if (y < -config.mapHeight / 2) {
            y = config.mapHeight / 2;
        }

        this.transform.setPosition(x, y);
    }

    undo(command) {
        var dx = -command.actions.x;
        var dy = -command.actions.y;
        this.transform.setPosition(this.transform.position.x + dx,
                                this.transform.position.y + dy);
    }

    get isDead() {
        return this.health <= 0;
    }

    takeHit() {
        this.health -= 1;
    }
}
