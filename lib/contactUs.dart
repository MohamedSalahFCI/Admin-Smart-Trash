import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';

class ContactUs extends StatefulWidget {
  final String firstName;
  final String secondName;
  final String phoneNum;
  final String email;
  final String dbToken;
  ContactUs(
      {this.firstName,
      this.secondName,
      this.phoneNum,
      this.email,
      this.dbToken});
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formkey = GlobalKey<FormState>();
/*
  String nameKey = "allUserData";
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
*/
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    // setData();
    var fullName = widget.firstName + " " + widget.secondName;
    _fullNameController.text = fullName;
    _phoneNumberController.text = widget.phoneNum;
    _emailController.text = widget.email;
  }

  Future _sendMessageNow() async {
    print("your dbToken is" + " " + widget.dbToken);
    var myToken = widget.dbToken;
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $myToken";
    var messageBody = {
      "name": _fullNameController.text.toString(),
      "number": _phoneNumberController.text.toString(),
      "email": _emailController.text.toString(),
      "message": _messageController.text.toString()
    };
    String jsonBody = json.encode(messageBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/contact-us",
        body: jsonBody,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      print("Message Sent Successfully");
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new HomePage()));
      Toast.show("Message Sent Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      print("Error");
      Toast.show("Something wrong", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        //title: new Text(widget.phoneNum),
        title: new Text(
          "Contact Us",
          style: TextStyle(letterSpacing: 6.0),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30, bottom: 30),
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
              Divider(),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ":",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "01090701456 - 0643454975",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ":",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Mohamed.sallah147@gmail.com",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ":",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Egypt-Ismailia",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: new Text(
                                "Your Name",
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
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                //initialValue: myUsingVar["user"]["firstname"],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.edit)
                                    //border: OutlineInputBorder(),
                                    //labelText: "Email *",isDense: true
                                    ),
                                //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Field cannot be Empty";
                                  } else if (value.length < 2) {
                                    return "Invalid First Name";
                                  }
                                  return null;
                                },
                                controller: _fullNameController,
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
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: new Text(
                                "phone Number",
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
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                //initialValue: myUsingVar["user"]["phone"],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.edit)
                                    //border: OutlineInputBorder(),
                                    //labelText: "Email *",isDense: true
                                    ),
                                //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Field cannot be Empty";
                                  } else if (value.length < 11 ||
                                      value.length < 11) {
                                    return "must be consist of 11 number";
                                  }
                                  return null;
                                },
                                controller: _phoneNumberController,
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
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: new Text(
                                "email",
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
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                //initialValue: myUsingVar["user"]["email"],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.edit)
                                    //border: OutlineInputBorder(),
                                    //labelText: "Email *",isDense: true
                                    ),
                                //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "cannot be Empty";
                                  } else if (value.length < 2) {
                                    return "Invalid First Email";
                                  }
                                  return null;
                                },
                                controller: _emailController,
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
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
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
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
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
                          _sendMessageNow();
                        }
                      },
                      child: new Text(
                        'Send Message Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red.withOpacity(0.8),
                    ),
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
