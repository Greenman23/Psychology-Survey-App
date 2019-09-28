'use strict';

const http = require('http');
const fs = require('fs');

function login_verfication_request(Username, Password, connection){

    var verification = 'SELECT verify_user("' + Username + '","' + Password + '");'

    connection.query(verification, function(error,results,feilds){
        console.log(results)
    });
}

var app = http.createServer(function(request, response){ 

    if(request.method == 'POST') {
        console.log("I got the data!!!")
        var body = '';
        request.on('data', function(data){
            body+= data;
        })
        
        request.on('end', function(){
            try {
                var post = JSON.parse(body);
                console.log(post.Username, post.Password);


                //Beggining of DB Portion
                const config = require('./config.json')

                let mysql = require('mysql');
                
                let connection = mysql.createConnection({
                    host: config.host,
                    user: config.user,
                    password: config.password,
                    database: config.name
                });
                
                connection.connect(function (err) {
                    if (err) {
                        return console.error('error: ' + err.message);
                    }
                
                    console.log('Connection to the ' + config.name + ' has been made....');
                });
                
                if(post.Username != undefined && post.Password != undefined){
                    login_verfication_request(post.Username, post.Password, connection);
                }
                
                connection.end(function(err) {
                  if (err) {
                    return console.log('error:' + err.message);
                  }
                  console.log('Close the database connection.');
                });
                //End of DB Portion

                //deal_with_post_data(request,post)
                var dict= {
                    "Answer" : 1
                }
                console.log(dict);
                var dictstring = JSON.stringify(dict);
                response.writeHead(200, {"Content-Type" : "applocatiom/json"})
                response.end(dictstring);
            }
            catch(err){
                console.log(err)
                response.end();
            }
        })
    }

    else {
        console.log("Something is going wrong!")
    }
});


app.listen(8000);
console.log("Server is on")
