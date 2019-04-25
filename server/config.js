// Server config
var port = (process.env.PORT || 8000);
var host = 'http://localhost';
if (process.env.NODE_ENV == 'production') {
    host = 'http://trufflepig.herokuapp.com';
}

//Simulation config
var deltaTime = Math.floor(1000 / 10);
var deltaTimeSeconds = deltaTime / 1000;
var serverFrameBuffer = 2;

module.exports = {
    port: port,
    host: host,
    deltaTime: deltaTime,
    deltaTimeSeconds: deltaTimeSeconds,
    serverFrameBuffer: serverFrameBuffer
};
