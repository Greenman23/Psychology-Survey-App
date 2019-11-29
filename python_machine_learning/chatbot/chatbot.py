from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

class Bot:
    def __init__(self):
        self.__chatbot = ChatBot("Helper2", logic_adapters=
        [{"import_path": "chatterbot.logic.BestMatch"}])


    def trainbot(self):
        trainer = ListTrainer(self.__chatbot)

        trainer.train(
        "chatterbot.corpus.english.conversations")

        trainer.train([
            "I have problems with drugs",
            "Have you looked for help?",
        ])

        trainer.train([
            "I feel suicidal",
            "Do you want to talk about it?",
        ])

        trainer.train([
            "I am depressed",
            "We can help you"
        ])

        trainer.train([
            "Today has been a rough day",
            "Want to talk about it?"
        ])

        big_list= [
            ["I'm struggling with depression", "How can we help you?"],
            ["I tried to kill myself", "You should get in contact with the suicide hotline immediately"],
            ["I want to kill myself", "Please, get in contact with the suicide hotline immediately"],
            ["My family member died", "That's horrible I am sorry to hear that"],
            ["My dog died", "That's a shame about your dog"],
            ["I have been having a lot of suicidal thoughts lately", "What do you think you can do to better control these thoughts"],
            ["My spouse left me", "What do you think caused this? What are you going to do about it?"],
            ["I have been doing drugs for several years", "What do you think it would take to stop?"],
            ["How can I stop doing drugs?", "The first step is admitting you have a problem"],
            ["Where can I get more drugs?", "We are here to help you stop; not get you more?"],
            ["What are some steps I can take to stop doing drugs?", "You can try seeking help from a friend"],
            ["I'm addicted to drugs and I cannot stop", "Drugs are chemically addictive and often hard to kick."],
            ["I am suicidal", "What would you need to change that"],
            ["I considered hanging myself", "This is an awfult way to die and suicide is never the answer. Maybe there is a better solution to your problems"],
            ["Life is not worth it anymore", "That's not true. There are many opportunities in this world"],
            ["I wish there was an easy way out", "If life was easy, it would not be worth it"],
            ["My life is over","Is it really? I don't buy it; you should look for more options"],
            ["Drugs are the only thing that make me feel happy", "That sort of happiness is fleeting"],
            ["I just want an easy out", "Easy ways aren't worth it"],
            ["I fantasize about suicide actively", "Try to think about something better"],
            ["Life is just too hard", "Try breaking your problems down into smaller problems"],
            ["I feel that there is too much pressure on me and I want out", "Maybe it's time for a change of venue"],
            ["If I don't get my fix, I can't think clearly", "You may just have to face the fact that you won't be at your best for a while"],
            ["I've tried to stop doing drugs, and I don't think I'll ever be able to stop"],
            ["I've made a plan to kill myself, and I intend to follow through", "Don't carry out that plan"],
            ["I'm going to hang myself", "Please reach out to someone who can help"],
            ["Everybody hates me, and it would be better if I was gone", "It's probably all in your head"],
            ["Being alive just isn't worth it in this economy", "That's absurd the economy does not decide your worth"]
             ]
        for item in big_list:
            trainer.train(item)


    def get_response(self,mes):
        return self.__chatbot.get_response(mes)

# bot = Bot()
# bot.trainbot()
# initial = "I'm going to hang myself"
# response = initial
# for num in range(15):
#     print(response)
#     response = bot.get_response(response)


