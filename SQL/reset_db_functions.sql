 USE PROJECT;
 DROP FUNCTION IF EXISTS insert_user;
 
 DELIMITER //
 CREATE FUNCTION insert_user(first_name_ varchar(30), last_name_ varchar(30), username_ varchar(30), user_password_ varchar(30),
 sex_ ENUM('Male', 'Female'), dob_ DATE) RETURNS bool DETERMINISTIC
 BEGIN
 DECLARE ret_val bool;
IF ((SELECT COUNT(`pk_user_id`) FROM USERS WHERE `user_name` = username_) > 0)
THEN
RETURN FALSE;
ELSE
INSERT INTO USERS (first_name, last_name, user_name, user_password, sex, age) VALUES(first_name_, last_name_, username_, user_password_, sex_,
dob_);
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
 CREATE FUNCTION insert_survey_version(survey_version_name_ varchar(60), description_ varchar(144)) RETURNS bool DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(survey_version_name) FROM SURVEY_VERSIONS WHERE SURVEY_VERSIONS.survey_version_name = survey_version_name_) > 0)
 THEN
 RETURN FALSE;
 ELSE
 INSERT INTO SURVEY_VERSIONS (survey_version_name, description, creation_time) VALUES (survey_version_name_, description_, NOW());
 RETURN TRUE;
 END IF;
 END
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_survey;
 DELIMITER //
 CREATE FUNCTION insert_survey(survey_name_ varchar(60), survey_description_ varchar(144), survey_version_ int) RETURNS bool DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`pk_survey_version_id`) FROM SURVEY_VERSIONS WHERE `pk_survey_version_id` = survey_version_) = 0)
 THEN
 RETURN FALSE;
 ELSE 
 INSERT INTO SURVEYS (survey_name, description, survey_creation_time, survey_version) VALUES(survey_name_, survey_description_, NOW(), survey_version_);
 RETURN TRUE;
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
 
DROP FUNCTION IF EXISTS insert_question_version;
 DELIMITER //
 CREATE FUNCTION insert_question_version(question_version_name_ varchar(60), question_ varchar(144)) RETURNS bool DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`question_version_name`) FROM QUESTION_VERSIONS WHERE question_version_name = question_version_name_) > 0)
 THEN
 RETURN FALSE;
 ELSE
 INSERT INTO QUESTION_VERSIONS (question_version_name, description, creation_time) VALUES (question_version_name_, question_, NOW());
 RETURN TRUE;
 END IF;
 END
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_question;
 DELIMITER //
 CREATE FUNCTION insert_question(question_ varchar(512), answer_ varchar(512), question_type_ ENUM('MultipleChoice', 'FillInTheBlank', 'TrueFalse', 'Picture', 'Voice'), question_version_ int)
 RETURNS bool
 BEGIN
 IF ((SELECT COUNT(`question_version_name`) FROM QUESTION_VERSIONS WHERE `pk_question_version_id` = question_version_) = 0)
 THEN
 RETURN FALSE;
 ELSE
 INSERT INTO QUESTIONS (question, answers, question_type, question_creation_time, question_version) VALUES (question_, answer_, question_type_, NOW(), question_version_);
 RETURN TRUE;
 END IF;
 END
 //
 DELIMITER ;

 DROP PROCEDURE IF EXISTS get_questions;
 DELIMITER //
 CREATE PROCEDURE get_questions() 
 BEGIN
SELECT question_version, question  FROM SURVEYS GROUP BY question_version ORDER BY question_creation_time;
 END
 //
 DELIMITER ;
 