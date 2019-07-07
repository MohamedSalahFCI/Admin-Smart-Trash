import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:b_smart_trash/splashWithLoaer.dart';
import 'package:map_view/map_view.dart';

void main() {
  MapView.setApiKey("AIzaSyDIcMiC8ddzMXceRVPWlEB15Rher_YHSJs");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    //home: Home2(),
  ));
}
