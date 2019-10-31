const config = require('./config.json');
const express = require('express');
var fs=require('fs');
const mysql = require('mysql');
const query = require('./sql_queries');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name
}

var webApp = express();

webApp.use(express.json());

webApp.post('/', function(request,response){
    console.log(request.body)
});

webApp.listen(80)

