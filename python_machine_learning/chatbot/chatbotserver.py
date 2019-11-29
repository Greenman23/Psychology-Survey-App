import bottle
import json
import shutil
import io
import os 
from PIL import Image
import base64
bottle.BaseRequest.MEMFILE_MAX = 10240 * 10240


@bottle.post('/')
def index():
    question = bottle.request.json

    print(question)

    resp_dict = {
        'message' : "YOU SUCK KID"
    } 

    resp = json.dumps(resp_dict)
    response_json = json.loads(resp)

    return response_json


bottle.run(host='localhost', port=8090)