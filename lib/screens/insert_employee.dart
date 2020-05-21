import 'dart:convert';
import 'package:dummyEmployeeApi/config/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class InsertEmployee extends StatefulWidget {
  @override
  _InsertEmployeeState createState() => _InsertEmployeeState();
}

class _InsertEmployeeState extends State<InsertEmployee> {
  Logger log = getLogger("EmployeeList");

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  TextEditingController nameController = TextEditingController();

   
  TextEditingController iDController = TextEditingController();

  TextEditingController salaryController = TextEditingController();

  TextEditingController ageController = TextEditingController();



  Future _insertEmployee() async {
    var url = 'http://dummy.restapiexample.com/api/v1/create';

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name": nameController,
        "salary": salaryController,
        "age": ageController,
        "ID": iDController,
      }),
    );

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);

      log.i(parsedData['status']);
    }
  }

  @override
  void initState() {
    _insertEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      backgroundColor: Colors.blue[200],
      appBar: AppBar(title: Text('Ganerat Post Page')),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(children: <Widget>[
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
            SizedBox(height: 300),
            Container(
              color: Colors.blue,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      'Ganerater',
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
                       _insertEmployee();
                       Navigator.pop(context); 
                       _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "Post Ganerated"),
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
      )),
    );
  }
}

