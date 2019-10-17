from sql_manager import get_survey_versions, get_question_versions, get_questions, get_surveys, get_questions_by_survey, insert_survey_version, insert_survey, insert_question_version, insert_question, insert_survey_question
from menu import do_menu, get_int_response, get_str_response
from util import get_items_of_index

class Survey_Builder:
    def __init__(self):
        self.__question_type = ['MultipleChoice', 'FillInTheBlank',  'MultipleChoiceRadio', 'Disabler']
        self.__initial_options = ['Create Survey', 'Create Questions', 'Modify Survey']
        self.__survey_version_id = -1
        self.__survey_id = -1
        self.__last_survey_question_id = -1
        self.__total_survey = {}
        self.__last_question_id = -1
        self.__categories = []
        self.__current_survey_version_description = ""
        self.__current_survey_version_name = ""
        self.__current_question_version_name = ""        

    def begin(self):
        val = do_menu("What would you like to do (-1 for quitting) ",  self.__initial_options)
        if(val == 0):
            self.create_survey()
            self.add_questions_to_survey()
        else:
            self.goodbye()


    def create_survey(self, dont_use = ""):
        survey_items_total = get_survey_versions()
        survey_items = get_items_of_index(survey_items_total, 1)
        val = do_menu("What survey version would you like to base this off of (-1 for making new survey version) ", survey_items)
        if val == -1:
            self.__survey_version_id = self.create_survey_version()
        else:
            self.__survey_version_id = survey_items_total[val][0]
            self.__current_survey_version_name = survey_items_total[val][1]
            self.__current_question_version_description = survey_items_total[val][2]

        ret_val= -1
        while(ret_val == -1):
            print("Now to make the actual survey; (-1 to use same) ")
            survey_name = input("Give a survey name ")
            if survey_name == "-1":
                survey_name = self.__current_survey_version_name
                description = self.__current_survey_version_description
                ret_val = insert_survey(survey_name, description, self.__survey_version_id)
            else:  
                description = input("Give a survey description ")
                ret_val = insert_survey(survey_name, description, self.__survey_version_id)
        self.__survey_id = ret_val
        return ret_val



    def create_survey_version(self):
        ret_val = -1
        survey_name = ""
        description = ""
        while ret_val == -1:
            survey_name = input("Give a survey name ")
            description = input("Give a survey description ")
            ret_val = insert_survey_version(survey_name, description)
            print(ret_val)
        self.__current_survey_version_name = survey_name
        self.__current_question_version_description = description
        return ret_val


    def add_questions_to_survey(self):
        val = -1
        while val != -2:
            questions = get_questions()
            val = do_menu("Choose a question to add (-1 for new questions -2 to finish) ", questions, -2)
            if(val == -1):
                self.create_question_version()
            elif(val >= 0):
                self.add_question(questions[val])


    def create_question_version(self):
        question_versions = get_question_versions()
        question_version_names = get_items_of_index(question_versions, 1)
        val = do_menu("Choose a question version (-1 to make a new one) ", question_version_names)
        question_version_id = -1
        if(val == -1):
            while question_version_id == -1:
                version_name = input("What do you want to name your question? ")
                self.__current_question_version_name = version_name
                question_version_id = insert_question_version(version_name)
        else:
            question_version_id = question_versions[val][0]
            self.__current_question_version_name = question_versions[val][1]

        self.create_question(question_version_id)

       
    def create_question(self, question_version_id):
        response_id = -1
        while response_id == -1:
            question = input("What is the prompt for your question? (-1 for same)")
            if question == -1:
                question = self.__current_question_version_name
            question_type = self.__question_type[do_menu("What type of question ", self.__question_type, 0)]
            health_data = True if do_menu("Is there sleep data? ", ["Yes", "No"], False) == 1 else  False
            answer = {}
            key = 0
            while key != "-1":
                key = input("Provide an anwer key (Type -1) to quit ")
                if key != "-1":
                    val_pair = input("Provide a value ")
                    answer[key] = val_pair
            response_id = insert_question(question, str(answer), question_type, question_version_id, health_data)    
            
    def add_question(self, val):
        survey_id = self.__survey_id
        question_id = val[0]
        last_question = self.__last_question_id
        category = ""
        category_num = do_menu("Pick a category (-1 to make new category) ", self.__categories)
        if(category_num == -1):
            self.__categories.append(input("Make a new category "))
            category = self.__categories[-1]
        else:
            category = self.__categories[category_num]
        
        self.__last_question_id = insert_survey_question(survey_id, question_id, last_question, category)

        
    def goodbye(self):
        print("Closing")

    
        