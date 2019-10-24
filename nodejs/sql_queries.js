
function query(q, connection, callback){
    connection.query(q, function(error,results,[])
    {
        if(error) throw console.error(error);
        callback(null,results)
    });
}
function insert_query(q, connection, callback){
    connection.query(q, function(error)
    {
        var insert_status = {
            'Process' : 'Sucessful',
        }
        if(error) throw console.error(error);
        callback(insert_status)
    });
}
function get_user_id(Username, Password, connection, callback){
    var get_user_id = 'CALL get_user_id_answer("' + Username + '","' + Password + '");';
    query(get_user_id, connection, function(error,res){
        var userid;
        if(error) throw error   
        for (let value of Object.values(res[0])) {
            userid = value.pk_user_id;
        }
        callback(userid);
    });
}
module.exports  = {
    login: function(Username, Password, connection, callback){
        if(Username != undefined && Password != undefined){
            var verification = 'SELECT verify_user("' + Username + '","' + Password + '");';
            var resp_sql = "";
            var auth;
            auth = 0;
            query(verification, connection, function(error,res){
                if(error) throw error   
                for (let value of Object.values(res[0])) {
                    auth = value;
                }
                if(auth == 1){
                    resp_sql = {
                        "Authentication" : true,
                        "Hash" : 12345
                    };
                }
                else {
                    resp_sql = {
                        "Authentication" : false,
                        "Hash" : 12345
                    };
                }
                callback(resp_sql)
            });
        }
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            callback(error_resp)
        }
    },
    signup: function(FirstName, LastName, Username, Password, Gender, BirthDate, connection, callback){
        if(FirstName != undefined && LastName != undefined && Username != undefined && Password != undefined && Gender != undefined &&
            BirthDate !=undefined ) {
            var new_user = 'SELECT insert_user("' + FirstName + '","' + LastName + '","' + Username + 
            '","' + Password + '","' + Gender + '", DATE("' + BirthDate + '"));';
            var sql_resp="No Response"
            var auth = 0;
            query(new_user, connection, function(error,res){
                if(error) throw console.error(error)   
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
                console.log("Response: " + sql_resp);
                callback(sql_resp);
            });
        }    
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            callback(error_resp)
        }
    },
     get_all_surveys: function(connection, callback){
        var all_surveys = 'CALL get_surveys();'
        var jsonresponse
        var array = []
        query(all_surveys, connection, function(error, res){
            if (error) throw console.error(error);
            for (let value of Object.values(res[0])) {
                array.push(value.survey_name)
            }
            jsonresponse = {
                "survey" : array
            }
            callback(jsonresponse)
        });

    },
    get_survey_questions: function(survey, connection, callback){
        if(survey != undefined){
            var questions = 'CALL get_questions_by_survey("' + survey + '");';
            var suveyQuestions = {"Questions": []}
            jsonResponse="";
            query(questions, connection, function(error,res){
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
                callback(suveyQuestions);  
            });
        }
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            callback(error_resp)
        }       
    },
    send_answers: function(user, pass, connection, answers, callback){
        if(user != undefined && pass != undefined && answers != undefined ){  
            for(i = 0; i < answers.Questions.length; i++){
                var answer = 'CALL insert_answer("' + user + '","' + pass + '",' +  answers.Questions[i].ID + ',"' + answers.Questions[i].UserAnswer + '");';
                insert_query(answer, connection, function(res){
                });
            }
            var done_rep = {
                "Process" : "Done",
            };
            callback(done_rep);
        }
        else {
            var error_resp = {
                "Invalid Response" : "Undefined Attributes"
            }
            callback(error_resp)
        }       
    },
}
