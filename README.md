# Asteroids.io
Asteroids inspired multiplayer game utilizing Socket.IO

Clone the project and follow the steps below to setup
## Setting up the server
Make sure you have you [node](https://nodejs.org/en/download/) and [npm](https://www.npmjs.com/get-npm) installed on your machine.
1. Navigate to `Asteroids.io/server/` in the terminal
2. Run `npm install` to get dependencies
### Starting the server on localhost
- Run `npm start` to start the server
- Or run `nodemon server.js` if you want the server to automatically restart whenever changes are made to the server code

## Setting up the app
Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed on your machine
1. Navigate to `Asteroids.io/app/Asteroids.io/`
2. Run `carthage bootstrap` to install frameworks
### Running the app with localhost
Switch the target scheme in Xcode to **Asteroids.io-Dev** and run
### Running the app with live server
Switch the target scheme in Xcode to **Asteroids.io**
