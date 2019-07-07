import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "About Us",
          style: TextStyle(letterSpacing: 6.0),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 15),
            alignment: Alignment.topCenter,
            child: new Text(
              "Smart Trashcan",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: Text(
            "Version 1.0",
            style: TextStyle(color: Colors.black.withOpacity(0.4)),
          )),
          SizedBox(
            height: 80,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "Smart Garbage",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                    "Smart Management system For Solid waste is Important thing in Our Community and main problem .Our App try to solve this problem and Presents The solution  "),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("This App Designed and powerd by"),
                Text(
                  "FCI",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Image.asset('images/momoPhoto.jpg'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
