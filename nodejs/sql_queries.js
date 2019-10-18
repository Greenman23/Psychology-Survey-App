
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
            console.log("Response: " + sql_resp);
            callback(sql_resp);
            
        });       
    },

     get_all_surveys: function(connection, callback){
        var all_surveys = 'CALL get_surveys();'
        var jsonresponse
        var get_survey_response = "No Response"
        var array = []
        query(all_surveys, connection, function(error, res){
            if (error) throw error;
            
            value = 0;
            
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

        var questions = 'CALL get_questions_by_survey("' + survey + '");';

        var suveyQuestions = []

        jsonResponse="";

        query(questions, connection, function(error,res){
            jsonResponse = ""
            if(error) throw error;

            for (let value of Object.values(res[0])) {
                let temp = {
                    'Question': value.question,
                    'Answers': value.answers, 
                    'QuestionType': value.question_type,
                    'LastSurveyQuestion': value.last_survey_question,
                    'HealthData': value.health_data, 
                }
                suveyQuestions.push(temp)
            }

            callback(suveyQuestions);  
        });       
    },

}
