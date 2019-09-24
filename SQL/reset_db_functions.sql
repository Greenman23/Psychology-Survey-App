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
 CREATE FUNCTION insert_survey_version(survey_version_name_ varchar(60), description_ varchar(144)) RETURNS integer DETERMINISTIC
 BEGIN
 INSERT INTO SURVEY_VERSIONS (question_version_name, description, creation_time) VALUES (survey_version_name_, description_, NOW());
 RETURN 0;
 END
 //
 DELIMITER ;
 
 DROP FUNCTION IF EXISTS insert_survey;
 DELIMITER //
 CREATE FUNCTION insert_survey(survey_name_ varchar(60), survey_description_ varchar(144), survey_version_ int) RETURNS bool DETERMINISTIC
 BEGIN
 IF ((SELECT COUNT(`pk_survey_version_id`) FROM SURVEY_VERSIONS WHERE `pk_survey_version_id` = survey_version_) > 0)
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
 SELECT DISTINCT survey_version, survey_name, description FROM SURVEYS ORDER BY survey_creation_time;
 END
 //
 DELIMITER ;
 

 