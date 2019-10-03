'use strict';


const config = require('./config.json');
const http = require('http');
const mysql = require('mysql');
const quary = require('./sql_quaries');
const conInfo = {
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.name
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
                    console.log(post)
                    if(post.FirstName != null){

                        console.log(post.FirstName,post.LastName,post.Username, post.Password, post.BirthDate,post.Gender)
                    }
                    else if(post.Username != null){
                        console.log(post.Username, post.Password);
                    }
                }
                
                let connection = mysql.createConnection(conInfo);
                
                if(post.FirstName != undefined){
                    var TestDate = "2001-09-11"
                    console.log(TestDate)
                    quary.signup(post.FirstName,post.LastName,post.Username,post.Password,post.Gender,TestDate, connection)
                }

                if(post.Username != undefined && post.Password != undefined){
                  sql_response =  quary.login(post.Username, post.Password, connection);
                }
                
                var dictstring = JSON.stringify(sql_response);
                response.writeHead(200, {"Content-Type" : "application/json"})
                response.end(dictstring);
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
console.log("Server is on")
