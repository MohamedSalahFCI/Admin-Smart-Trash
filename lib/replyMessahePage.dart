import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';
import 'globals.dart' as globals;

class ReplyToWorker extends StatefulWidget {
  final int subjectID;
  final String token;
  // final String senderName;
  // final String senderTelephoneNumber;
  // final String senderEmail;
  // final String workerMessage;
  // final String sentAt;
  ReplyToWorker({this.subjectID, this.token
      // this.senderName,
      // this.senderTelephoneNumber,
      // this.senderEmail,
      // this.workerMessage,
      // this.sentAt
      });
  @override
  _ReplyToWorkerState createState() => _ReplyToWorkerState();
}

class _ReplyToWorkerState extends State<ReplyToWorker> {
  Map info;
  int yourNotifyId;
  String adminToken;
  TextEditingController _messageController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

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
      adminToken = widget.token;
    });
    getMessaeInfo();
  }

  Future _sendReplyNow() async {
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $adminToken";
    var messageBody = {"reply": _messageController.text.toString()};
    String jsonBody = json.encode(messageBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/contact-us/$yourNotifyId/reply",
        body: jsonBody,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      print("Reply Sent Successfully");
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new HomePage()));
      Toast.show("Reply Sent Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      print("Error");
      Toast.show("Something wrong", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
          title: new Text(
            "Replying Message",
            style: TextStyle(letterSpacing: 3.0),
          ),
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
                      Form(
                          key: _formkey,
                          child: Column(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6.0),
                                          child: new Text(
                                            "Your Message",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.black.withOpacity(0.2),
                                        elevation: 0.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6.0),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            //initialValue: myUsingVar["user"]["email"],
                                            decoration: InputDecoration(
                                              hintText: "Type Message Here",
                                              border: InputBorder.none,
                                              icon: Icon(Icons.message),
                                              //border: OutlineInputBorder(),
                                              //labelText: "Email *",isDense: true
                                            ),
                                            //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "cannot be Empty";
                                              } else if (value.length < 2) {
                                                return "Invalid message";
                                              }
                                              return null;
                                            },
                                            controller: _messageController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(),
                                new MaterialButton(
                                  onPressed: () {
                                    if (_formkey.currentState.validate()) {
                                      //hna hnady 3la l function aly a7na 3ayzen n3mal beha l request
                                      globals.count2 = 0;
                                      _sendReplyNow();
                                    }
                                  },
                                  child: new Text(
                                    'Send Reply Now',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.red.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ]))
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
