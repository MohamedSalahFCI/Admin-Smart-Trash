import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:b_smart_trash/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/profilePage.dart';
import 'package:b_smart_trash/contactUs.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:badges/badges.dart';
import 'package:b_smart_trash/aboutUs.dart';
import 'package:b_smart_trash/allMembers.dart';
import 'package:b_smart_trash/allTrashes.dart';
import 'dart:math' as math;
import 'package:b_smart_trash/addWorker.dart';
import 'package:b_smart_trash/addTrash.dart';
import 'package:b_smart_trash/allNotification.dart';
import 'globals.dart' as globals;
import 'package:b_smart_trash/allMessages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [
    Icons.person_add,
    Icons.delete,
  ];
  String nameKey = "allAdminData";
  String nameKey2 = "NotificationCounter";
  String nameKey3 = "messageCounter";
  String data;
  Map myUsingVar;
  List _data;
  int _counter = 0;
  int _messageCount = 0;
  TabController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<int> loadData2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _counter = preferences.getInt(nameKey2);
    });
    return _counter;
  }

  Future<int> loadData3() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _messageCount = preferences.getInt(nameKey3);
    });
    return _messageCount;
  }

  // Future setData2() async {
  //   await loadData2().then((value) {
  //     setState(() {
  //       _counter = value as int;
  //     });
  //   });
  // }

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

  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(nameKey, null);
    print("l shared tamam w B null");
  }

  Future logoutPress() async {
    String dataBaseToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";
    var reqBody = {
      "token": myUsingVar["user"]["token"],
    };
    String reqBodyJson = json.encode(reqBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/logout",
        body: reqBodyJson,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      print("kda hwa 3mal logout 7oot b2a l shared b null");
      await saveData();
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
      Toast.show("Logout Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //Fluttertoast.showToast(msg: "Logout Successfully");
    } else {
      print("error");
      Toast.show("Error In Logout", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //Fluttertoast.showToast(msg: "Error In Logout");
    }
  }

//hanshof 7att l async de
  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    setData();
    loadData2();
    loadData3();
    //this.getAllTasks();
    globals.count = 0;
    globals.count2 = 0;
    controller = new TabController(vsync: this, length: 4);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: new Text(
          "Home",
          style: TextStyle(letterSpacing: 6.0),
        ),
        actions: <Widget>[
          BadgeIconButton(
              itemCount: globals.count == 0 ? _counter : globals.count,
              //itemCount: 6,
              //l loon aly haytkatb 3aleh
              badgeColor: Colors.blue,
              //aly gay dh l rakam aly gwa haytkatb b eh
              badgeTextColor: Colors.white,
              icon: Icon(
                Icons.notifications,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AlllNotification()));
              }),
          BadgeIconButton(
              //itemCount: _counter,
              itemCount: globals.count2 == 0 ? _messageCount : globals.count2,
              //l loon aly haytkatb 3aleh
              badgeColor: Colors.blue,
              //aly gay dh l rakam aly gwa haytkatb b eh
              badgeTextColor: Colors.white,
              icon: Icon(
                Icons.message,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AllMessages()));
              }),
        ],
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(
              child: Text("MEMBERS"),
            ),
            new Tab(
              child: Text("TRASHES"),
            ),
          ],
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(
                myUsingVar["user"]["firstname"] +
                    " " +
                    myUsingVar["user"]["lastname"],
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(myUsingVar["user"]["email"],
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(myUsingVar["user"]["img"]),
                  //child: Icon(Icons.person,color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red),
            ),
            //body
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                title: new Text("Home"),
                leading: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Profile()));
              },
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ContactUs(
                              firstName: myUsingVar["user"]["firstname"],
                              secondName: myUsingVar["user"]["lastname"],
                              phoneNum: myUsingVar["user"]["phone"],
                              email: myUsingVar["user"]["email"],
                              dbToken: myUsingVar["token"],
                            )));
              },
              child: ListTile(
                title: Text('Contact Us'),
                leading: Icon(Icons.shopping_basket, color: Colors.blue),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AboutUs()));
              },
              child: ListTile(
                title: new Text("About Us"),
                leading: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                //hna mafrod n3mal l request bta3 l logout bass hanmsheha 3ady dlw2y
                logoutPress();
              },
              child: ListTile(
                title: Text('LogOut'),
                leading: Icon(Icons.help, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new AllMembers(),
          new AllTrashes(),
        ],
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor,
                mini: true,
                //child: new Icon(icons[index], color: foregroundColor),
                child: new Icon(icons[index], color: Colors.red),
                onPressed: () {
                  if (index == 0) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddNewWorker()));
                  } else if (index == 1) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddNewTrash()));
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            new FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: null,
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(
                        _controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                        _controller.isDismissed ? Icons.add : Icons.close),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      ),
    );
  }
}
