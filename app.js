#!/usr/bin/node

var app = require('express').createServer();

app.get('/', function(req, res){

  
  //res.send('hello world');
});

app.get('/scan', function(req, res){
  
});


app.listen(80);
