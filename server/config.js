var port = (process.env.PORT || 8000);
var host = 'http://localhost:'+port;
if (process.env.NODE_ENV == 'production') {
    host = 'http://trufflepig.herokuapp.com';
}
module.exports = {
    port: port,
    host: host,
};
