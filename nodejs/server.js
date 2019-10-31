'use strict';

/*const config = require('./config.json');
const http = require('http');
var fs=require('fs');
const mysql = require('mysql');
const query = require('./sql_queries');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name
}

function sendJSON(request,response, msg){
    var dictstring = JSON.stringify(msg);
    response.writeHead(200, {"Content-Type" : "application/json"})
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.end(dictstring);
}

function sendJSON404(request,response, msg){
    var dictstring = JSON.stringify(msg);
    response.writeHead(404, {"Content-Type" : "application/json"})
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.end(dictstring);
}

var img;
var app = http.createServer(function(request, response){ 
    if(request.method == 'POST') {
        console.log("Post Request Received from ip address=>" + request.connection.remoteAddress + " processing request.")
        var requestBody = '';
        request.on('data', function(data){

            requestBody+= data;
            //}
        })


        if('application/json' === request.headers['content-type']){
            var post = JSON.parse(requestBody);
            let connection = mysql.createConnection(conInfo);
            if(post.Type == 'signup'){
                query.signup(post.FirstName,post.LastName,post.Username,post.Password,post.Gender,post.BirthDate, connection, function(signup_resp){
                    sendJSON(request,response,signup_resp);
                });
            }
            else if(post.Type == 'login'){
                query.login(post.Username, post.Password, connection, function(my_response){
                    sendJSON(request,response,my_response);
                });
            }
            else if(post.Type == 'getSurveys'){
                query.get_all_surveys(connection, function(get_survey_response){
                    sendJSON(request,response, get_survey_response);
                });
            }
            else if(post.Type == 'getQuestionsForSurvey'){  
                query.get_survey_questions(post.SurveyName,connection, function(surveyQuestions){
                    sendJSON(request,response,surveyQuestions);
                });
            }
            else if(post.Type == 'answers'){  
                query.send_answers(post.Username, post.Password, connection, post.Map, function(status){
                    sendJSON(request,response,status);
                });
            }

            else if(request.headers['request-type'] == 'ProfileImageRequest'){    
                var fileDir = 'assets/images/profile_images/';
                var fileName = 'jack' + '.jpg';
                var filePath = fileDir + fileName;
            
                console.log('Request for file ' + filePath);
                    
                fs.readFile(filePath, 'utf8',function(error, content) {
                    if(error) {
                        response.writeHead(404, {'Content-Type' : 'application/json'})
                        console.log(error)
                        response.end("There is no profile picture for that user")
                    }
            
                    else{
                        response.writeHead(200, {
                            'Content-Type': 'image/jpg',
                            'File-Name' : fileName,
                        });
                        response.end(content)
                        console.log("Image has been sent")
                    }
                });
            }

            else {
                var error_request = {
                    "Error" : "Bad Request",
                }
                sendJSON404(request,response,error_request);
            }
            connection.end();
        }
        else if('ImageUpload' === request.headers['request-type']){
            var image_path = 'assets/images/profile_images/' + request.headers.username + '.jpg'
            var fileName = request.headers.username + 
            fs.writeFile(image_path, 'utf8',function(error) {
                if(error) {
                    response.writeHead(404, {'Content-Type' : 'application/json'})
                    console.log(error)
                    response.end("There was an error in uploading profile pic")
                }
        
                else{
                    response.writeHead(200, {
                        'Content-Type': 'application/json',
                        'File-Name' : fileName,
                    });
                    response.end("Image has been sent")
                }
            });
        }
        else{
            response.writeHead(200, {"Content-Type" : "application/json"})
            console.log("Response sent to =>" + request.connection.remoteAddress + ".")
            response.end("This server only recives json request.");
        }     
    }
    else {
        console.log("A non-POST request was recieved")
        response.statusCode = 501;
        response.setHeader('Content-Type', 'text/plain')
        response.end("Sorry this webserver only receives post request. The website will be developed later.");
    }
});
app.listen(80);
console.log("Http server is now running.")*/

const config = require('./config.json');
const express = require('express');
const fs=require('fs');
const mysql = require('mysql');
//const formidable = require('express-formidable')
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

var __profilePictureDirectory = 'assets/images/profile_images'

var webApp = express()

webApp.use(express.json())

//webApp.use(formidable())

webApp.post('/', function(request,response){
    response.send("Please enter an operation!")
});

webApp.post('/signup', function(request,response){
    let connection = mysql.createConnection(conInfo);
    query.signup(request.body.FirstName,request.body.LastName,request.body.Username,request.body.Password,request.body.Gender,
        request.body.BirthDate, connection, function(signup_resp){
        sendJSON(request,response,signup_resp);
    });
    connection.end();
});

webApp.post('/login', function(request,response){
    let connection = mysql.createConnection(conInfo);
    query.login(request.body.Username, request.body.Password, connection, function(my_response){
        sendJSON(request,response,my_response);
    });
    connection.end();
});

webApp.post('/allSurveys', function(request,response){
    let connection = mysql.createConnection(conInfo);
    query.get_all_surveys(connection, function(get_survey_response){
        sendJSON(request,response, get_survey_response);
    });
    connection.end();
});

webApp.post('/surveyQuestions', function(request,response){
    let connection = mysql.createConnection(conInfo);
    query.get_survey_questions(request.body.SurveyName,connection, function(surveyQuestions){
        sendJSON(request,response,surveyQuestions);
    });
    connection.end();
});

webApp.post('/uploadAnswers', function(request,response){
    let connection = mysql.createConnection(conInfo);
    query.send_answers(request.body.Username, request.body.Password, connection, request.body.Map, function(status){
        sendJSON(request,response,status);
    });
    connection.end();
});

webApp.post('/uploadProfilePic', function(request,response){
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
                                sendJSON(request,response,"File could not be uploaded")
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
    console.log(request.body)
    var user = request.body.username
    var filePath = __profilePictureDirectory + '/' + user +'.jpg'
    fs.readFile(filePath, 'utf8',function(err, data){
        console.log("writing to ", filePath)
        if(err){
            console.error(err)
            sendJSON(request,response,"File not found in request")
        }
        else {
            response.send(data)
            console.log("file has been sent.")
        }
    })
})


webApp.listen(80)
console.log("Express server is running now")


