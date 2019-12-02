from bottle import route, request, BaseRequest, run
import json
from kerasmodel import ImageDetection
import shutil
import io
import os 
from PIL import Image
import base64
BaseRequest.MEMFILE_MAX = 10240 * 10240

keras = ImageDetection() 
@route('/')
def notpost():
    return "Please end your image through a post request!"

@route('/', method='POST')
def index():
    image = request.files.get('image')
    path = './images_to_be_feed/' + image.filename
    try:
        save = os.path.join("./images_to_be_feed", image.filename)
        image.save(save)
    except EnvironmentError:
        os.remove(path)
        save = os.path.join("./images_to_be_feed", image.filename)
        image.save(save)

    em = keras.processImage(path)

    if em is None:
        emotion = {
            "Error" : "could not determine emotion from picture"
        }
    else: 
        emotion = {
            "emotion" : em
        }
    emotion = json.dumps(emotion)
    emotion_json = json.loads(emotion)

    return emotion_json


run(host='localhost', port=8080)