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

  bool provideLocation;

  GoogleMap worldMap;

  Completer<GoogleMapController> controller = Completer();
  static final CameraPosition initialMapCam = CameraPosition(target: LatLng(0,0),
      zoom: 4);

  CameraPosition currentMapCam;

  void initializeLocation() async{

    await location.changeSettings(accuracy: LocationAccuracy.HIGH);

    try {
      bool locationStatus = await location.serviceEnabled();
      if(locationStatus){
        provideLocation = await location.requestPermission();

        if(provideLocation){
          currentLocation = await location.getLocation();
          currentMapCam = CameraPosition(target: LatLng(currentLocation.latitude,
              currentLocation.longitude),   zoom:16);

          final GoogleMapController tempController = await controller.future;
          tempController.animateCamera(CameraUpdate.newCameraPosition(currentMapCam));
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

  @override
  void initState(){
    initializeLocation();
    super.initState();
  }

  Widget getView(){
    if(provideLocation){
      worldMap = GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: initialMapCam,
        onMapCreated: (GoogleMapController con){
          controller.complete(con);
        },
      );

      String msg = "Submitting your location data will allow for you to compare " +
          "your survey results with other anymosuly with other people around you. " +
          "Do you want to provide your location?";

      return Center(
        child: SizedBox(
          height: 300.0,
          child: worldMap,
        ),
      );
    }
  }

  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS Location")),
      body: getView(),
    );
  }
}