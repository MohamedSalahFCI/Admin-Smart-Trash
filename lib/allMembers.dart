import 'package:flutter/material.dart';
import 'package:b_smart_trash/getAllUsers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b_smart_trash/workerDetails.dart';

class AllMembers extends StatefulWidget {
  @override
  _AllMembersState createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  List _data;
  String s = null;
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

  Future<GetAllUsers> getAllUsers() async {
    var dbToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dbToken";
    print("befour req");
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/getAll",
        headers: headers);
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      setState(() {
        s = "mesh null";
      });
      return new GetAllUsers.fromJson(resBody);
    } else {
      print("error");
    }
  }

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    setData();
    this.getAllUsers();
  }

  Widget _listView(_data) => new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: new Card(
              elevation: 4.0,
              color: Colors.white.withOpacity(0.9),
              child: Container(
                alignment: Alignment.center,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                              //kda l container nafso lono a7mar y3ny lw shelt l stoor aly t7t dh haykon a7mar
                              color: Colors.blue,
                              image: DecorationImage(
                                  image: NetworkImage(_data[index].img),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 3.0, color: Colors.black)
                              ]),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          _data[index].firstname + " " + _data[index].lastname,
                          style: TextStyle(color: Colors.black38, fontSize: 16),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  'Job',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  _data[index].type.toString(),
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  'Phone',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  _data[index].phone.toString(),
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  'Company',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  "FCI",
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ProfileWorker(
                            img: _data[index].img,
                            firstname: _data[index].firstname,
                            lastName: _data[index].lastname,
                            mobNum: _data[index].phone,
                            email: _data[index].email,
                            job: _data[index].type,
                            sbusworkerID: _data[index].id,
                          )));
            },
          );
        },
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GetAllUsers>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiquidPullToRefresh(
              color: Colors.red,
              showChildOpacityTransition: false,
              child: _listView(snapshot.data.myData),
              onRefresh: () => getAllUsers(),
            );
          }
          // else if (snapshot.hasError) {
          //   return new Text("${snapshot.error}");
          // }
          return new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}
