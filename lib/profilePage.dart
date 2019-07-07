import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:b_smart_trash/updateProfile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future setData() async {
    await loadData().then((value) {
      setState(() {
        data = value;
        print(data);
        myUsingVar = json.decode(data);
      });
    });
    print("ana Aho ya $myUsingVar");
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
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.red.withOpacity(0.8),
              height: 350,
            ),
            clipper: getClipper(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(130.0),
            child: Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                  //kda l container nafso lono a7mar y3ny lw shelt l stoor aly t7t dh haykon a7mar
                  color: Colors.red,
                  image: DecorationImage(
                      image: NetworkImage(myUsingVar["user"]["img"]),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 260),
            child: Container(
              height: 40,
              child: Center(
                child: Text(
                  myUsingVar["user"]["firstname"] +
                      " " +
                      myUsingVar["user"]["lastname"],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 350, left: 20, right: 20),
            child: Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    "Type :-",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    myUsingVar["user"]["type"].toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 380, left: 20, right: 20),
            child: Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    "Phone Number :-",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    myUsingVar["user"]["phone"],
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 410, left: 20, right: 20),
            child: Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    "Email :-",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    myUsingVar["user"]["email"],
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new UpdateProfiledata(
                          pic: myUsingVar["user"]["img"],
                          firstName: myUsingVar["user"]["firstname"],
                          secondName: myUsingVar["user"]["lastname"],
                          phoneNum: myUsingVar["user"]["phone"],
                          email: myUsingVar["user"]["email"],
                        )));
          },
          child: new Text(
            'Update Profile Data',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red.withOpacity(0.8),
        ),
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.3);
    path.lineTo(size.width + 250, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
