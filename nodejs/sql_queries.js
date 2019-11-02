
/*function query(q, connection, callback){
    connection.query(q, function(error,results,[])
    {
        if(error) throw console.error(error);
        console.log(results)
        callback(null,results)
    });
}*/
module.exports  = {
    login: function(Username, Password, connection, callback){
        if(Username != undefined && Password != undefined){
            var verification = 'SELECT verify_user("' + Username + '","' + Password + '");'
            var auth = 0
            connection.query(verification, function(error,res){
                if(error) throw error   
                for (let value of Object.values(res[0])) {
                    auth = value;
                }
                if(auth == 1){
                    var get_user_information = 'SELECT first_name, last_name, sex, age FROM USERS WHERE user_name="' + Username + 
                    '" AND user_password="' + Password + '";'
                    connection.query(get_user_information, function(error,results)
                    {
                        if(error) throw console.error(error);
                        var user_info = {
                            'first_name' : results[0].first_name,
                            'last_name' : results[0].last_name,
                            'Gender' : results[0].sex,
                            'DOB' : results[0].age,
                            "Authentication" : true,
                        }
                        connection.end()
                        callback(user_info)
                    });
                }
                else {
                    var error_resp = {
                        "Authentication" : false,
                        "Hash" : 12345
                    };
                    connection.end()
                    callback(error_resp)
                }
            });
        }
        else {
            var error_resp = {
                "Authentication" : "False"
            }
            connection.end()
            callback(error_resp)
        }
    },
    signup: function(FirstName, LastName, Username, Password, Gender, BirthDate, connection, callback){
        if(FirstName != undefined && LastName != undefined && Username != undefined && Password != undefined && Gender != undefined &&
            BirthDate !=undefined ) {
            var new_user = 'SELECT insert_user("' + FirstName + '","' + LastName + '","' + Username + 
            '","' + Password + '","' + Gender + '", DATE("' + BirthDate + '"));'
            var auth = 0;
            connection.query(new_user, function(error,res){
                if(error) throw console.error(error) 
                var sql_resp;
                for (let value of Object.values(res[0])) {
                    auth = value;
                }
                if(auth == 1){
                    sql_resp = {
                        "Account_Creation" : true,
                    }
                }
                else {
                    sql_resp = {
                        "Account_Creation" : false,
                        "Reason" : "Username or Password already exist"
                    }
                }
                console.log("Response: " + sql_resp)
                connection.end()
                callback(sql_resp)
            });
        }    
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            connection.end()
            callback(error_resp)
        }
    },
     get_all_surveys: function(connection, callback){
        var all_surveys = 'CALL get_surveys();'
        var jsonresponse
        var array = []
       connection.query(all_surveys, function(error, res){
            if (error) throw console.error(error);
            for (let value of Object.values(res[0])) {
                array.push(value.survey_name)
            }
            jsonresponse = {
                "survey" : array
            }
            connection.end()
            callback(jsonresponse)
        });

    },
    get_survey_questions: function(survey, connection, callback){
        if(survey != undefined){
            var questions = 'CALL get_questions_by_survey("' + survey + '");'
            var suveyQuestions = {"Questions": []}
            jsonResponse="";
            connection.query(questions, function(error,res){
                jsonResponse = ""
                if(error) throw console.error(error);
                for (let value of Object.values(res[0])) {
                    value.answers = value.answers.split("'").join("\"")
                    value.answers = ('{"data" : ' + value.answers + '}')
                    value.answers = JSON.parse(value.answers)['data']
                    let temp = {
                        'ID' : value.id,
                        'Question': value.question,
                        'Answers': value.answers, 
                        'QuestionType': value.question_type,
                        'LastSurveyQuestion': value.last_survey_question,
                        'HealthData': value.health_data,
                        'Category' : value.cat 
                    }
                    suveyQuestions['Questions'].push(temp)
                }
                connection.end()
                callback(suveyQuestions)
            });
        }
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            connection.end()
            callback(error_resp)
        }       
    },
    send_answers: function(user, pass, connection, answers, callback){
        if(user != undefined && pass != undefined && answers != undefined ){  
            for(i = 0; i < answers.Questions.length; i++){
                var answer = 'CALL insert_answer("' + user + '","' + pass + '",' +  answers.Questions[i].ID + ',"' + answers.Questions[i].UserAnswer + '");'
                if(i == answers.Questions.length-1){
                    connection.query(answer, function(error)
                    {
                        if(error) {
                            console.error(error)
                        }
                        var insert_status = {
                            "Process" : "Done",
                        }
                        connection.end()
                        callback(insert_status)
                    })
                }
                else{
                    connection.query(answer, function(error)
                    {
                        if(error) {
                            console.error(error)
                        }
                    })
                }
            }
        }
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            connection.end()
            callback(error_resp)
        }       
    },
}
