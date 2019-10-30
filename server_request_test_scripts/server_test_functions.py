import requests
import json
import socket
import os
import shutil

IP = socket.gethostname()
URL = "http://" + IP + ":80"

class Server_Test_Functions:

    def __init__(self):
        self.__username = ""
        self.__password = ""
        self.__first_name = ""
        self.__last_name = ""
        self.__gender = ""
        self.__birthdate = ""
        self.__current_survey_name = ""
        self.__current_image_name = ""

    def begin(self):
        continueTest = True
        while(continueTest):
            value = input("What function would you like to test? -1 to exit, 0 for login, 1 for sign up, 2 for surveys, 3 for questions, 4 for sending an image: ")
            value = int(value)
            if value == 0:
                self.login_test()
            elif value == 1:
                self.sign_up_test()
            elif value == 2: 
                self.all_surveys_test()
            elif value == 3:
                self.questions_for_surveys_test()
            elif value == 4: 
                self.send_image_test()
            elif value == -1:
                continueTest = False
            else:
                print("Invalid input")

    def login_test(self):
        username = input("enter a username: ")
        password = input("enter a password: ")
        login_dict= {'Username': username, 'Password' : password, 'Type' : 'login'}
        response = requests.post(URL, json=login_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def sign_up_test(self):
        firstName = input("enter a first name: ")
        lastName = input("enter a last name: ")
        username = input("enter a username: ")
        password = input("enter a password: ")
        gender = input("enter gender(M for male, and F for Female): ")
        birthDate = input("enter a birthday exe(YYYY-MM-DD): ")
        sign_up_dict = {'FirstName': firstName, 'LastName': lastName, 'Username': username, 'Password': password,
            'Gender': gender, 'BirthDate': birthDate, 'Type' : 'signup'}
        response = requests.post(URL, json=sign_up_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def all_surveys_test(self):
        all_survey_function_dict = {'Type' : 'getSurveys'}
        response = requests.post(URL, json=all_survey_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def questions_for_surveys_test(self):
        surveyName = input("enter a survey name: ")
        questions_for_surveys_function_dict = { 'SurveyName' : surveyName, 'Type' : 'getQuestionsForSurvey'}
        response = requests.post(URL, json=questions_for_surveys_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def send_image_test(self):
        username = input("Enter username: ")
        imageName = input("Enter an image name: ")
        image = open('images_to_send/' + imageName  + ".jpg", 'rb').read()
        headers = {'content-type': 'image/jpeg', 'username' : username}
        response = requests.post(URL, headers=headers, data=image)
        print(json.dumps(response.json(), indent=4, sort_keys=True))

    #TODO: Figure out how to recive images back with server
    def request_image_test(self):
        path = 'images_to_recieve/'
        if response.status_code == 200:
            response.raw.decode_content = True
            shutil.copyfileobj(response.raw, 0)