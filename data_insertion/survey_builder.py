from sql_manager import get_survey_versions, get_question_versions, get_questions, get_surveys, get_questions_by_survey, insert_survey_version, insert_survey, insert_question_version, insert_question, insert_survey_question
from menu import do_menu, get_int_response, get_str_response

class Survey_Builder:
    def __init__(self):
        self.__question_type = ['MultipleChoice', 'FillInTheBlank',  'MultipleChoiceRadio', 'Disabler']
        self.__initial_options = ['Create Survey']


    def begin(self):
        do_menu("What would you like to do (-1 for quitting)",  self.__initial_options, self.create_survey, self.goodbye)


    def create_survey(self, dont_use = ""):
        print(get_survey_versions())


    def goodbye(self):
        print("Closing")

    
        