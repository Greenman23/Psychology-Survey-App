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
 
 DROP FUNCTION IF EXISTS insert_survey_question;
   DELIMITER //
CREATE FUNCTION insert_survey_question(survey_id_ int, question_id_ int, last_question_id int, category_ varchar(60)) RETURNS int DETERMINISTIC
BEGIN
if(last_question_id != -1)
THEN
INSERT INTO SURVEY_QUESTIONS(survey_id, question_id, last_survey_question, cat) VALUES(survey_id_, question_id_, last_question_id, category_);
ELSE 
INSERT INTO SURVEY_QUESTIONS(survey_id, question_id, cat) VALUES(survey_id_, question_id_, category_);
END IF;
RETURN last_insert_id();
END;
 //
 DELIMITER ;
 
 DROP PROCEDURE IF EXISTS get_questions_by_survey;
 
    DELIMITER //
 CREATE PROCEDURE get_questions_by_survey(name_ varchar(60))
 BEGIN
 SELECT questions.question, questions.answers, questions.question_type, squestions.last_survey_question, questions.health_data FROM SURVEY_QUESTIONS as squestions
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
 
 