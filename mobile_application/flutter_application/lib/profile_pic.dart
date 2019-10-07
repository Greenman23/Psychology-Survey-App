// How to use cameras https://pub.dev/packages/camera

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera/new/camera.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter/rendering.dart';
import 'primary_widgets.dart';
import 'Config.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final int CAMERA_ON = 0;
final int NO_CAMERA = 1; 
final int CAMERA_USED = 2;

class ProfilePic extends StatefulWidget
{
  final Config config;
  ProfilePic({Key key, @required this.config}) : super(key:key);
  @override
  State<StatefulWidget> createState() => ProfilePicState();
}

class ProfilePicState extends State<ProfilePic>
{
  Image currentImage;
  CameraController controller;
  List<CameraDescription> allCameras;
  int cameraState;
  String startPath;
  String path;
  var thing;
  void activateCams() async
  {
    allCameras = await availableCameras();
    controller = CameraController(allCameras[1], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (mounted) {
        cameraState = CAMERA_ON;
        update();
      }
    });
    await getTemporaryDirectory().then((dir){

      startPath = dir.path;
      path = join(dir.path, DateTime.now().toIso8601String() + ".jpg");
      File(path).delete();
    });
  }

  @override
  void initState()
  {
    cameraState = NO_CAMERA;
    activateCams();
    super.initState();
  }

  void update() => setState((){});

Widget getView()
{
  if(cameraState == CAMERA_ON)
    {
      return Column(
        children: <Widget>[
          getText("Take a picture"),
           Expanded(child: CameraPreview(controller)),
          getPaddedButton("Take a picture", ()
          {
              controller.takePicture(path).then((err){
              cameraState = CAMERA_USED;
              update();
            });
          }),
        ],
      );
    }

  else if(cameraState == NO_CAMERA)
    {
      return Column(
        children: <Widget>[
          getText("Camera Loading..."),
          getPaddedButton("Skip", (){}),
        ],
      );
    }
  
  else if(cameraState == CAMERA_USED)

      currentImage = Image.file((File(path)));
       widget.config.img = currentImage;
      return Column(
        children: <Widget>[
          getText("Take a picture"),
          Expanded(child: currentImage),
          Row(
            children: <Widget>[
              getPaddedButton("Take another picture", (){
                File(path).delete().then((err)
                {
                  path = join(startPath, DateTime.now().toIso8601String() + ".jpg");
                  cameraState = CAMERA_ON;
                  currentImage = null;
                  widget.config.img = null;
                  update();
                });
              }),

              getPaddedButton("Finish", (){
                Navigator.popUntil(this.context, ModalRoute.withName("/"));
              }),
            ],
          ),

        ],
      );
}


Widget build(BuildContext)
{
  return Scaffold(
    appBar: AppBar(
      title: Text("Profile Picture")
    ),
    body:
    getView(),

  );
}
}