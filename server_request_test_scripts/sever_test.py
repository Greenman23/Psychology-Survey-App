import requests
import json
import socket
import os

IP = socket.gethostname()
URL = "http://" + IP + ":80"

image = open('images_to_send/cyberCiri.jpg', 'rb').read()
login = {'Username': 'CoolGuy2','Password' :'Pa$$Word2'}

login_joe = {'Username': 'newvegasbestgame', 'Password' : 'NewVegasNeverFalls', 'Type' : 'login'}

login_josephine = {'Username': 'newvegasbestgameever', 'Password' : 'NewVegasNeverFalls', 'Type' : 'login'}

get_surveys = {'Type' : 'getSurveys'}

surveys = { 'SurveyName' : 'Psychological Drug Evaluation', 'Type' : 'getQuestionsForSurvey'}

sign_up = {'FirstName': 'Josephine', 'LastName': 'Cobb', 'Username': 'newvegasbestgameever1', 'Password': 'NewVegasNeverFalls',
           'Gender': 'Female', 'BirthDate': '1836-06-22', 'Type' : 'signup'}


file = {'image' : open('images_to_send/cyberCiri.jpg', 'rb'),
        'Username' : 'JohnnyTronyy',
        'Password' : '123456'}

headers = {'content-type': 'image/jpeg',
           'username' : 'johnisgay'}

r = requests.post(URL, json = surveys)
response = requests.post(URL, headers=headers, data=image)
print(json.dumps(response.json(), indent=4, sort_keys=True))
print(json.dumps(r.json(), indent=4, sort_keys=True))