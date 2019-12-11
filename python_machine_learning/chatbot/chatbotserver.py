from bottle import Bottle, run, BaseRequest, request
import json
from chatbot import Bot
BaseRequest.MEMFILE_MAX = 10240 * 10240

app = Bottle()

helper = Bot()
helper.trainbot()

@app.route('/')
def noindex():
    return "You cannot talk to me this way. Please talk to me via post"

@app.route('/', method='POST')
def index():
    question = request.json
    ask = question['message']
    answer = helper.bot_response(ask)
    resp_dict = {
        'message' : str(answer),
    } 
    resp = json.dumps(resp_dict)
    response_json = json.loads(resp)
    return response_json

run(app, host="localhost", port=8090, reloader=True, debug=True)