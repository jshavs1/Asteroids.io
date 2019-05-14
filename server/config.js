// Server config
var port = (process.env.PORT || 8000);
var host = 'http://localhost';
if (process.env.NODE_ENV == 'production') {
    host = 'http://trufflepig.herokuapp.com';
}

//Room config
roomSize = 2;

//Simulation config
var deltaTime = Math.floor(1000 / 10);
var deltaTimeSeconds = deltaTime / 1000;
var serverFrameBuffer = 2;

//Asteroid config
var minAsteroidInterval = 1 * 200;
var maxAsteroidInterval = 2 * 1000;

//Map config
var mapWidth = 1950;
var mapHeight = 900;

module.exports = {
    port: port,
    host: host,
    roomSize: roomSize,
    deltaTime: deltaTime,
    deltaTimeSeconds: deltaTimeSeconds,
    serverFrameBuffer: serverFrameBuffer,
    minAsteroidInterval: minAsteroidInterval,
    maxAsteroidInterval: maxAsteroidInterval,
    mapWidth: mapWidth,
    mapHeight: mapHeight
};
