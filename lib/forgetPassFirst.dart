import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:b_smart_trash/forgetPassSec.dart';
import 'package:toast/toast.dart';

class Forget1 extends StatefulWidget {
  @override
  _Forget1State createState() => _Forget1State();
}

class _Forget1State extends State<Forget1> {
  //han3mal request anna n chech lw l Raqam dh asln mawgood wla eh
  final _formkey = GlobalKey<FormState>();
  TextEditingController _telephoneNumTextController =
      new TextEditingController();
  Future _chechPhoneExist() async {
    String phoneNumber = _telephoneNumTextController.text.toString();
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    var reqBody = {
      "phone": phoneNumber,
    };
    String reqBodyJson = json.encode(reqBody);
    print("befour req");
    var resp = await http.put(
        "https://smart--trash.herokuapp.com/api/v1/check-exist-phone",
        body: reqBodyJson,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    print(resp.body);
    var s = json.decode(resp.body);
    print(s["duplicated"]);
    if (resp.statusCode == 204 || resp.statusCode == 200) {
      print("kda l rakam mawgood");
      if (s["duplicated"] == true) {
        var resp2 = await http.post(
            "https://smart--trash.herokuapp.com/api/v1/forget-password",
            body: reqBodyJson,
            headers: headers);
        print(resp2.statusCode);
        if (resp2.statusCode == 201 ||
            resp2.statusCode == 200 ||
            resp2.statusCode == 204) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new Forget2(
                        phoneNum: phoneNumber,
                      )));
          Toast.show("Reciving Code", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          print("Chech InterNet Connetion");
        }
      }
    } else {
      Toast.show("Incorrect Phone Number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: new Text(
            "Step1",
            style: TextStyle(letterSpacing: 6.0),
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black.withOpacity(0.4),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Telephone Number",
                                icon: Icon(Icons.phone),
                                border: InputBorder.none,
                                //border: OutlineInputBorder(),
                                //labelText: "Email *",isDense: true
                              ),
                              //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "The PhoneNumber Field cannot be Empty";
                                } else if (value.length < 11) {
                                  return "The phone number must be consist of 11 number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: _telephoneNumTextController,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red.withOpacity(1.0),
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                //hna hnady 3la l function aly a7na 3ayzen n3mal beha l request
                                _chechPhoneExist();
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              "Send Code",
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
                )
              ],
            ),
          ),
        ));
  }
}
