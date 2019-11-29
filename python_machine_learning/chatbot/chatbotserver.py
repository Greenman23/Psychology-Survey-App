import bottle
import json
import shutil
import io
import os 
from PIL import Image
from chatbot import Bot
import base64
bottle.BaseRequest.MEMFILE_MAX = 10240 * 10240


helper = Bot()
helper.__init__()
helper.trainbot()

@bottle.post('/')
def index():
    question = bottle.request.json
    ask = question['message']
    answer = helper.bot_response(ask)
    resp_dict = {
        'message' : str(answer),
    } 
    resp = json.dumps(resp_dict)
    response_json = json.loads(resp)
    return response_json


bottle.run(host='localhost', port=8090)