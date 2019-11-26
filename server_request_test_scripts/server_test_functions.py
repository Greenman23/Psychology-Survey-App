import requests
import json
import socket
import os
from os import walk
import shutil
from pick import pick
import glob

IP = socket.gethostname()
URL = "http://" + IP + ":80"

bottleUrl = "http://localhost:8080"

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
            title = 'Choose a server function to test: '
            options = ['Login test', 'Signup test', 'Get surveys function', 'Get surveys for a question', 'Send an profile picture image from images to send directory', 
                "Request profile image", "How does my profile feel?", "Connect to image recongnition server directly", 
                "Test sending an image to nodejs for an emotion", "Get survey history for user", "Get questions history for surveys", "lets chat", "Exit"]
            options, value = pick(options, title)
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
            elif value == 6:
                self.theFeels()
            elif value == 7:
                self.imageRecognitionServerDirect()
            elif value == 8:
                self.picture_analysis_test()
            elif value == 9:
                self.survey_history()
            elif value == 10:
                self.survey_history_questions()
            elif value == 11:
                self.chat_bot_tester()
            elif value == 12:
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
        email = input("enter a email: ")
        phone = input("enter phone number: ")
        username = input("enter a username: ")
        password = input("enter a password: ")
        gender = input("enter gender(Male, Female): ")
        race = input("enter your race: ")
        birthDate = input("enter a birthday exe(YYYY-MM-DD): ")
        smoker = input("do you smoke: ")
        education = input("education level: ")
        address = input("your address: ")
        sign_up_dict = {'FirstName': firstName, 'LastName': lastName, 'email' : email, 'PhoneNumber' : phone,
         'Username': username, 'Password': password,
            'Gender': gender, 'Race' : race,'BirthDate': birthDate, 'Smoker' : smoker, 'Education' : education, 'Address' : address}
        sendUrl = URL  + '/signup'
        response = requests.post(sendUrl, json=sign_up_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def all_surveys_test(self):
        all_survey_function_dict = {}
        sendUrl = URL  + '/allSurveys'
        response = requests.post(sendUrl, json=all_survey_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))
        print()

    def questions_for_surveys_test(self):
        surveyName = input("enter a survey name: ")
        questions_for_surveys_function_dict = { 'SurveyName' : surveyName, 'Type' : 'getQuestionsForSurvey'}
        sendUrl = URL  + '/surveyQuestions'
        response = requests.post(sendUrl, json=questions_for_surveys_function_dict)
        print(json.dumps(response.json(), indent=4, sort_keys=True))

    def send_image_test(self):
        username = input("Enter username: ")
        password = input("Enter password: ")
        images = [] 
        mypath = 'images_to_send/'
        os.chdir(mypath)
        for file in glob.glob("*.jpg"):
            images.append(file) 

        if not images:
            print("There are not jpg files in sending images directory")
        else:
            title = 'Choose an image to send: '
            images, index = pick(images, title)
            imageName = images
            image = open(images, 'rb').read()
            head = {'username' : username, 'password' : password}
            sendUrl = URL  + '/uploadProfilePic'
            multipart_form_data = {
                'image': (imageName, image),
                'username' : username,
                'password' : password,
            }
            try:
                response = requests.post(sendUrl, headers = head, files=multipart_form_data)
                print(json.dumps(response.json(), indent=4, sort_keys=True))
            
            except requests.exceptions.Timeout:
                print("There was a timeout error with the server")
            
            except requests.exceptions.TooManyRedirects:
                print("Bad server url")

            except requests.exceptions.RequestException as e:  
                print("Error connecting to server")

    def request_image_test(self):
        
        username = input("enter username: ")
        password = input("enter password: ")

        head = {'request-type' : 'ProfileImageRequest'}
        request_image_dict = {
            'username' : username,
            'password' :password,
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
        
    def theFeels(self):
        username = input("enter username: ")
        password = input("enter password: ")
        the_feels_dict = {
            'username' : username,
            'password' :password,
        }
        sendURL = URL + '/profilePicAnalysis'
        try:
            response = requests.post(sendURL, json=the_feels_dict)
            print(json.dumps(response.json(), indent=4, sort_keys=True))
        
        except requests.exceptions.Timeout:
            print("There was a timeout error with the server")
        
        except requests.exceptions.TooManyRedirects:
            print("Bad server url")

        except requests.exceptions.RequestException as e:  
            print("Error connecting to server")
    
    def imageRecognitionServerDirect(self):
        images = [] 
        mypath = 'images_to_send/'
        os.chdir(mypath)
        for file in glob.glob("*.jpg"):
            images.append(file) 

        if not images:
            print("There are not jpg files in sending images directory")
        else:
            title = 'Choose an image to send: '
            images, index = pick(images, title)
            imageName = images
            image = open(images, 'rb').read()
            sendUrl = URL  + '/uploadProfilePic'
            multipart_form_data = {
                'image': (imageName, image)
            }
            try:
                response = requests.post(bottleUrl, files=multipart_form_data)
                print(json.dumps(response.json(), indent=4, sort_keys=True))
            
            except requests.exceptions.Timeout:
                print("There was a timeout error with the server")
            
            except requests.exceptions.TooManyRedirects:
                print("Bad server url")

            except requests.exceptions.RequestException as e:  
                print("Error connecting to server")

    def picture_analysis_test(self):
        username = input("Enter username: ")
        password = input("Enter password: ")
        images = [] 
        mypath = 'images_to_send/'
        os.chdir(mypath)
        for file in glob.glob("*.jpg"):
            images.append(file) 

        if not images:
            print("There are not jpg files in sending images directory")
        else:
            title = 'Choose an image to send: '
            images, index = pick(images, title)
            imageName = images
            image = open(images, 'rb').read()
            head = {'username' : username, 'password' : password}
            sendUrl = URL  + '/pictureAnalysis'
            multipart_form_data = {
                'image': (imageName, image),
                'username' : username,
                'password' : password,
            }
            try:
                response = requests.post(sendUrl, headers = head, files=multipart_form_data)
                print(json.dumps(response.json(), indent=4, sort_keys=True))
            
            except requests.exceptions.Timeout:
                print("There was a timeout error with the server")
            
            except requests.exceptions.TooManyRedirects:
                print("Bad server url")

            except requests.exceptions.RequestException as e:  
                print("Error connecting to server")

    def survey_history(self):
        username = input("enter username: ")
        password = input("enter password: ")
        userinfo = {
            'username' : username,
            'password' :password,
        }
        sendUrl = URL  + '/userSurveyHistory'
        try:
            response = requests.post(sendUrl, json=userinfo)
            print(json.dumps(response.json(), indent=4, sort_keys=True))
        
        except requests.exceptions.Timeout:
            print("There was a timeout error with the server")
        
        except requests.exceptions.TooManyRedirects:
            print("Bad server url")

        except requests.exceptions.RequestException as e:  
            print("Error connecting to server")

    def survey_history_questions(self):
        username = input("enter username: ")
        password = input("enter password: ")
        surveyname = input("enter survey name: ")
        usersur = {
            'username' : username,
            'password' : password,
            'SurveyName': surveyname,
        }
        sendUrl = URL  + '/userSurveyQuestionHistory'
        try:
            response = requests.post(sendUrl, json=usersur)
            print(json.dumps(response.json(), indent=4, sort_keys=True))
        
        except requests.exceptions.Timeout:
            print("There was a timeout error with the server")
        
        except requests.exceptions.TooManyRedirects:
            print("Bad server url")

        except requests.exceptions.RequestException as e:  
            print("Error connecting to server")
    
    def chat_bot_tester(self):
        username = input("enter username: ")
        password = input("enter password: ")
        msg = input("what do you want to say? ")
        message = {
            'username' : username,
            'password' : password,
            'message': msg,
        }
        sendUrl = URL  + '/chatBotRouter'
        try:
            response = requests.post(sendUrl, json=message)
            print(json.dumps(response.json(), indent=4, sort_keys=True))
        
        except requests.exceptions.Timeout:
            print("There was a timeout error with the server")
        
        except requests.exceptions.TooManyRedirects:
            print("Bad server url")

        except requests.exceptions.RequestException as e:  
            print("Error connecting to server")

