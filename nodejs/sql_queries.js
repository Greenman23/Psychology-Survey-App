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
    signup: function(FirstName, LastName, Email, PhoneNumber, Username, Password, Gender, BirthDate,
        Smoker, Education, Address, Race, income, connection, callback){
        if(FirstName != undefined && LastName != undefined && Email != undefined
            && PhoneNumber != undefined && Username != undefined && Password != undefined && Gender != undefined &&
            BirthDate !=undefined && Smoker != undefined && Education != undefined && Race != undefined && Address != undefined 
            && income != undefined) {
            var new_user = 'SELECT insert_user("' + FirstName + '","' + LastName + '","' + Email + '","' + PhoneNumber + 
            '","' + Username + '","' + Password + '","' + Gender + '", DATE("' + BirthDate + '"),"' + Smoker + 
            '","' + Education + '","' + Race + '","' + Address + '","' + income + '");'
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
                        'Category' : value.cat, 
                        'ChatorSurv' : value.chat_or_surv
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
            current_date = new Date()
            current_date = new Date(current_date.getTime() - current_date.getTimezoneOffset() * 60 * 1000).toISOString()
            for(i = 0; i < answers.Questions.length; i++){
                var answer = 'CALL insert_answer("' + user + '","' + pass + '",' +  answers.Questions[i].ID + ',"' + answers.Questions[i].UserAnswer + '","' + current_date
                + '","' + answers.Questions[i].Type + '");'
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
                        console.log("Done")
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
                    console.log('Still working')
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
    surveyHistory: function(user, pass, connection, callback){
        var survey_name_history = 'CALL get_taken_survey_names("' + user + '","' + pass + '");'
        var surveyhistory = {
            'SurveyHistory' : []
        }
        connection.query(survey_name_history, function(error,results){
            if(error){
                console.error(error)
            } 
            else {
                var taken = []
                for (let value of Object.values(results[0])) {
                    taken.push(value.survey_name)
                }
                connection.end()
                surveyhistory['SurveyHistory'].push(taken)
                callback(surveyhistory)
            }
        })
    },
    survey_question_history: function(user, pass, surveyname, connection, callback){
        answeredQuestions = 'CALL get_answers_by_taken("' + user + '","' + pass +  '","' + surveyname + '");'
        connection.query(answeredQuestions, function(error,results,feilds){
            surveys = {
                'surveys' : []
            }
            var tempDict = {}
            for (let value of Object.values(results[0])) {
                var date = value.date
                d2 = new Date(value.date).toLocaleString("en-US", {timeZone: "America/New_York"})
                console.log(d2)
                if(value.question!=undefined){
                    if(tempDict.hasOwnProperty(date)){
                        tempDict[date].push({'Question' : value.question, 'Answer' : value.actual_answer })
                    }
                    else{
                        tempDict[date] = [{'Question' : value.question, 'Answer' : value.actual_answer }] 
                    }       
                }
            }
            surveys['surveys'].push(tempDict)
            callback(surveys)
        })           
    },
    send_gps_location: function(user, pass, country, state, city, long, lat,connection, callback){
        if(user!=undefined, pass!=undefined, country!= undefined, state!=undefined, city!=undefined, long!=undefined, lat!=undefined){
            var sendGPS = 'SELECT insert_locations("' + user + '","' + pass +  '","' + country + '","' + state + 
            '","' + city + '","' + long + '","' + lat +  '");'
            // var sendGPS = 'SELECT insert_locations("' + user + '","' + pass +  '","' + country + '","' + state + 
            // '","' + city + '");'
            console.log(sendGPS)
            connection.query(sendGPS, function(error,results,feilds){
                if(error) console.error(error)
                else callback({'Process' : 'Compelete'})
            })
        }
        else {
            callback({'Error' : 'Invalid Augments'})
        }
    },
    get_all_gps_locations: function(connection, callback){
        var allGPS = 'SELECT longitude, latitude FROM USER_LOCATIONS'
        connection.query(allGPS, function(error, results, feilds){
            if(error) console.error(error)
            else {
                var array = []
                for(let i = 0; i < results.length; i++){
                    temp = {
                        'Longitude'  : results[i].longitude,
                        'Latitude' : results[i].latitude,
                    }
                    array.push(temp)
                }
                console.log(array)
                callback(array)
            }
        })
    }
}
