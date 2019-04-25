var NetworkObject = require('../NetworkObject/network-object');
var config = require('../../config');

module.exports = class PlayerObject extends NetworkObject {
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
}
