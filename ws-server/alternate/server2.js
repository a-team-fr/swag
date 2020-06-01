'use strict';

const express = require('express');
const WebSocket = require('ws');

const PORT = process.env.PORT || 8100;

var history = [ ];
var clients = [ ];


// Array with some colors
var colors = [ 'red', 'green', 'blue', 'magenta', 'purple', 'plum', 'orange' ];

const wss = new WebSocket.Server({ host:"fd00::3:329c", port: PORT });

wss.on('listening', function(){
  console.log( (new Date()) + ' Server is listening '+wss.address().address + ' port:' + wss.address().port);
});

wss.on('connection', (ws) => {
  console.log('Client connected');
  // we need to know client index to remove them on 'close' event
  var index = clients.push(ws) - 1;
  var userName = false;
  var userColor = false;


  //connection.sendUTF(JSON.stringify( { type: 'message', data: "welcome ! Please identify yourself"} ));

  // send back chat history
  if (history.length > 0) {
      ws.send(JSON.stringify( { type: 'history', data: history} ));
  }

  ws.on('close', () => console.log('Client disconnected'));

  ws.on('message', function (message) {
    console.log('received: %s', message);
    if (userName === false) { // first message sent by user is their name
        // remember user name
        userName = message;
        // get random color and send it back to the user
        userColor = colors.shift();
        ws.send(JSON.stringify({ type:'color', data: userColor }));
        console.log((new Date()) + ' User is known as: ' + userName
                    + ' with ' + userColor + ' color.');

    } else { // log and broadcast the message
        console.log((new Date()) + ' Received Message from '
                    + userName + ': ' + message);

        // we want to keep history of all sent messages
        var obj = {
            time: (new Date()).getTime(),
            text: message,
            author: userName,
            color: userColor
        };
        history.push(obj);
        history = history.slice(-100);

        var json = JSON.stringify({ type:'message', data: obj });
        for (var i=0; i < clients.length; i++) {
            clients[i].send(json);
        }
    }
  });
});

/*setInterval(() => {
  wss.clients.forEach((client) => {
    client.send(new Date().toTimeString());
  });
}, 1000);
*/
