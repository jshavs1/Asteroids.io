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
        this.transform.setPosition(this.transform.position.x + dx,
                                this.transform.position.y + dy);
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
