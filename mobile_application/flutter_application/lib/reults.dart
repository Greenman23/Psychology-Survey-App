import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class Results extends StatelessWidget {
  List<String> imageRandomization = ["https://www.petmd.com/sites/default/files/petmd-kitten-facts.jpg",
    "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/03/05/12/kittens.jpg?w968h681",
    "https://icatcare.org/app/uploads/2018/07/Finding-homes-for-your-kittens-1.png", "https://images2.minutemediacdn.com/image/upload/c_crop,h_2276,w_4043,x_0,y_23/f_auto,q_auto,w_1100/v1553128862/shape/mentalfloss/536413-istock-459987119.jpg",
    "https://media.mnn.com/assets/images/2018/05/puppies_dog_bed.jpg.653x0_q80_crop-smart.jpg",
    "https://cdn-img.health.com/sites/default/files/styles/large_16_9/public/1544040067/GettyImages-900604650.jpg?itok=7HCwSFzI&1544040523"];
  bool surveyDistinction = false; //True related to Drug Survey, False related to Suicide Survey
  Random rand = new Random();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                getText(_surveyDistinctionPrompt(surveyDistinction)),
                getText("If you want to talk to someone\n"
                ),
                getPaddedButton("Hotline", (){
                  _launchCaller();
                }),
                Image.network(imageRandomization[rand.nextInt(imageRandomization.length - 1)]),
                getPaddedButton("Finish", () {
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                })
              ],
            )),
      ),
    );
  }
}
//Implementation of Variable Results needed or a possible bell curve graph
_surveyDistinctionPrompt(bool result){
  if (result == true)
    return "You score __% on the Drug Abuse Spectrum";
  else
    return "You score __% on the Suicidality Spectrum";
}
_launchCaller() async {
  const url = "tel:18002738255";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
