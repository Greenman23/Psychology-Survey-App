'use strict';

const config = require('./config.json');
const express = require('express');
const fs=require('fs');
const mysql = require('mysql');
const multiparty = require('multiparty');
const query = require('./sql_queries');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name
}

function sendJSON(request,response, msg){
    var dictstring = JSON.stringify(msg);
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.send(dictstring);
}

function sendJSON404(request,response, msg){
    var dictstring = JSON.stringify(msg);
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.status(404).send(dictstring);
}

var __profilePictureDirectory = 'assets/images/profile_images'

var webApp = express()

webApp.use(express.json())

webApp.post('/', function(request,response){
    sendJSON('Please use an operation')
});

webApp.post('/signup', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: signup")
    let connection = mysql.createConnection(conInfo);
    query.signup(request.body.FirstName,request.body.LastName,request.body.Username,request.body.Password,request.body.Gender,
        request.body.BirthDate, connection, function(signup_resp){
        sendJSON(request,response,signup_resp);
    });
    connection.end();
});

webApp.post('/login', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: login")
    let connection = mysql.createConnection(conInfo);
    query.login(request.body.Username, request.body.Password, connection, function(my_response){
        sendJSON(request,response,my_response);
    });
    connection.end();
});

webApp.post('/allSurveys', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: allsurveys")
    let connection = mysql.createConnection(conInfo);
    query.get_all_surveys(connection, function(get_survey_response){
        sendJSON(request,response, get_survey_response);
    });
    connection.end();
});

webApp.post('/surveyQuestions', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: getSurveyQuestions")
    let connection = mysql.createConnection(conInfo);
    query.get_survey_questions(request.body.SurveyName,connection, function(surveyQuestions){
        sendJSON(request,response,surveyQuestions);
    });
    connection.end();
});

webApp.post('/uploadAnswers', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: uploadAnswers")
    let connection = mysql.createConnection(conInfo);
    query.send_answers(request.body.Username, request.body.Password, connection, request.body.Map, function(status){
        sendJSON(request,response,status);
    });
    connection.end();
});

webApp.post('/uploadProfilePic', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: uploadProfilePic")
    var form = new multiparty.Form();
    if(!request.headers['content-type'].includes('multipart/form-data')){
        sendJSON(request,response,"This request does not contain an image")
    }
    else {
        form.parse(request, function(err, fields, files) {
            var user = request.headers.username
            if(files != undefined && user!= undefined && user!=""){
                var filePath = __profilePictureDirectory + '/' + user + '.jpg';
                fs.readFile(files.image[0].path,  function(err, data){
                    console.log("writing to ", filePath)
                    if(err){
                        console.error(error)
                        sendJSON(request,response,"File not found in request")
                    }
                    else {
                        fs.writeFile(filePath,data,function(error) {
                            if(error) {
                                console.error(error)
                                sendJSON404(request,response,"File could not be uploaded")
                            }
                    
                            else{
                                sendJSON(request,response,"profile picture has been uploaded")
                            }
                        }); 
                        fs.unlink(files.image[0].path, function(error){
                            if(error){
                                console.error(error)
                            }
                        })
                    }
                })
            }
            else {
                sendJSON(request,response,"Could not find picture in request")
            }
        });
    }
})

webApp.post('/ProfilePic', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: getProfilePic")
    var user = request.body.username
    var filePath = __profilePictureDirectory + '/' + user +'.jpg'
    fs.readFile(filePath, 'utf8',function(err, data){
        console.log("writing to ", filePath)
        if(err){
            console.error(err)
            sendJSON404(request,response,"File not found in request")
        }
        else {
            response.sendFile(filePath, {root: __dirname})
            console.log("file has been sent.")
        }
    })
})

webApp.listen(80)
console.log("Express server is running now")


