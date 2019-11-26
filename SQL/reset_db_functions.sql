 USE PROJECT;
 DROP FUNCTION IF EXISTS insert_user;
DROP PROCEDURE IF EXISTS insert_answer;
 DROP FUNCTION IF EXISTS insert_survey_question;
 DROP FUNCTION IF EXISTS insert_locations;

 DELIMITER //
 CREATE FUNCTION insert_user(first_name_ varchar(30), 
last_name_ varchar(30), 
email_ varchar(512),
phone_ varchar(15),
user_name_ varchar(30),
user_password_ varchar(30),
sex_ ENUM('Male', 'Female'),
age_ DATE,
is_smoker_ int, 
education_ Enum('Some High School', 'High School', 'Some College', 'Associates', 'Bachelors', 'Masters', 'PHD'),
ethnicity_ Enum('White', 'Black', 'Hispanic', 'Asian', 'Native American', 'Pacific Islander', 'Other', 'Prefer not to say'),
address_ varchar(512)) RETURNS bool DETERMINISTIC,
income_ varchar(15)
 BEGIN
 DECLARE ret_val bool;
IF ((SELECT COUNT(`pk_user_id`) FROM USERS WHERE `user_name` = username_) > 0)
THEN
RETURN FALSE;
ELSE
INSERT INTO USERS (first_name, last_name, email, phone, user_name, user_password, sex, age, is_smoker, education, address, ethnicity, income) 
VALUES(first_name_, last_name_, email_, phone_, user_name_, user_password_, sex_, age_, is_smoker_, education_, address_, ethnicity_, income_);
RETURN TRUE;
END IF;
END
//
 DELIMITER ;
 
 
 DROP FUNCTION IF EXISTS verify_user;
 DELIMITER //
 CREATE FUNCTION verify_user(user_name_ varchar(30), user_password_ varchar(30)) RETURNS bool DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`pk_user_id`) FROM USERS WHERE `user_name` = user_name_ AND `user_password` = user_password_) = 1)
 THEN
 RETURN TRUE;
 ELSE
 RETURN FALSE;
 END IF;
 END;
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_survey_version;
 DELIMITER //
 CREATE FUNCTION insert_survey_version(survey_version_name_ varchar(60), description_ varchar(144)) RETURNS int DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(survey_version_name) FROM SURVEY_VERSIONS WHERE SURVEY_VERSIONS.survey_version_name = survey_version_name_) > 0)
 THEN
 RETURN -1;
 ELSE
 INSERT INTO SURVEY_VERSIONS (survey_version_name, description, creation_time) VALUES (survey_version_name_, description_, NOW());
 RETURN LAST_INSERT_ID();
 END IF;
 END
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_survey;
 DELIMITER //
 CREATE FUNCTION insert_survey(survey_name_ varchar(60), survey_description_ varchar(144), survey_version_ int) RETURNS int DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`pk_survey_version_id`) FROM SURVEY_VERSIONS WHERE `pk_survey_version_id` = survey_version_) = 0)
 THEN
 RETURN -1;
 ELSE 
 INSERT INTO SURVEYS (survey_name, description, survey_creation_time, survey_version) VALUES(survey_name_, survey_description_, NOW(), survey_version_);
 RETURN LAST_INSERT_ID();
 END IF;
 END
 //
 DELIMITER ;
 

 
DROP FUNCTION IF EXISTS insert_question_version;
 DELIMITER //
 CREATE FUNCTION insert_question_version(question_version_name_ varchar(144)) RETURNS int DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`question_version_name`) FROM QUESTION_VERSIONS WHERE question_version_name = question_version_name_) > 0)
 THEN
 RETURN -1;
 ELSE
 INSERT INTO QUESTION_VERSIONS (question_version_name, creation_time) VALUES (question_version_name_, NOW());
 RETURN LAST_INSERT_ID();
 END IF;
 END
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_question;
 DELIMITER //
 CREATE FUNCTION insert_question(question_ varchar(512), answer_ varchar(512), question_type_ ENUM('MultipleChoice', 'FillInTheBlank',  'MultipleChoiceRadio', 'Disabler'), question_version_ int,
  health_data_ bool)
 RETURNS int
 BEGIN
 IF ((SELECT COUNT(`question_version_name`) FROM QUESTION_VERSIONS WHERE `pk_question_version_id` = question_version_) = 0)
 THEN
 RETURN -1;
 ELSE
 INSERT INTO QUESTIONS (question, answers, question_type, question_creation_time, question_version, health_data) VALUES (question_, answer_, question_type_, NOW(), question_version_, health_data_);
 RETURN LAST_INSERT_ID();
 END IF;
 END
 //
 DELIMITER ;

 DROP PROCEDURE IF EXISTS get_surveys;
 DELIMITER //
 CREATE PROCEDURE get_surveys() 
 BEGIN
SELECT survey_version, survey_name  FROM SURVEYS GROUP BY survey_version ORDER BY survey_creation_time; END
 //
 DELIMITER ;

 DROP PROCEDURE IF EXISTS get_questions;
 DELIMITER //
 CREATE PROCEDURE get_questions() 
 BEGIN
 SELECT question_version, answers, question_type, health_data  FROM QUESTIONS GROUP BY question_version ORDER BY question_creation_time;
 END
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_survey_versions;
 DELIMITER //
 CREATE PROCEDURE get_survey_versions()
 BEGIN 
 SELECT pk_survey_version_id, survey_version_name, description FROM SURVEY_VERSIONS ORDER BY creation_time;
 END;
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_question_versions;
  DELIMITER //
 CREATE PROCEDURE get_question_versions()
 BEGIN 
 SELECT pk_question_version_id, question_version_name FROM QUESTION_VERSIONS ORDER BY creation_time;
 END;
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_user_id_answer;
 DELIMITER //
 CREATE PROCEDURE get_user_id_answer(user_name_ varchar(30), password_ varchar(30) )
 BEGIN 
 SELECT pk_user_id FROM USERS WHERE user_name = user_name_ and user_password = password_;
 END;
 //
 DELIMITER;
 
 
 DROP PROCEDURE IF EXISTS insert_answer;
DELIMITER //
CREATE PROCEDURE insert_answer(user_name_ varchar(30), password_ varchar(30), survey_id_ int, answer_ varchar(512), date__ DATETIME, chat_or_surv_ ENUM('C', 'S'))
BEGIN
INSERT INTO ANSWERS_TEXT (user_id, survey_question, actual_answer, date_, chat_or_surv) VALUES ((SELECT pk_user_id FROM USERS WHERE user_name =  user_name_ and user_password = password_), survey_id_, answer_, date__, chat_or_surv_);
SELECT user_id FROM ANSWERS_TEXT;
END;
 //
DELIMITER;
 
 DROP FUNCTION IF EXISTS insert_survey_question;
   DELIMITER //
CREATE FUNCTION insert_survey_question(survey_id_ int, question_id_ int, last_question_id int, category_ varchar(60), chat_or_surv_ ENUM('C', 'S', 'B')) RETURNS int DETERMINISTIC
BEGIN
if(last_question_id != -1)
THEN
INSERT INTO SURVEY_QUESTIONS(survey_id, question_id, last_survey_question, cat, chat_or_surv) VALUES(survey_id_, question_id_, last_question_id, category_, chat_or_surv_);
ELSE 
INSERT INTO SURVEY_QUESTIONS(survey_id, question_id, cat, chat_or_surv) VALUES(survey_id_, question_id_, category_, chat_or_surv_);
END IF;
RETURN last_insert_id();
END;
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_questions_by_survey;
 
    DELIMITER //
 CREATE PROCEDURE get_questions_by_survey(name_ varchar(60))
 BEGIN
 SELECT squestions.id, questions.question, questions.answers, questions.question_type, squestions.last_survey_question, questions.health_data, squestions.cat, squestions.chat_or_surv FROM SURVEY_QUESTIONS as squestions
 LEFT JOIN QUESTIONS AS questions
 ON
 squestions.question_id = questions.pk_questions_id
 INNER JOIN SURVEYS AS surveys
 ON 
 surveys.pk_survey_id = squestions.survey_id
 WHERE surveys.survey_name = name_;
 END
  //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_taken_survey_names;
 DELIMITER //
 CREATE PROCEDURE get_taken_survey_names(username_ varchar(60), password_ varchar(60))
 BEGIN
 SELECT surveys.survey_name FROM SURVEYS AS surveys
 INNER JOIN USERS AS users
 ON
 users.user_name = username_ AND users.user_password = password_
 INNER JOIN ANSWERS_TEXT AS answers
 ON users.pk_user_id = answers.user_id
 INNER JOIN SURVEY_QUESTIONS AS squestions
 ON 
 squestions.survey_id = answers.survey_question
 WHERE surveys.pk_survey_id = survey_id
 GROUP BY surveys.survey_name;
 END
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_answers_by_taken;
 DELIMITER //
 CREATE PROCEDURE get_answers_by_taken(username_ varchar(60), password_ varchar(60), survey_name_ varchar(120))
 BEGIN
 SELECT questions.question, answers.actual_answer, date_ AS "date" FROM ANSWERS_TEXT AS answers
 INNER JOIN USERS AS users
 ON 
 users.user_name = username_ AND users.user_password = password_ AND users.pk_user_id = answers.user_id
 INNER JOIN SURVEY_QUESTIONS AS squestions
 ON
 answers.survey_question = squestions.id
 INNER JOIN SURVEYS AS surveys
 ON 
 squestions.survey_id = surveys.pk_survey_id
 LEFT JOIN QUESTIONS AS questions
 ON 
 questions.pk_questions_id = squestions.question_id
 WHERE surveys.survey_name = survey_name_ AND answers.chat_or_surv != 'C';
 END
 //
 DELIMITER ;
 

 DROP PROCEDURE IF EXISTS get_location_answer_general;
 DELIMITER //
 CREATE PROCEDURE get_location_answer_general()
 BEGIN
 SELECT loc1.country, loc1.state_province, loc1.city, loc1.userid, questions.question, answers.actual_answer FROM USER_LOCATIONS AS loc1
 INNER JOIN (SELECT loc2.userid, MAX(loc2.date_) AS newest_date FROM USER_LOCATIONS AS loc2 GROUP BY loc2.userid) AS subquery
 ON
 loc1.userid = loc2.userid AND newest_date = loc1.date_
 LEFT JOIN ANSWERS_TEXT AS answers
 ON
 answers.user_id = loc1.userid
 INNER JOIN SURVEY_QUESTIONS AS squestions
 ON 
 answers.survey_question = squestions.id
 INNER JOIN QUESTIONS AS questions
 ON 
 sqeustions.question_id = questions.pk_questions_id
 ORDER BY answers.date_ DESC
 LIMIT 100;
 END
 //
 DELIMITER ;
 
 DELIMITER //
 CREATE FUNCTION insert_locations (username_ varchar(60), password_ varchar(60), country_ varchar(60), state_ varchar(60), city_ varchar(60), date__ DATETIME) RETURNS INTEGER DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`pk_user_id`) FROM USERS WHERE `user_name` = username_ AND `password`=password_) > 0)
 THEN
 INSERT INTO USER_LOCATIONS(country, state_province, city, date_, userid) VALUES(country_, state_, city_, date__, (SELECT `pk_user_id` FROM USERS WHERE `user_name` = username_ AND `password` = password_));
 RETURN 0;
 ELSE
 RETURN -1;
 END IF;
 END
 //
 DELIMITER ;
 
 
 