import 'package:flutter/material.dart';
import 'package:b_smart_trash/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b_smart_trash/forgetPassFirst.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String m = "kolo tmm";
  TextEditingController _telephoneNumTextController =
      new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  final FirebaseMessaging _messaging = FirebaseMessaging();
  var mob_token;

  //l goz2 bta3 l shared pref
  String nameKey = "allAdminData";
  String allRespBody;
  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(nameKey, allRespBody);
    print("l shared tamam " + allRespBody);
  }

  Future finalLogIn() async {
    print("yes you are in login function now");
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";

    var loginBody = {
      "phone": _telephoneNumTextController.text.toString(),
      "password": _passwordTextController.text.toString()
    };
    String jsonBody = json.encode(loginBody);
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/signin",
        body: jsonBody,
        headers: headers);
    print(resp.body);
    print(resp.statusCode);
    final resBody = json.decode(resp.body);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      print("wel login kaman tamam");
      print(resBody);
      setState(() {
        allRespBody = json.encode(resBody);
      });
      print("hnroo7 ll shared");
      await saveData();
      print("rg3na mn l shared");
      print(resBody["token"]);
      Toast.show("Login Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      await loadToken(resBody["token"]);
    } else {
      print("Error to login");
      Toast.show("Telephone Number and Password don't match", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future loadToken(String dataBaseToken) async {
    await _messaging.getToken().then((token) {
      print("your token is " + token);
      setState(() {
        mob_token = token;
      });
      print("your var local is " + mob_token);
      //hna hanady 3la l function bta3t l post bta3 l token
    });

    //goz2 l 5as be post l token
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";

    // var tokenBody = {
    //   "token": mob_token,
    // };

    var tokenBody = {
      "token":
          "cjsKu4AlvTE:APA91bEIwipoU0wTm1eqExnvEGn_Gq1ouEMC0MoDzYzwhV9H_oatG2EnN1fVQdYzFmwRI_RL7f0oev04K6E7MCiXGxsaBlJQ21kONoANksfmTO9W7yiwDCM379bUYCunZ7kugOzMoHW9",
    };
    String jsonBody = json.encode(tokenBody);
    print("befour req");
    /*
      eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMyIsImlzcyI6ImJvb2RyQ2FyIiwiaWF0IjoxNTU4N
      Dg5NDEwODkzLCJleHAiOjE1NTg1MjA5NDY4OTN9.EyqEN1H7JLyPFDET8xbyr79n0J0E7LLQcim3aeE2thA
     */
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/addToken",
        body: jsonBody,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    //hna mafesh response Body Rag3 f a7na han4mal check 3la l status code w b3den hanro7 3la l function l tanya
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      print("yes all things is good fel token and now login phase is Active");
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => new HomePage()));
    } else {
      print("Error fel send token");
    }
  }

  Future _login() async {
    await finalLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          /*
          //L goz2 bta3 l indcator
          Visability(
            visible:Loading??true,
            child:Center(
              alignment:Alignment.center,
              color:Colors.white.withOpacity(0.9),
              child:CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation<Color>(Colors.red)
              ),
            ),
          ),
           */
          /*
          Image.asset(
            'images/yelldre.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          */
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.only(top: 130),
            alignment: Alignment.topCenter,
            /*
              child: Image.asset(
                'images/lg.png',
                width: 280.0,
                height: 240.0,
              )
              */
            child: new Text(
              "Smart Trashcan",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          ListView(children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 250.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Form(
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
                                    }
                                    //  else if (value.length < 11 ||
                                    //     value.length < 11) {
                                    //   return "The phone number must be consist of 11 number";
                                    // }
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
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.4),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    icon: Icon(Icons.lock_outline),
                                    border: InputBorder.none,
                                    //border: OutlineInputBorder(),
                                    //labelText: "Email *",isDense: true
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The Password Field cannot be Empty";
                                    } else if (value.length < 6) {
                                      return "The Password has To be at least 6 charactars long";
                                    }
                                    return null;
                                  },
                                  //keyboardType: TextInputType.,
                                  obscureText: true,
                                  controller: _passwordTextController,
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

                                    _login();
                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Login",
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
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => new Forget1()));
                                },
                                child: Text(
                                  "Forget password..?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          /*
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, new MaterialPageRoute(builder: (context)=>new SignUp() ));
                                  },
                                   child: RichText(
                                  text: TextSpan(
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.0),
                                  children:[
                                    TextSpan(
                                      text: "Dont't have an accout? click here to"
                                    ),
                                    TextSpan(
                                        text: " sign up!",
                                      style: TextStyle(color: Colors.red)

                                    )
                                  ]
                                )),
                              )
//                            Text("Dont't have an accout? click here to sign up!",textAlign: TextAlign.end, style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w400, fontSize: 16.0),),
                            ),
                            */
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
      /*
      bottomNavigationBar: Container(
        //hna han7ot l zorar bta3 login
        child: Row(
          children: <Widget>[
            Expanded(
              child: new MaterialButton(
                onPressed: (){} ,
                child: new Text('LogIn Now',style: TextStyle(color: Colors.white),),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      */
    );
  }
}
