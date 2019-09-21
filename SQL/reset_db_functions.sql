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
 