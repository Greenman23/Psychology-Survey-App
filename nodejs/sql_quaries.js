
function query(q, connection, callback){
    console.log(q)
    connection.query(q, function(error,results,[])
    {
        if(error) throw error;
        callback(null,results)
    });
}

module.exports  = {

    login: function(Username, Password, connection, callback){

        var verification = 'SELECT verify_user("' + Username + '","' + Password + '");';

        var qeury_response;
        
        var resp_sql = "";

        var auth;

        auth = 0;
       /* connection.query(verification, function(error, results, fields)
        {
            if(error) throw error;
            auth = results;
        });*/

        query(verification, connection, function(error,res){
            if(error) throw error   
            
			for (let value of Object.values(res[0])) {
			    auth = value;
            }
            
            if(auth == 1){
                resp_sql = {
                    "Authentication" : "Succeded"
                };
            }
    
            else {
                resp_sql = {
                    "Authentication" : "Failure"
                };
            }

            callback(resp_sql)
        });
    },

    signup: function(FirstName, LastName, Username, Password, Gender, BirthDate, connection){
        var new_user = 'SELECT insert_user("' + FirstName + '","' + LastName + '","' + Username + 
        '","' + Password + '","' + Gender + '", DATE("' + BirthDate + '"));';

        connection.query(new_user, function(error,results,feilds){
            console.log(results);   
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