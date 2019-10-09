// Using location and Google maps: https://github.com/Lyokone/flutterlocation

import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'primary_widgets.dart';
import 'Config.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPSLocation extends StatefulWidget {

  final Config config;

  GPSLocation({Key key, @required this.config}) : super(key: key);

  @override
  _GPSLocationState createState() => _GPSLocationState();

}

class _GPSLocationState  extends State<GPSLocation> {

  Location location = new Location();

  LocationData currentLocation;

  double currentLongitude, currentLatitude;

  String error;

  bool provideLocation = false;

  GoogleMap worldMap;

  Completer<GoogleMapController> controller = Completer();
  static final CameraPosition initialMapCam = CameraPosition(target: LatLng(0,0),
      zoom: 4);

  CameraPosition currentMapCam;

  @override
  void initState(){
    super.initState();
    initializeLocation();
  }


  initializeLocation() async{

    //await location.changeSettings(accuracy: LocationAccuracy.HIGH);

    LocationData tempLoc;

    try {
      bool locationStatus = await location.serviceEnabled();
      print("LocationStatus: " + locationStatus.toString());
      if(locationStatus){
        provideLocation = await location.requestPermission();
        print("Provide Location Inside Location Status: " + provideLocation.toString());
        if(provideLocation){
          tempLoc = await location.getLocation();
          currentMapCam = CameraPosition(target: LatLng(tempLoc.latitude,
              tempLoc.longitude),   zoom:16);

          final GoogleMapController tempController = await controller.future;
          tempController.animateCamera(CameraUpdate.newCameraPosition(currentMapCam));

          if(mounted){
            setState(() {
              currentLocation = tempLoc;
            });
          }
        }

        else {
          bool locationStatus = await location.serviceEnabled();
          if(locationStatus){
            initializeLocation();
          }
        }
      }
    } on PlatformException catch (e){
      if(e.code == 'PERMISSION_DENIED'){
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR'){
        error = e.message;
      }
      currentLocation = null;
    }
  }

  Widget getView() {
    print("The user provided his Location? " + provideLocation.toString());
    worldMap = GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: initialMapCam,
      onMapCreated: (GoogleMapController con) {
        controller.complete(con);
      },
    );

    String msg = 'Submitting your location data will allow for you to compare ' +
        'your survey results with other anymosuly with other people around you. ' +
        'Do you want to provide your location?';

    //TODO: Add logic for if the user does not enable location handling
    //TODO: Add user location information to config
    return Stack(
      children: <Widget>[
        new Container(
          height: 250,
          alignment: Alignment.topCenter,
          child: worldMap,
        ),
        new Container(
          alignment: Alignment.center,
          child: new Text(msg),
        ),
        new Container(
          alignment: Alignment.bottomLeft,
          child: getPaddedButton(
              "Yes", () {
                Navigator.popUntil(this.context, ModalRoute.withName("/"));
          }),
        ),
        new Container(
          alignment: Alignment.bottomRight,
          child: getPaddedButton(
              "No", () {
            Navigator.popUntil(this.context, ModalRoute.withName("/"));
          }),
        )
      ],
    );
  }

  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS Location")),
      body: getView(),
    );
  }
}