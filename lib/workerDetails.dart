import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:b_smart_trash/updateProfile.dart';
import 'package:b_smart_trash/updateWorkerProfile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';
import 'globals.dart' as globals;

class ProfileWorker extends StatefulWidget {
  final String img;
  final String firstname;
  final String lastName;
  final String mobNum;
  final String email;
  final String job;
  final int sbusworkerID;
  ProfileWorker(
      {this.img,
      this.firstname,
      this.lastName,
      this.mobNum,
      this.email,
      this.job,
      this.sbusworkerID});
  @override
  _ProfileWorkerState createState() => _ProfileWorkerState();
}

class _ProfileWorkerState extends State<ProfileWorker> {
  String profilePic;
  String fname;
  String lname;
  String mob;
  String mail;
  String job;
  int updatedID;
  String data;
  Map myUsingVar;
  String nameKey = "allAdminData";

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
    //setData();
    profilePic = widget.img;
    fname = widget.firstname;
    lname = widget.lastName;
    mob = widget.mobNum;
    mail = widget.email;
    job = widget.job;
    updatedID = widget.sbusworkerID;
    setData();
  }

  Future deleteWorker() async {
    var dbToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dbToken";
    print("befour req");
    var resp = await http.delete(
        "https://smart--trash.herokuapp.com/api/v1/$updatedID",
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      print("yes all things is good fel token and now login phase is Active");
      Toast.show("Worker Deleted", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      globals.count = 0;
      globals.count2 = 0;
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Error");
      Toast.show("Something wrong in deleting Worker", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
                      image: NetworkImage(profilePic), fit: BoxFit.cover),
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
                  fname + " " + lname,
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
                    job,
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
                    mob,
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
                    mail,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 460),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red.withOpacity(0.8),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => UpdateWorkerdata(
                                      pic: profilePic,
                                      firstName: fname,
                                      secondName: lname,
                                      phoneNum: mob,
                                      email: mail,
                                      workerID: updatedID,
                                    )));
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        "Update",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red.withOpacity(0.8),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () async {
                        deleteWorker();
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        "Delete",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: BottomAppBar(
            //   child: Column(
            //     children: <Widget>[
            //       BottomAppBar(
            //         child: new MaterialButton(
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 new MaterialPageRoute(
            //                     builder: (context) => UpdateWorkerdata(
            //                           pic: profilePic,
            //                           firstName: fname,
            //                           secondName: lname,
            //                           phoneNum: mob,
            //                           email: mail,
            //                           workerID: updatedID,
            //                         )));
            //           },
            //           child: new Text(
            //             '      Update      ',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           color: Colors.red.withOpacity(0.8),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 25,
            //       ),
            //       BottomAppBar(
            //         child: new MaterialButton(
            //           onPressed: () {
            //             deleteWorker();
            //           },
            //           child: new Text(
            //             '      Delete      ',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           color: Colors.red.withOpacity(0.8),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // // bottomNavigationBar: Column(
            //   children: <Widget>[
            //     BottomAppBar(
            //       child: new MaterialButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               new MaterialPageRoute(
            //                   builder: (context) => UpdateWorkerdata(
            //                         pic: profilePic,
            //                         firstName: fname,
            //                         secondName: lname,
            //                         phoneNum: mob,
            //                         email: mail,
            //                         workerID: updatedID,
            //                       )));
            //         },
            //         child: new Text(
            //           '      Update      ',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         color: Colors.red.withOpacity(0.8),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 25,
            //     ),
            //     BottomAppBar(
            //       child: new MaterialButton(
            //         onPressed: () {
            //           deleteWorker();
            //         },
            //         child: new Text(
            //           '      Delete      ',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         color: Colors.red.withOpacity(0.8),
            //       ),
          ),
        ],
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
