import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:b_smart_trash/home.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as globals;

class AddNewWorker extends StatefulWidget {
  @override
  _AddNewWorkerState createState() => _AddNewWorkerState();
}

class _AddNewWorkerState extends State<AddNewWorker> {
  final _formkey = GlobalKey<FormState>();
  File file;
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _secondNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _langController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController();
  List<Company> _compines = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenueItems;
  Company _selectedCompany;

  Future createNow(String yourLanguage) async {
    if (file != null) {
      // String base64Image = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      final _dio = new Dio();
      _dio.options.headers = {
        //'Content-Type':'application/json',
        //'Accept':'application/json',
        //'Authorization': 'Bearer $dbToken'
      };
      // _dio.options.contentType =
      //     ContentType.parse("application/x-www-form-urlencoded");
      FormData formData = new FormData.from({
        "firstname": _firstNameController.text.toString(),
        "lastname": _secondNameController.text.toString(),
        "email": _emailController.text.toString(),
        "phone": _phoneNumberController.text.toString(),
        "language": yourLanguage,
        "password": _passController.text.toString(),
        //"type": _typeController.text.toString(),
        "type": "WORKER",
        "img": new UploadFileInfo(file, fileName),
      });
      /*
      to send mutil files pass with an array
      "files": [
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt")
    ]
       */
      Response resp = await _dio.post(
          "https://smart--trash.herokuapp.com/api/v1/signup",
          data: formData);
      print("your status code is ");
      print(resp.statusCode);
      if (resp.statusCode == 201 ||
          resp.statusCode == 200 ||
          resp.statusCode == 204) {
        Toast.show("Worker Added Successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        globals.count = 0;
        globals.count2 = 0;
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print("Error");
        Toast.show("Something wrong second", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      print("error");
      Toast.show("You Must Insert Image", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _choose() async {
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    File _img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = _img;
    });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropdownMenueItems = buildDropdownMenuItems(_compines);
    _selectedCompany = _dropdownMenueItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Add Worker",
          style: TextStyle(letterSpacing: 6.0),
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
                            //Image.asset('images/trashlogo.jpg')
                            image: file == null
                                //? Image.asset('images/prof.png')
                                ? AssetImage('images/pp.jpg')
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
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(Icons.account_circle),
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text(
                            "Insert worker Photo",
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
                                    hintText: "type firstName ",
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
                                    hintText: "type secondName ",
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
                                    hintText: "type phone Number ",
                                    border: InputBorder.none,
                                    icon: Icon(Icons.phone)
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
                                keyboardType: TextInputType.number,
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
                                "Your Language",
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
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: _selectedCompany,
                                  items: _dropdownMenueItems,
                                  onChanged: onChangeDropdownItem,
                                )),
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
                                "Password",
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
                                    hintText: "type password ",
                                    border: InputBorder.none,
                                    icon: Icon(Icons.lock_outline)
                                    //border: OutlineInputBorder(),
                                    //labelText: "Email *",isDense: true
                                    ),
                                //hwa hnaby3mal check lw l email aly da5lto d mashy m3 l pattern wla laa w lw mesh mashy hayrag3 msg y2olk ano mesh mashy m3ah
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Field cannot be Empty";
                                  } else if (value.length < 6) {
                                    return "At Least 6 Digits";
                                  }
                                  return null;
                                },
                                //keyboardType: TextInputType.,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                controller: _passController,
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
                                    hintText: "type Email ",
                                    border: InputBorder.none,
                                    icon: Icon(Icons.mail_outline)
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
                                keyboardType: TextInputType.emailAddress,
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
                          createNow(_selectedCompany.name);
                        }
                      },
                      child: new Text(
                        'Create Now',
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

class Company {
  int id;
  String name;
  Company(this.id, this.name);
  static List<Company> getCompanies() {
    return <Company>[
      Company(1, "english"),
      Company(2, "عربي"),
    ];
  }
}
