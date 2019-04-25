module.exports = class NetworkTransform {
    constructor() {
        this.position = {
            x: 0,
            y: 0,
        };
    }
    setPosition(x, y) {
        this.position.x = x;
        this.position.y = y;
    }
    copy() {
        var copy = new NetworkTransform();
        copy.position = {
            x: this.position.x,
            y: this.position.y
        };
        return copy;
    }
}
