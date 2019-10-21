'use strict';


const config = require('./config.json');
const http = require('http');
const mysql = require('mysql');
const quary = require('./sql_queries');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name
}

function sendJSON(request,response, msg){
    var dictstring = JSON.stringify(msg);
    response.writeHead(200, {"Content-Type" : "application/json"})
    console.log("Response sent to =>" + request.connection.remoteAddress + "....")
    response.end(dictstring);
}

var app = http.createServer(function(request, response){ 

    var sql_response = "";

    if(request.method == 'POST') {
        console.log("Post Request Received from ip address=>" + request.connection.remoteAddress + " processing request....")
        var body = '';
        request.on('data', function(data){
            body+= data;
        })

        request.on('end', function(){
            try {
                if('application/json' === request.headers['content-type']){
                    var post = JSON.parse(body);
                }
                
                let connection = mysql.createConnection(conInfo);
                
                if(post.Type == 'signup'){

                    quary.signup(post.FirstName,post.LastName,post.Username,post.Password,post.Gender,post.BirthDate, connection, function(signup_resp){
                        sendJSON(request,response,signup_resp);
                    });
                }

                else if(post.Type == 'login'){
                  quary.login(post.Username, post.Password, connection, function(my_response){
                        sendJSON(request,response,my_response);
                  });
                }
                else if(post.Type == 'getSurveys'){
                  quary.get_all_surveys(connection, function(get_survey_response){
                        sendJSON(request,response, get_survey_response);
                  });
                }

                else if(post.Type == 'getQuestionsForSurvey'){
                    quary.get_survey_questions(post.SurveyName,connection, function(surveyQuestions){
                        sendJSON(request,response,surveyQuestions);
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
            catch(err){
                console.log(err)
                response.end();
            }
        })
    }

    else {
        console.log("A non-POST request was recieved")
        response.write("Sorry this webserver only receives post request. The website will be developed later.")
        response.end();
    }
});

app.listen(80);
console.log("Http server is now running....")
