-- CREATE FUNCTION insert_user(first_name varchar(30), last_name varchar(30), user_name varchar(30), user_password varchar(30),
-- sex ENUM('Male', 'Female'), dob DATE) RETURNS bool DETERMINISTIC
 
SELECT insert_user("Eric2", "Schneider2", "CoolGuy2", "Pa$$Word2", "Male", DATE("1997-01-12"));
SELECT insert_user("Eric2", "Schneider2", "CoolGuy2", "Pa$$Word2", "Male", DATE("1997-01-12"));
SELECT insert_user("Eric2", "Schneider2", "CoolGuy", "Pa$$Word2", "Male", DATE("1997-01-12"));


SELECT * FROM USERS;

call get_surveys();
