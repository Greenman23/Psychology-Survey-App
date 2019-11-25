drop database PROJECT;
CREATE DATABASE PROJECT;
USE PROJECT;

CREATE TABLE USERS( 
pk_user_id int NOT NULL AUTO_INCREMENT, 
first_name varchar(30) NOT NULL, 
last_name varchar(30) NOT NULL, 
email varchar(512),
phone varchar(15),
user_name varchar(30) NOT NULL UNIQUE,
user_password varchar(30) NOT NULL,
sex ENUM('Male', 'Female') NOT NULL,
age DATE NOT NULL,
is_smoker int, 
education Enum('Some High School', 'High School', 'Some College', 'Bachelors', 'Masters', 'PHD'),
address varchar(512),
PRIMARY KEY (pk_user_id)
);

CREATE TABLE USER_LOCATIONS(
id int NOT NULL AUTO_INCREMENT, 
country varchar (60),
state_province varchar (60),
city varchar (60),
date_ datetime,
userid int,
PRIMARY KEY(id),
FOREIGN KEY (userid) REFERENCES USERS(pk_user_id)
);

CREATE TABLE SURVEY_VERSIONS(
pk_survey_version_id int NOT NULL AUTO_INCREMENT,
survey_version_name varchar(60) UNIQUE,
description varchar(144),
creation_time DATETIME,
PRIMARY KEY(pk_survey_version_id)
);

CREATE TABLE QUESTION_VERSIONS(
pk_question_version_id int NOT NULL AUTO_INCREMENT, 
question_version_name varchar(144) UNIQUE,
creation_time DATETIME,
PRIMARY KEY(pk_question_version_id)
);

CREATE TABLE SURVEYS(
pk_survey_id int NOT NULL AUTO_INCREMENT, 
survey_name varchar(60)  NOT NULL,
description varchar(144) NOT NULL,
survey_creation_time DATETIME NOT NULL, 
survey_version int,
FOREIGN KEY(survey_version) REFERENCES SURVEY_VERSIONS(pk_survey_version_id),
PRIMARY KEY(pk_survey_id)
);

CREATE TABLE QUESTIONS(
pk_questions_id int NOT NULL AUTO_INCREMENT, 
question varchar(512) NOT NULL,
answers varchar(3000),
question_type ENUM('MultipleChoice', 'FillInTheBlank', 'MultipleChoiceRadio', 'Disabler'),
question_creation_time DATETIME NOT NULL,
question_version int,
health_data bool,
FOREIGN KEY(question_version) REFERENCES QUESTION_VERSIONS(pk_question_version_id),
PRIMARY KEY(pk_questions_id)
);

CREATE TABLE SURVEY_QUESTIONS(
id int NOT NULL AUTO_INCREMENT,
survey_id int NOT NULL, 
question_id int NOT NULL,
cat varchar(60) NOT NULL,
last_survey_question int,
chat_or_surv ENUM('C', 'S', 'B') DEFAULT 'B',
FOREIGN KEY(survey_id) REFERENCES SURVEYS(pk_survey_id) ON DELETE RESTRICT,
FOREIGN KEY(question_id) REFERENCES QUESTIONS(pk_questions_id) ON DELETE RESTRICT,
FOREIGN KEY(last_survey_question) REFERENCES SURVEY_QUESTIONS(id) ON DELETE RESTRICT,
PRIMARY KEY(id)
);

CREATE TABLE ANSWERS_TEXT(
id int NOT NULL AUTO_INCREMENT,
user_id int NOT NULL, 
survey_question int NOT NULL,
actual_answer varchar(512) NOT NULL,
chat_or_surv ENUM('C', 'S'),
date_ DATETIME,
FOREIGN KEY(user_id) REFERENCES USERS(pk_user_id) ON DELETE RESTRICT,
FOREIGN KEY (survey_question) REFERENCES SURVEY_QUESTIONS(id),
PRIMARY KEY(id)
);

CREATE TABLE FEEDBACK(
id int NOT NULL AUTO_INCREMENT, 
type_ ENUM('Phone', 'Website', 'ImageLink', 'VideoLink'),
link varchar(256),
severity_level integer DEFAULT -1
);