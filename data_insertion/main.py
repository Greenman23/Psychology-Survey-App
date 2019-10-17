from sql_connection import db
from survey_builder import Survey_Builder

build= Survey_Builder()
build.begin()

'''
cursor = db.cursor()
cursor.callproc("get_questions")
results = []
for result in cursor.stored_results():
    val = result.fetchall()
    print(val)
    results.append(val)

print(results)

cursor.callproc("get_survey_versions")
for result in cursor.stored_results():
    val = result.fetchall()
    print(val)
    results.append(val)

print(results)

cursor.execute("SELECT insert_question_version(\"asd\", \"asdf\")")

for result in cursor.stored_results():
    val = result.fetchall()
    print(val)
    results.append(val)

print(results)
print(cursor.fetchone())
cursor.execute("SELECT insert_question_version(\"asd\", \"asdf\")")


print(cursor.fetchone())
print(results)
cursor.close()
cursor = db.cursor()

name = "me"
cursor.callproc("get_questions_by_survey", [name])
results = []
for result in cursor.stored_results():
    results.append(result)
'''
 