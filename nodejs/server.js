'use strict';

const config = require('./config.json');
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

var img;

var app = http.createServer(function(request, response){ 
    if(request.method == 'POST') {
        console.log("Post Request Received from ip address=>" + request.connection.remoteAddress + " processing request.")
        var requestBody = '';
        request.on('data', function(data){
            if('image/jpeg' === request.headers['content-type']){
                var image_path = 'assets/images/profile_images/' + request.headers.username + '.jpg'

                img=fs.createWriteStream(image_path);
            
                img.write(data);
            }
            else {
                requestBody+= data;
            }
        })
        request.on('end', function(){
            try {
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
                    else {
                        var error_request = {
                            "Error" : "Bad Request",
                        }
                        sendJSON(request,response,error_request);
                    }
                    connection.end();
                }
                else if('image/jpeg' === request.headers['content-type']){
                    img.end();
                    var resp = "Ok"
                    sendJSON(request,response,resp)
                }
                else{
                    response.writeHead(200, {"Content-Type" : "application/json"})
                    console.log("Response sent to =>" + request.connection.remoteAddress + ".")
                    response.end("This server only recives json request.");
                }     
            }
            catch(err){
                console.log(err)
                response.end();
            }
        })
    }
    else {
        console.log("A non-POST request was recieved")
        response.statusCode = 501;
        response.setHeader('Content-Type', 'text/plain')
        response.end("Sorry this webserver only receives post request. The website will be developed later.");
    }
});
app.listen(80);
console.log("Http server is now running.")
