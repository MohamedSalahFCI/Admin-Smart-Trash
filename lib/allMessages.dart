import 'package:flutter/material.dart';
import 'package:b_smart_trash/getAllMessages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:b_smart_trash/message_information.dart';
import 'package:b_smart_trash/replyMessahePage.dart';
import 'globals.dart' as globals;

class AllMessages extends StatefulWidget {
  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  List _data;
  int coun;
  String nameKey2 = "messageCounter";

  Future<bool> saveData(int x) async {
    globals.count2 = x;
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

  Future<GetAllMessages> getAllMessages() async {
    String dataBaseToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";
    print("befour req");
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/contact-us/get",
        headers: headers);
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      return new GetAllMessages.fromJson(resBody);
    } else {
      print("error");
    }
  }

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
    this.getAllMessages();
    globals.count2 = 0;
  }

  Future _afterReading(int subject, bool status) async {
    String dataBaseToken = myUsingVar["token"];
    if (status) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new MessageInfo(
                    subjectID: subject,
                  )));
    } else if (!status) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new ReplyToWorker(
                    subjectID: subject,
                    token: dataBaseToken,
                  )));
    } else {
      Toast.show("This type of notification is new", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Widget _listView(_data) => new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          if (!_data[index].replyStatus) {
            int z = ++globals.count2;
            saveData(z);
            //++globals.messageCounter;
          }

          // if (!_data[index].read) {
          //   int z = ++globals.count;
          //   saveData(z);
          // }
          return InkWell(
            child: new Card(
              elevation: 4.0,
              //color: Colors.white.withOpacity(0.9),
              //color: setColor(_data[index].read),
              color: _data[index].replyStatus ? Colors.white : Colors.blue[100],
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
                            "Worker Message You",
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
              _afterReading(_data[index].id, _data[index].replyStatus);
            },
          );
        },
      );
/*
  Future<bool> loadData2() async {
    globals.count2 = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globals.count2 = preferences.getInt(nameKey2);
    Navigator.pop(context, true);
  }
*/

  Future<bool> loadData2() async {
    globals.count2 = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globals.count2 = preferences.getInt(nameKey2);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: loadData2,
      child: Scaffold(
        appBar: AppBar(
          title: new Text(
            "Messages ",
            style: TextStyle(letterSpacing: 6.0),
          ),
          elevation: 0.1,
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder<GetAllMessages>(
          future: getAllMessages(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LiquidPullToRefresh(
                color: Colors.red,
                showChildOpacityTransition: false,
                child: _listView(snapshot.data.myData),
                onRefresh: () => getAllMessages(),
              );
            }
            return new Center(child: new CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
