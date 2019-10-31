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
            value = input("What function would you like to test? -1 to exit, 0 for login, 1 for sign up, 2 for surveys, 
            , "3 for questions, 4 for sending an image, 5 to recieve an image: ")
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
            elif value == 5:
                self.request_image_test()
            elif value == -1:
                continueTest = False
            else:
                print("Invalid input")

    def login_test(self):
        username = input("enter a username: ")
        password = input("enter a password: ")
        login_dict= {'Username': username, 'Password' : password}
        sendUrl = URL  + '/login'
        response = requests.post(sendUrl, json=login_dict)
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
            'Gender': gender, 'BirthDate': birthDate}
        sendUrl = URL  + '/signup'
        response = requests.post(sendUrl, json=sign_up_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def all_surveys_test(self):
        all_survey_function_dict = ""
        sendUrl = URL  + '/allSurveys'
        response = requests.post(sendUrl, json=all_survey_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def questions_for_surveys_test(self):
        surveyName = input("enter a survey name: ")
        questions_for_surveys_function_dict = { 'SurveyName' : surveyName, 'Type' : 'getQuestionsForSurvey'}
        sendUrl = URL  + '/surveyQuestions'
        response = requests.post(URL, json=questions_for_surveys_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))

    def send_image_test(self):
        username = input("Enter username: ")
        imageName = input("Enter an image name: ")
        image = open('images_to_send/' + imageName  + ".jpg", 'rb').read()
        head = {'username' : username}
        sendUrl = URL  + '/uploadProfilePic'
        multipart_form_data = {
            'image': (imageName, image),
            'username' : username,
        }
        #response = requests.post(sendUrl, headers=headers, data=image)
        response = requests.post(sendUrl, headers = head, files=multipart_form_data)
        print(json.dumps(response.json(), indent=4, sort_keys=True))

    #TODO: Figure out how to recive images back with server
    def request_image_test(self):
        
        username = input("enter username: ")

        head = {'request-type' : 'ProfileImageRequest'}
        request_image_dict = {
            'username' : username,
        }
        sendURL = URL + '/ProfilePic'
        response = requests.post(sendURL, headers = head,json=request_image_dict, stream=True)

        path = 'images_to_recieve/' + username + '.jpg'
        if response.status_code == 200:
            with open(path, 'wb') as out_file:
                response.raw.decode_content = True
                shutil.copyfileobj(response.raw, out_file)
                print("image has been recieved")
        else:
            print(json.dumps(response.json(), indent=4, sort_keys=True))