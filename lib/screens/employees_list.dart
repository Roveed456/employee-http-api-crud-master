import 'dart:convert';

import 'package:dummyEmployeeApi/config/logger.dart';
import 'package:dummyEmployeeApi/models/employee.dart';
import 'package:dummyEmployeeApi/screens/insert_employee.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  Logger log = getLogger("EmployeeList");

   TextEditingController nameController = TextEditingController();

   
  TextEditingController iDController = TextEditingController();

  TextEditingController salaryController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  Future<List> _getEmployeeList() async {
    final response =
        await http.get("http://dummy.restapiexample.com/api/v1/employees");

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      log.e(parsed.runtimeType);
      log.i(parsed['data']);

      List employees =
          parsed['data'].map((emp) => Employee.fromJson(emp)).toList();

      return employees;
    }
  }

  Future _deleteEmployee(String id) async {
    setState(() {
      isLoading = true;
    });

    final response =
        await http.delete('http://dummy.restapiexample.com/api/v1/delete/$id');

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(parsedData['message']),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future _uodateEmployee(String id) async {
    setState(() {
      isLoading = true;
    });

    final response =
        await http.put('http://dummy.restapiexample.com/api/v1/update/$id');

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(parsedData['message']),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text("Employees List"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InsertEmployee()));
              })
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: FutureBuilder(
                        future: _getEmployeeList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text(
                                              "${snapshot.data[index].employeeName}",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                                'Age: ${snapshot.data[index].employeeAge} Salary: ${snapshot.data[index].employeeSalary}'),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              showBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height:  MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height *0.70,
                                                        child: Center(
                                                          child:  Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Upgrade Post',style: TextStyle(
                  fontSize: 20.0
                ),),
                IconButton(icon: Icon(Icons.close,color: Colors.blue,), onPressed: (){ Navigator.pop(context);})
              ],
            ),
            SizedBox(height: 50.0,),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: salaryController ,
              decoration: InputDecoration(labelText: 'Salary'),
            ),
            TextField(
              controller: ageController ,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: iDController ,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            SizedBox(height: 20.0,),
            Container(
              color: Colors.blue,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      'Ungrade Post',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.blue,
                    onPressed: (){
                      log.i(nameController.text);
                       log.i(salaryController.text);
                       log.i(ageController.text);
                       log.i(iDController.text);
                       _uodateEmployee('${snapshot.data[index].id}');
                       Navigator.pop(context); 
                       _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "Upgrade Post Gaberated "),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                        ),
                                                            );
                    },
                  ))
                ],
              ),
            )
          ]),
        ),
                                                        ),
                                                      ));
                                            }),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            //_showSnackBar(context, "Are you Sure to Delete ??");

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Are you Sure to Delet"),
                                                    content: Text(
                                                        "this Department Entry will be delted"),
                                                    actions: <Widget>[
                                                      RaisedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');

                                                            _deleteEmployee(
                                                                '${snapshot.data[index].id}');
                                                          },
                                                          child:
                                                              Text("Confirm")),
                                                      RaisedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');

                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "You Have cancelled!"),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                    ],
                                                  );
                                                });
                                          },
                                          color: Color(0xff800000),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: "Confirm", onPressed: () {}),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showAlertDialogue(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
