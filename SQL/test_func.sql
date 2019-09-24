-- CREATE FUNCTION insert_user(first_name varchar(30), last_name varchar(30), user_name varchar(30), user_password varchar(30),
-- sex ENUM('Male', 'Female'), dob DATE) RETURNS bool DETERMINISTIC
 
SELECT insert_user("Eric2", "Schneider2", "CoolGuy2", "Pa$$Word2", "Male", DATE("1997-01-12"));
SELECT insert_user("Eric2", "Schneider2", "CoolGuy2", "Pa$$Word2", "Male", DATE("1997-01-12"));
SELECT insert_user("Eric2", "Schneider2", "CoolGuy", "Pa$$Word2", "Male", DATE("1997-01-12"));


SELECT * FROM USERS;
SELECT  insert_survey_version("Yes", "Hi there");
SELECT  insert_survey_version("NO", "Hi there");

SELECT * FROM SURVEY_VERSIONS;
SELECT insert_survey("Survey", "HI THERE", 1);
SELECT insert_survey("Survey2", "HI THERE", 1);
SELECT insert_survey("Surve3", "HI THERE", 1);
SELECT insert_survey("Surve3ww", "HI THERE", 2);

SELECT * FROM SURVEYS;
CALL get_surveys;
