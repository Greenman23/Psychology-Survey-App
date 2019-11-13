'use strict';

const config = require('./config.json');
const express = require('express');
const fs=require('fs');
const mysql = require('mysql');
const multiparty = require('multiparty');
const query = require('./sql_queries');
var FormData = require('form-data');
var request = require('request');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name,
    multipleStatements: true
}
var __profilePictureDirectory = 'assets/images/profile_images'
var __defaultImagesDirectory = 'assets/images/default_images'
var _botserverURL = 'http://localhost:8080'
var webApp = express()
webApp.use(express.json())

function sendJSON(request,response, msg){
    var dictstring = JSON.stringify(msg)
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.send(dictstring)
}
function sendJSON404(request,response, msg){
    var dictstring = JSON.stringify(msg)
    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
    response.status(404).send(dictstring)
}
webApp.post('/', function(request,response){
    sendJSON(request,response,'Please use an operation')
})
webApp.post('/signup', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: signup")
    let connection = mysql.createConnection(conInfo)
    query.signup(request.body.FirstName,request.body.LastName,request.body.Username,request.body.Password,request.body.Gender,
        request.body.BirthDate, connection, function(signup_resp){
        sendJSON(request,response,signup_resp)
    })
})

webApp.post('/login', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: login")
    let connection = mysql.createConnection(conInfo)
    query.login(request.body.Username, request.body.Password, connection, function(my_response){
        sendJSON(request,response,my_response)
    })
})

webApp.post('/allSurveys', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: allsurveys")
    let connection = mysql.createConnection(conInfo)
    query.get_all_surveys(connection, function(get_survey_response){
        sendJSON(request,response, get_survey_response)
    })
})
webApp.post('/surveyQuestions', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: getSurveyQuestions")
    let connection = mysql.createConnection(conInfo)
    query.get_survey_questions(request.body.SurveyName,connection, function(surveyQuestions){
        sendJSON(request,response,surveyQuestions)
    })
})
webApp.post('/uploadAnswers', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: uploadAnswers")
    let connection = mysql.createConnection(conInfo)
    query.send_answers(request.body.Username, request.body.Password, connection, request.body.Map, function(status){
        sendJSON(request,response,status)
    })
})
webApp.post('/uploadProfilePic', function(request,response){
    let connection = mysql.createConnection(conInfo)
    console.log("Incoming request from ip =>", request.headers.host, " Type: uploadProfilePic")
    var form = new multiparty.Form()
    if(!request.headers['content-type'].includes('multipart/form-data')){
        sendJSON(request,response,"This request does not contain an image")
    }
    else {
        query.login(request.headers.username, request.headers.password, connection, function(result){
            if(result.Authentication === true){
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
            else {
                sendJSON404(request,response, "Invalid user!")
            }
        })
    }
})
webApp.post('/ProfilePic', function(request,response){
    console.log("Incoming request from ip =>", request.headers.host, " Type: getProfilePic")
    let connection = mysql.createConnection(conInfo)
    var user = request.body.username
    var pass = request.body.password
    query.login(user,pass,connection,function(uploadResult){
        if(uploadResult.Authentication === true){
            var filePath = __profilePictureDirectory + '/' + user +'.jpg'
            fs.readFile(filePath, 'utf8',function(err, data){
                console.log("getting profile picture for ", filePath)
                if(err){
                    console.error(err)
                    filePath = __defaultImagesDirectory + '/default_profile.jpg'
                    response.sendFile(filePath, {root: __dirname})
                    console.log("No profile picture for this user! Default was sent")
                }
                else {
                    response.sendFile(filePath, {root: __dirname})
                    console.log("file has been sent.")
                }
            })
        }
        else {
            sendJSON404(request,response,"Invalid User!")
        }
    })
})
webApp.post('/profilePicAnalysis', function(req,response){
    console.log("Incoming request from ip =>", req.headers.host, " Type: imageReading")
    var user = req.body.username
    var pass = req.body.password
    let connection = mysql.createConnection(conInfo)
    query.login(user, pass, connection, function(authentication){
        if(authentication.Authentication === true){
            var filePath = __profilePictureDirectory + '/' + user + '.jpg'
            var reques = request.post(_botserverURL, function(error, server_response, response_body){
                if(error){
                    sendJSON404(req,response, "Error when connecting to image server")
                }
        
                else{
                    sendJSON404(req,response,response_body)
                }
            })
            var form = reques.form();
            form.append('image', fs.createReadStream(filePath))
        }
        else{
            sendJSON404(req,response,"Invalid User!")
        }
    })
})
webApp.post('/pictureAnalysis', function(req,response){
    let connection = mysql.createConnection(conInfo)
    console.log("Incoming request from ip =>", req.headers.host, " Type: pictureAnalysis")
    var form = new multiparty.Form()
    if(!req.headers['content-type'].includes('multipart/form-data')){
        sendJSON(req,response,"This request does not contain an image")
    }
    query.login(req.headers.username, req.headers.password, connection, function(auth){
        if(auth.Authentication===true){
            form.parse(req, function(err, fields, files) {
                if(err){
                    console.error(error)
                    sendJSON(req,response,"File not found in request")
                }
                var reques = request.post(_botserverURL, function(error, server_response, response_body){
                    if(error){
                        fs.unlink(files.image[0].path, function(error){
                            if(error){
                                console.error(error)
                            }
                        })
                        sendJSON404(req,response, "Error when connecting to image server")
                    }
            
                    else{
                        fs.unlink(files.image[0].path, function(error){
                            if(error){
                                console.error(error)
                            }
                        })
                        sendJSON404(req,response,response_body)
                    }
                })
                var form = reques.form();
                form.append('image', fs.createReadStream(files.image[0].path))
            })
        }
        else{
            sendJSON404(req,response,"Invalid user")
        }
    })
})
webApp.post('/userInformation', function(request,response){
    console.log("Incoming request from op =>", request.headers.host, " Type: reqeustUserInformation")
})
webApp.listen(80)
console.log("Express server is running now")


