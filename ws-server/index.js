"use strict";
const PORT = process.env.PORT || 8100;
const HOST = process.env.HOST || "127.0.0.1";
const HISTORY_LENGTH = 100;
const ActionType = Object.freeze({"history":1, "hello":2, "message":3, "channel":4 , "clients":5, "document":6 })
var webSocketServer = require('websocket').server;
var http = require('http');
var colors = [ 'red', 'green', 'blue', 'magenta', 'purple', 'plum', 'orange' ];
var history = [ ];
var lstConnections = [ ];                           //array of WS connection objects
var lstClients = [ ];                                //array of Clients information (ID)
var server = http.createServer();

server.listen({ host:HOST, port: PORT }, function() {
  console.log((new Date()) + ' Server is listening '+server.address().address + ' port:' + server.address().port);
});

var wsServer = new webSocketServer({
    httpServer: server,
    autoAcceptConnections: false
});

wsServer.on('request', function(request) {

    //console.log((new Date()) + ' Connection from origin ' + request.remoteAddress);

    var connection = request.accept(null, request.origin);
    var index = lstConnections.push(connection) - 1;
    var clientInfo = {
      userName : false,
      userColor : false,
      userId : false,
      channel : "0",
      presenter : false
    };

    connection.sendUTF(JSON.stringify( { type: ActionType.history, data: MessagesInChannel(clientInfo.channel)} ));
    connection.sendUTF(JSON.stringify( { type: ActionType.channel, data: channels()} ));


    lstClients.push(clientInfo);

    connection.on('message', function(message) {

        if (message.type !== 'utf8') return;
        var content = JSON.parse(message.utf8Data)
        var messageType = content.type;
        var messageData = content.data;

        //console.log((new Date()) + ' request of type :'+messageType+' with data :' + JSON.stringify(messageData));

        if (messageType == ActionType.hello)  //update clientinfo
        {
            clientInfo.userName = messageData.userName;
            clientInfo.userColor = colors.shift(); //fixme : handle case when no more color are available
            clientInfo.userId = messageData.userId;
            lstClients[index] = clientInfo;
            //send back clients list
            var selectedClients = clientsInChannel(clientInfo.channel);
            for (var i=0; i < lstConnections.length; i++)
            {
                var client = lstClients[i];
                if (client.channel === clientInfo.channel)
                  lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.clients, data: selectedClients} ));
            }
        }
        else if (messageType == ActionType.message){
            //console.log((new Date()) + ' message from ' + clientInfo.userId + ': ' + message.utf8Data);

            var obj = {
                time: (new Date()).toJSON(),
                text: messageData.message,
                userName: clientInfo.userName,
                userId: clientInfo.userId,
                userColor: clientInfo.userColor,
                channel: clientInfo.channel,
            };
            history.push(obj);
            history = history.slice(-HISTORY_LENGTH);

            for (var i=0; i < lstConnections.length; i++)
            {
                var client = lstClients[i];
                if (client.channel === obj.channel)
                  lstConnections[i].sendUTF(JSON.stringify({ type:ActionType.message, data: obj }));
            }
        }
        else if (messageType == ActionType.channel)
        {
            var oldChannel = clientInfo.channel;
            clientInfo.channel = messageData.channel;
            clientInfo.presenter = messageData.presenter;
            lstClients[index] = clientInfo;

            var oldChannelClients = clientsInChannel(oldChannel);
            var newChannelClients = clientsInChannel(clientInfo.channel);
            var lstChannels = channels();

            for (var i=0; i < lstConnections.length; i++)
            {
                var client = lstClients[i];
                if (client.channel === messageData.channel)
                  lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.clients, data: newChannelClients} ));
                else if (client.channel === oldChannel)
                  lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.clients, data: oldChannelClients} ));

                lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.channel, data: lstChannels} ));
            }

            connection.sendUTF(JSON.stringify( { type: ActionType.history, data: MessagesInChannel(clientInfo.channel)} ));



        }
        else if (messageType == ActionType.document)
        {
            var channel = lstClients[index].channel;
            for (var i=0; i < lstConnections.length; i++)
            {
                var client = lstClients[i];

                if ( (client.channel === channel) && (lstConnections[i] != connection))
                  lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.document, data: messageData } ));
            }
        }
    });

    connection.on('error', function(error){
        console.log('socket error : '+error);
    });

    // user disconnected
    connection.on('close', function(reasonCode, description) {
        //console.log((new Date()) + " onClose (" + reasonCode + ") "+description);
        if (clientInfo.userName !== false && clientInfo.userColor !== false) {
            //console.log((new Date()) + " Peer " + connection.remoteAddress + " disconnected.");
            // remove user from the list of connected lstConnections
            lstConnections.splice(index, 1);
            lstClients.splice(index, 1);
            var lstChannels = channels();
            var selectedClients = clientsInChannel(clientInfo.channel);
            for (var i=0; i < lstConnections.length; i++)
            {
                var client = lstClients[i];
                if (client.channel === clientInfo.channel)
                  lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.clients, data: selectedClients} ));

                lstConnections[i].sendUTF(JSON.stringify( { type: ActionType.channel, data: lstChannels} ));
            }
            colors.push(clientInfo.userColor);

            //no more clients => no longer needed to keep history
            if (lstClients.length == 0)
              history = [];
        }
    });

});

function MessagesInChannel(selectChannel)
{
  return history.filter(function(msg){
      return msg.channel === selectChannel
  });
}

function clientsInChannel(selectChannel)
{
  return lstClients.filter(function(client){
      return client.channel === selectChannel
  });
}

function channels()
{
  var lstChannels = [];
  for (var i=0; i < lstClients.length; i++)
  {
      var client = lstClients[i];
      if (client.presenter === true)
        lstChannels.push( { channel: client.channel, owner: client.userName } );
  }
  return lstChannels;
}
