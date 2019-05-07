var NetworkObject = require('../NetworkObject/network-object');
var config = require('../../config');

module.exports = class AsteroidObject extends NetworkObject {
    constructor(owner, size) {
        super(owner);
        this.size = size
    }
}
