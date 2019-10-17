import mysql.connector
from sql_connection import db

''' To do list:
get all the survey versions
add a survey version
get all the questions versions
add a question version
add a 

'''
# Procedures
def get_survey_versions():
    cursor = db.cursor()
    cursor.callproc("get_survey_versions")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results

def get_question_versions():
    cursor = db.cursor()
    cursor.callproc("get_question_versions()")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results

def get_questions():
    cursor = db.cursor()
    cursor.callproc("get_questions()")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results    

def get_surveys():
    cursor = db.cursor()
    cursor.callproc("get_surveys()")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results    

def get_questions_by_survey(name):
    cursor = db.cursor()
    cursor.callproc("get_questions_by_survey", [name])
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results    

#Functions

def insert_survey_version(name, description):
    cursor = db.cursor()
    cursor.execute(f"SELECT insert_survey_version({name}, {description})")
    res = cursor.fetchone()
    cursor.close()
    return res

def insert_survey(name, description, id):
    cursor = db.cursor()
    cursor.execute(f"SELECT insert_survey_version({name}, {description}, {id})")
    res = cursor.fetchone()
    cursor.close()
    return res   

def insert_question_version(name, description):
    cursor = db.cursor()
    cursor.execute(f"SELECT insert_question_version({name}, {description})")
    res = cursor.fetchone()
    cursor.close()
    return res

def insert_question(question, answer, question_type, question_version, health_data):
    cursor = db.cursor()
    cursor.execute(f"SELECT insert_question({question}, {answer}, {question_type}, {question_version}, {health_data})")
    res = cursor.fetchone()
    cursor.close()
    return res

def insert_survey_question(survey_id, question_id, last_question, category):
    cursor = db.cursor()
    cursor.execute(f"SELECT insert_survey_question({survey_id}, {question_id}, {last_question}, {category})")
    res = cursor.fetchone()
    cursor.close()
    return res