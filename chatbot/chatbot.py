from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer



def getbot():
    chatbot = ChatBot("Helper2", logic_adapters=
    [{"import_path": "chatterbot.logic.BestMatch"}])

    trainer = ListTrainer(chatbot)

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


    trainer.train(
    "chatterbot.corpus.english.conversations")



    return chatbot

bot   = getbot()
initial = "I have a problem with drugs"
response = bot.get_response(initial)
for i in range(15):
    print(response)
    response = bot.get_response(response)