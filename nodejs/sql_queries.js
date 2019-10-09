
function query(q, connection, callback){
    connection.query(q, function(error,results,[])
    {
        if(error) throw error;
        callback(null,results)
    });
}

module.exports  = {

    login: function(Username, Password, connection, callback){

        var verification = 'SELECT verify_user("' + Username + '","' + Password + '");';
        
        var resp_sql = "";

        var auth;

        auth = 0;

        query(verification, connection, function(error,res){
            if(error) throw error   
            console.log(res);
			for (let value of Object.values(res[0])) {
                auth = value;
                console.log(auth);
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
    },

    signup: function(FirstName, LastName, Username, Password, Gender, BirthDate, connection, callback){

        var new_user = 'SELECT insert_user("' + FirstName + '","' + LastName + '","' + Username + 
        '","' + Password + '","' + Gender + '", DATE("' + BirthDate + '"));';


        var sql_resp="No Response"

        var auth = 0;
        query(new_user, connection, function(error,res){
            if(error) throw error   

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
            console.log(sql_resp);
            callback(sql_resp);
            
        });
        
    },


    add_survey: function (SurveyName, SurveyDescription, SurveyVersion, connection){

        var new_survey = 'SELECT insert_survey("' + SurveyName + '","' + SurveyDescription + '","' + SurveyVersion + '");';

        connection.query(new_survey,function(error,results,feilds){
            console.log(results);
        });
    },

    new_survey_version: function (SurveyVersionName,SurveyDescription,connection){
        var survey_ver = 'SELECT insert_survey_version("' + SurveyVersionName + '","' + SurveyDescription + '");'

        connection.query(qeustion_ver,function(error,results,feilds){
            console.log(results);
        });
    },

    new_question_version: function(QuestionName, Question, connection){
        var qeustion_ver = 'SELECT insert_question_version("' + QuestionName + '","' + Question + '");'

        connection.query(qeustion_ver,function(error,results,feilds){
            console.log(results);
        });
    },

    new_question: function (Question, Answer, QuestionType, QuestionVersion, connection){
        var new_question = 'SELECT insert_question("' + Question + '","' + Answer + '","' + QuestionType + '","'  + QuestionVersion +'");';

        connection.query(new_question,function(error,results,feilds){
            console.log(results);
        });

    },


    get_all_surveys: function (connection){
        var all_surveys = 'SELECT get_surveys();'

        connection.query(new_question,function(error,results,feilds){
            console.log(results);
        });
    },

    get_all_questions: function(connection){
        var all_questions = 'SELECT get_questions();';

        connection.query(all_questions,function(error,results,feilds){
            console.log(results);
        });
    }
}