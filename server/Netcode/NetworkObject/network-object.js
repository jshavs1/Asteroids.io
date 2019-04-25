var uuid = require('uuid/v1');
var CommandBuffer = require('../Command/command-buffer');
var NetworkTransform = require('./network-transform');

module.exports = class NetworkObject {
    constructor(owner) {
        this.owner = owner
        this.id = uuid();
        this.transform = new NetworkTransform();
    }

    update(command) {

    }

    getState() {
        return {
            owner: this.owner,
            id: this.id,
            transform: this.transform
        }
    }
}
