import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:badges/badges.dart';
import 'package:b_smart_trash/notification.dart';
import 'package:b_smart_trash/notificationFirst.dart';
import 'package:b_smart_trash/trashIsEmpty.dart';
import 'globals.dart' as globals;

class AlllNotification extends StatefulWidget {
  @override
  _AlllNotificationState createState() => _AlllNotificationState();
}

class _AlllNotificationState extends State<AlllNotification> {
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  List _data;
  int coun;
  String nameKey2 = "NotificationCounter";

  Future<bool> saveData(int x) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(nameKey2, x);
  }

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

  Future<MyNotification> getAllNotifications() async {
    String dataBaseToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";
    print("befour req");
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/notif/get",
        headers: headers);
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      return new MyNotification.fromJson(resBody);
    } else {
      print("error");
    }
  }

  Future _readNotification(int NotID) async {
    String dbToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dbToken";
    var resp = await http.put(
        "https://smart--trash.herokuapp.com/api/v1/notif/" + "$NotID" + "/read",
        headers: headers);
  }

  // Future _afterReading(String description, int subject) async {
  //   String dataBaseToken = myUsingVar["token"];
  //   if (description == "trashCan reply on your message") {
  //     Navigator.push(
  //         context,
  //         new MaterialPageRoute(
  //             builder: (context) => new ReplyingMessage(
  //                   subjectID: subject,
  //                 )));
  //   } else if (description == "Trash Can is Full") {
  //     Navigator.push(
  //         context,
  //         new MaterialPageRoute(
  //             builder: (context) => FullTrashCycle(
  //                   subjectID: subject,
  //                   dbToken: dataBaseToken,
  //                 )));
  //   } else if (description == "someone have this task") {
  //     Navigator.push(
  //         context,
  //         new MaterialPageRoute(
  //             builder: (context) => new HaveThisTask(
  //                   subjectID: subject,
  //                 )));
  //   } else {
  //     Toast.show("This type of notification is new", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   }
  // }

  int ret(String Date) {
    String c = Date.substring(0, 10);
    List y = c.split('-');
    final d = DateTime(int.parse(y[0]), int.parse(y[1]), int.parse(y[2]));
    final date2 = DateTime.now();
    final difference = date2.difference(d).inDays;
    return difference;
  }

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    setData();
    this.getAllNotifications();
    globals.count = 0;
  }

  Widget _listView(_data) => new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          if (!_data[index].read) {
            int z = ++globals.count;
            saveData(z);
            //globals.notificationCounter++;
          }
          return InkWell(
            child: new Card(
              elevation: 4.0,
              //color: Colors.white.withOpacity(0.9),
              //color: setColor(_data[index].read),
              color: _data[index].read ? Colors.white : Colors.blue[100],
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _data[index].description.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            "${ret(_data[index].createdAt.toString())} days ",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            onTap: () {
              _readNotification(_data[index].id);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => TrashEmpty(
                            subjectID: _data[index].subject,
                            firstName: _data[index].resource['firstname'],
                            lastName: _data[index].resource['lastname'],
                            rate: _data[index].resource['rate'],
                            phoneNumger: _data[index].resource['phone'],
                            email: _data[index].resource['email'],
                          )));

              /*
              _afterReading(
                  _data[index].description.toString(), _data[index].subject);
              */
              // Navigator.pushReplacement(context,
              //     new MaterialPageRoute(builder: (context) => MyStepper()));
            },
          );
        },
      );

  Future<bool> loadData2() async {
    globals.count = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globals.count = preferences.getInt(nameKey2);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: loadData2,
      child: Scaffold(
        appBar: AppBar(
          title: new Text(
            "Notifications ",
            style: TextStyle(letterSpacing: 6.0),
          ),
          elevation: 0.1,
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder<MyNotification>(
          future: getAllNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LiquidPullToRefresh(
                color: Colors.red,
                showChildOpacityTransition: false,
                child: _listView(snapshot.data.myData),
                onRefresh: () => getAllNotifications(),
              );
            }
            return new Center(child: new CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
