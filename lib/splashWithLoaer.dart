import 'dart:async';
import 'home.dart';
//import 'package:a_smart_trash/animatedLoader.dart';
import 'package:flutter/material.dart';
import 'package:b_smart_trash/login.dart';
import 'package:b_smart_trash/home.dart';
import 'package:b_smart_trash/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String nameKey = "allAdminData";
  String data;
  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future setData() async {
    await loadData().then((value) {
      setState(() {
        data = value;
        print(data);
      });
    });
    print("ana Aho ya $data");
    if (data != null) {
      Timer(
          Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => HomePage())));
    } else {
      Timer(
          Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => LoginPage())));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        /*
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.greenAccent,
                          size: 50.0,
                        ),
                        */
                        /*
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI5ddbA6Nh4Zv99FZO-4eu3oyymFsq6Y9AcBdd8lLldAAn3da3"),
                      */
                        //child: Image.asset('images/trashlogo.jpg'),
                      ),

                      */

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Smart Trashcan",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.yellowAccent,
                    ),

                    //Loader(),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                    Text(
                      //"Online Store \n for Everyone",
                      "Please wait a Moment ..",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
