import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewTrash extends StatefulWidget {
  @override
  _AddNewTrashState createState() => _AddNewTrashState();
}

class _AddNewTrashState extends State<AddNewTrash> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _colorController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();
  String nameKey = "allAdminData";
  String data;
  Map myUsingVar;
  var location = new Location();
  List<Company> _compines = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenueItems;
  Company _selectedCompany;
  Map<String, double> userLocation;
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

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future setNewTrash(String yourColor) async {
    var dbToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dbToken";
    var trashInfoBody = {
      "destination": [userLocation["latitude"], userLocation["longitude"]],
      "color": yourColor,
      "number": _numberController.text
    };
    String jsonBody = json.encode(trashInfoBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/trash",
        body: jsonBody,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      print("yes all things is good fel token and now login phase is Active");
      Toast.show("Trash Add Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Error");
      Toast.show("Something wrong in Adding Trash", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
    _dropdownMenueItems = buildDropdownMenuItems(_compines);
    _selectedCompany = _dropdownMenueItems[0].value;
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(DropdownMenuItem(
        value: company,
        child: Text(company.name),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Add new Trash",
          style: TextStyle(letterSpacing: 6.0),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: new Text(
                                "Trash Color",
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
                            color: Colors.black.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: _selectedCompany,
                                    items: _dropdownMenueItems,
                                    onChanged: onChangeDropdownItem,
                                  )),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: new Text(
                                "Trash number",
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
                            color: Colors.black.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  //hintText: "Trash Number",
                                  //icon: Icon(Icons.confirmation_number),
                                  border: InputBorder.none,
                                  //border: OutlineInputBorder(),
                                  //labelText: "Email *",isDense: true
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "You must Insert Trash Number";
                                  }
                                  return null;
                                },
                                //keyboardType: TextInputType.,
                                controller: _numberController,
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

                                  //  _login();
                                  setNewTrash(_selectedCompany.name);
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text(
                                "Add New Trash Now",
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Company {
  int id;
  String name;
  Company(this.id, this.name);
  static List<Company> getCompanies() {
    return <Company>[
      Company(1, "red"),
      Company(2, "black"),
      Company(3, "white"),
      Company(4, "yellow"),
      Company(5, "grey"),
      Company(6, "blue"),
    ];
  }
}
