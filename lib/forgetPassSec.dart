import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:b_smart_trash/forgetPassThird.dart';

class Forget2 extends StatefulWidget {
  final String phoneNum;
  Forget2({this.phoneNum});
  @override
  _Forget2State createState() => _Forget2State();
}

class _Forget2State extends State<Forget2> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _codeTextController = new TextEditingController();

  Future _sendingCode() async {
    String Code = _codeTextController.text.toString();
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    var reqBody = {"phone": widget.phoneNum, "verifycode": Code};
    String reqBodyJson = json.encode(reqBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/confirm-code",
        body: reqBodyJson,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new Forget3(
                    finalPhoneNum: widget.phoneNum,
                  )));
      Toast.show("Type New Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      print("Error From sec req");
      Toast.show("Confirm code is Error", context,
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
          "Step2",
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
                              hintText: "Type Verify Code here",
                              icon: Icon(Icons.code),
                              border: InputBorder.none,
                              //border: OutlineInputBorder(),
                              //labelText: "Email *",isDense: true
                            ),
                            //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                            validator: (value) {
                              if (value.isEmpty) {
                                return "The Code Field cannot be Empty";
                              } else if (value.length < 6 || value.length > 6) {
                                return "The Code must be consist of 6 number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: _codeTextController,
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
                              _sendingCode();
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Confirm Code",
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
      ),
    );
  }
}
