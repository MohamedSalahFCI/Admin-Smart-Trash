import 'package:flutter/material.dart';
import 'package:b_smart_trash/getAllTrashes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:b_smart_trash/trash_information.dart';

class AllTrashes extends StatefulWidget {
  @override
  _AllTrashesState createState() => _AllTrashesState();
}

class _AllTrashesState extends State<AllTrashes> {
  List _data;

  Future<GetAllTrashes> getAllTrashes() async {
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    print("befour req");
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/trash/get",
        headers: headers);
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      return new GetAllTrashes.fromJson(resBody);
    } else {
      print("error");
    }
  }

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    this.getAllTrashes();
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
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
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
                              'ID',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Text(
                              _data[index].id.toString(),
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            new Text(
                              'Color',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Text(
                              _data[index].color.toString(),
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 17),
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
                                  color: Colors.black38, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => TrashInformation(
                            del: _data[index].deleted,
                            latitude: _data[index].destination[0],
                            longitude: _data[index].destination[1],
                            id: _data[index].id,
                            trashNum: _data[index].id,
                          )));
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GetAllTrashes>(
        future: getAllTrashes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiquidPullToRefresh(
              color: Colors.red,
              showChildOpacityTransition: false,
              child: _listView(snapshot.data.myData),
              onRefresh: () => getAllTrashes(),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}
