import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';
import 'package:b_smart_trash/login.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'package:dio/dio.dart' as dio;
import 'package:b_smart_trash/home.dart';

class UpdateWorkerdata extends StatefulWidget {
  final String pic;
  final String firstName;
  final String secondName;
  final String phoneNum;
  final String email;
  final int workerID;
  UpdateWorkerdata(
      {this.pic,
      this.firstName,
      this.secondName,
      this.phoneNum,
      this.email,
      this.workerID});
  @override
  _UpdateWorkerdataState createState() => _UpdateWorkerdataState();
}

class _UpdateWorkerdataState extends State<UpdateWorkerdata> {
  final _formkey = GlobalKey<FormState>();
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  File file;
  String picture;
  int workerId;
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

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _secondNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    _firstNameController.text = widget.firstName;
    _secondNameController.text = widget.secondName;
    _phoneNumberController.text = widget.phoneNum;
    _emailController.text = widget.email;
    picture = widget.pic;
    workerId = widget.workerID;
  }

  Future _updateNow() async {
    if (file == null) {
      var dbToken = myUsingVar["token"];
      var yourID = myUsingVar["user"]["id"];
      Map<String, String> headers = new Map<String, String>();
      headers["Content-Type"] = "application/json";
      headers["Accept"] = "application/json";
      headers["Authorization"] = "Bearer $dbToken";
      var updatedBody = {
        "firstname": _firstNameController.text.toString(),
        "lastname": _secondNameController.text.toString(),
        "email": _emailController.text.toString(),
        "phone": _phoneNumberController.text.toString()
      };
      String jsonBody = json.encode(updatedBody);
      print("befour req");
      var resp = await http.put(
          //"https://smart--trash.herokuapp.com/api/v1/user/23/updateInfo",
          "https://smart--trash.herokuapp.com/api/v1/user/" +
              "$workerId" +
              "/updateInfo",
          body: jsonBody,
          headers: headers);
      print("after req");
      print(resp.statusCode);
      if (resp.statusCode == 201 ||
          resp.statusCode == 200 ||
          resp.statusCode == 204) {
        print("yes all things is good fel token and now login phase is Active");
        Toast.show("Worker Data Updated Successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print("Error");
        Toast.show("Something wrong in first", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else if (file != null) {
      // String base64Image = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      var yourID = myUsingVar["user"]["id"];
      var dbToken = myUsingVar["token"];
      final _dio = new Dio();
      _dio.options.headers = {
        //'Content-Type':'application/json',
        //'Accept':'application/json',
        'Authorization': 'Bearer $dbToken'
      };
      _dio.options.contentType =
          ContentType.parse("application/x-www-form-urlencoded");
      FormData formData = new FormData.from({
        "firstname": _firstNameController.text.toString(),
        "lastname": _secondNameController.text.toString(),
        "email": _emailController.text.toString(),
        "phone": _phoneNumberController.text.toString(),
        "img": new UploadFileInfo(file, fileName),
      });
      /*
      to send mutil files pass with an array
      "files": [
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt")
    ]
       */
      Response resp = await _dio.put(
          "https://smart--trash.herokuapp.com/api/v1/user/" +
              "$workerId" +
              "/updateInfo",
          data: formData);
      print("your status code is ");
      print(resp.statusCode);
      if (resp.statusCode == 201 ||
          resp.statusCode == 200 ||
          resp.statusCode == 204) {
        Toast.show("Worker Data Updated Successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print("Error");
        Toast.show("Something wrong second", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      print("error");
      Toast.show("error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(nameKey, null);
    print("l shared tamam w B null");
  }

  void _choose() async {
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    File _img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = _img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Update Worker Data",
          style: TextStyle(letterSpacing: 0.8),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                        //kda l container nafso lono a7mar y3ny lw shelt l stoor aly t7t dh haykon a7mar
                        color: Colors.red,
                        image: DecorationImage(
                            //image: NetworkImage(myUsingVar["user"]["img"]),
                            //lw 7asal error hna haykon 3shan l satr dh
                            image: file == null
                                ? NetworkImage(picture)
                                : FileImage(file),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        //borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _choose();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text(
                            "Change Photo",
                            //textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: new Text(
                                "First Name",
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
                                controller: _firstNameController,
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
                                "Second Name",
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
                                //initialValue: myUsingVar["user"]["lastname"],
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
                                  } else if (value.length < 2) {
                                    return "Invalid Second Name";
                                  }
                                  return null;
                                },
                                controller: _secondNameController,
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
                    new MaterialButton(
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          //hna hnady 3la l function aly a7na 3ayzen n3mal beha l request
                          _updateNow();
                        }
                      },
                      child: new Text(
                        'Update Now',
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
