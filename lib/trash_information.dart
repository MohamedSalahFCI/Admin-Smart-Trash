import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';

class TrashInformation extends StatefulWidget {
  final bool del;
  final double latitude;
  final double longitude;
  final int id;
  final int trashNum;

  TrashInformation({
    this.del,
    this.latitude,
    this.longitude,
    this.id,
    this.trashNum,
  });
  @override
  _TrashInformationState createState() => _TrashInformationState();
}

class _TrashInformationState extends State<TrashInformation> {
  String trashcanNumber;
  double lat;
  double long;
  MapView mapView = new MapView();
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  CameraPosition cameraPosition;
  var staticMapProvider =
      new StaticMapProvider("AIzaSyDIcMiC8ddzMXceRVPWlEB15Rher_YHSJs");
  Uri staticMapUri;
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

  Future deleteTrash() async {
    var dbToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dbToken";
    print("befour req");
    var resp = await http.delete(
        "https://smart--trash.herokuapp.com/api/v1/trash/$trashcanNumber",
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      print("yes all things is good fel token and now login phase is Active");
      Toast.show("Trash Deleted", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Error");
      Toast.show("Something wrong in deleting Trash", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  showMap() {
    List<Marker> markers = <Marker>[
      new Marker("1", "Trashcan Number $trashcanNumber", lat, long,
          color: Colors.amber)
    ];
    mapView.show(new MapOptions(
      mapViewType: MapViewType.normal,
      initialCameraPosition: new CameraPosition(new Location(lat, long), 0.0),
      showUserLocation: true,
      title: "Trashcan Location",
    ));
    var sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
      mapView.zoomToFit(padding: 50);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      lat = widget.latitude;
      long = widget.longitude;
      staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
          height: 400, width: 900, mapType: StaticMapViewType.roadmap);
    });
    //cameraPosition=new CameraPosition(Location(30.56710, 32.26014), zoom)
    cameraPosition = new CameraPosition(new Location(lat, long), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);
    trashcanNumber = widget.trashNum.toString();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: new Text("Trash Information"),
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 300.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                      child: new Container(
                        child: new Text(
                          "Maps Shoud show Here",
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                      ),
                      onTap: () {
                        showMap();
                      },
                    )
                  ],
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Text(
                  "tap to map to interAct",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 25.0),
                child: new Text(
                    "camera Position : \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new MaterialButton(
          onPressed: () {
            deleteTrash();
          },
          child: new Text(
            'Delete this Trash',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
        ),
      ),
    );
  }
}
