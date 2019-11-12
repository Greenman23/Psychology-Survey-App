import mysql.connector
from sql_connection import db
import time
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
    return results[0]

def get_question_versions():
    cursor = db.cursor()
    cursor.callproc("get_question_versions")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return results[0]

def get_questions():
    cursor = db.cursor()
    cursor.callproc("get_questions")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return  results[0]    

def get_surveys():
    cursor = db.cursor()
    cursor.callproc("get_surveys")
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return  results[0]    

def get_questions_by_survey(name):
    cursor = db.cursor()
    cursor.callproc("get_questions_by_survey", [name])
    results = []
    for result in cursor.stored_results():
        results.append(result.fetchall())
    cursor.close()
    return  results[0]    

#Functions

def insert_survey_version(name, description):
    cursor = db.cursor()
    cursor.execute(f'SELECT insert_survey_version("{name}", "{description}");')
    res = cursor.fetchone()
    time.sleep(1)
    cursor.close()
    return res[0]

def insert_survey(name, description, id):
    cursor = db.cursor()
    cursor.execute(f'SELECT insert_survey("{name}", "{description}", {int(id)})')
    res = cursor.fetchone()
    cursor.close()
    return res[0] 

def insert_question_version(name):
    cursor = db.cursor()
    cursor.execute(f'SELECT insert_question_version("{name}")')
    res = cursor.fetchone()
    cursor.close()
    return res[0]

def insert_question(question, answer, question_type, question_version, health_data):
    cursor = db.cursor()
    cursor.execute(f'SELECT insert_question("{question}", "{answer}", "{question_type}", {int(question_version)}, {health_data})')
    res = cursor.fetchone()
    cursor.close()
    return res[0]

def insert_survey_question(survey_id, question_id, last_question, category):
    cursor = db.cursor()
    print(category)
    cursor.execute(f'SELECT insert_survey_question({int(survey_id)}, {int(question_id)}, {int(last_question)}, "{category}")')
    res = cursor.fetchone()
    cursor.close()
    return res[0]