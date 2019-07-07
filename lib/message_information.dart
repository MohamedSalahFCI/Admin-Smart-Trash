import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'globals.dart' as globals;

class MessageInfo extends StatefulWidget {
  final int subjectID;
  MessageInfo({this.subjectID});
  @override
  _MessageInfoState createState() => _MessageInfoState();
}

class _MessageInfoState extends State<MessageInfo> {
  Map info;
  int yourNotifyId;
  Future<Map> getMessaeInfo() async {
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/contact-us/" +
            "$yourNotifyId",
        headers: headers);
    print("your status code is");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      setState(() {
        info = resBody;
      });
      return resBody;
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      yourNotifyId = widget.subjectID;
    });
    getMessaeInfo();
  }

  Future<bool> loadData2() async {
    globals.count2 = 0;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: loadData2,
      child: Scaffold(
        appBar: AppBar(
          title: new Text("Replyin Message"),
          elevation: 0.1,
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: <Widget>[
            info == null
                ? new Center(child: new CircularProgressIndicator())
                : Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30, bottom: 15),
                        alignment: Alignment.topCenter,
                        child: new Text(
                          "Replying Information",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sender Name :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            info['name'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sender Telephone Number :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            info['number'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sender Email :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            info['email'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Message sent :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Text(
                              info['message'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Your Reply :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Text(
                              info['reply'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Message sent at :-",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            info['createdAt'].substring(0, 10),
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
