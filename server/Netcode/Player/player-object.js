var NetworkObject = require('../NetworkObject/network-object');
var config = require('../../config');

module.exports = class PlayerObject extends NetworkObject {
    update(serverFrame, command) {
        
        if (serverFrame > command.frame) {
            this.revertTo(command.frame);
            this.commands.insertCommand(command);
            this.simulateFrom(command.frame);
        }
        else {
            this.commands.addCommand(command);
            this.apply(command);
        }
    }

    revertTo(frame) {
        this.commands.revertTo(frame, (command) => {
            this.undo(command);
        });
    }

    simulateFrom(frame) {
        this.commands.simulateFrom(frame, command => {
            this.apply(command);
        });
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
