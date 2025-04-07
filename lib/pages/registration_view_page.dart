import 'dart:convert';
import 'package:compete/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationViewPage extends StatefulWidget {
  final Map<String, dynamic> event;
  const RegistrationViewPage({super.key, required this.event});

  @override
  State<RegistrationViewPage> createState() => _RegistrationViewPageState();
}

class _RegistrationViewPageState extends State<RegistrationViewPage> {
  List<dynamic>? _students;
  String? _errMessage;

  Future<void> fetchStudentData() async {
    final res = await http.get(
      Uri.parse("http://127.0.0.1:5000/student-list/${widget.event["_id"]}"),
    );
    if (res.statusCode == 200) {
      setState(() {
        _students = jsonDecode(res.body);
      });
    } else {
      setState(() {
        _errMessage =
            "Error occured when fetching student details. Code ${res.statusCode}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _errMessage == null
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Registrations for ${widget.event["eventName"]}",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          left: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Register Number",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Student Name",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Department",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Year",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Section",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 15),
                  _students != null
                      ? Expanded(
                        child: ListView.builder(
                          itemCount: _students!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _students![index]["regNo"].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _students![index]["studentName"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _students![index]["department"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _students![index]["year"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _students![index]["section"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                      : CircularProgressIndicator(),
                ],
              )
              : Text("Error: $_errMessage"),
    );
  }
}
