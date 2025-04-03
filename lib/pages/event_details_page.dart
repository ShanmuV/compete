import 'dart:convert';

import 'package:compete/extensions/extensions.dart';
import 'package:compete/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventDetailsPage({super.key, required this.event});
  @override
  Widget build(BuildContext context) {
    debugPrint(event.toString());
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SizedBox(
                    width: context.percentWidth(.3),
                    child: Hero(
                      //TODO: Fix this Hero animation
                      tag: event["_id"],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://picsum.photos/1080/1920",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  VerticalDivider(),
                  SizedBox(width: 20),
                  Expanded(
                    child: Navigator(
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder: (context) {
                            return EventDetails(event: event);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetails extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    List<String> desc = event["eventDescription"].split("\n");
    double fontSizeForDesc = 30;
    return Stack(
      children: [
        Column(
          children: [
            Text(
              event["eventName"],
              style: TextStyle(fontSize: 35, color: Colors.amberAccent),
            ),
            SizedBox(height: 15),
            ...desc.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item, style: TextStyle(fontSize: fontSizeForDesc -= 2)),
                  SizedBox(height: 10),
                ],
              );
            }),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EventRegistrationForm(event: event);
                    },
                  ),
                );
              },
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EventRegistrationForm extends StatefulWidget {
  final Map<String, dynamic> event;
  const EventRegistrationForm({super.key, required this.event});

  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _studentNameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();

  Future<void> register() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "eventID": widget.event["_id"],
        "studentName": _studentNameController.text,
        "regNo": int.parse(_regNoController.text),
        "department": _departmentController.text,
        "year": _yearController.text,
        "section": _sectionController.text,
      }),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent,
          ),
        );
      }
    } else {
      debugPrint("Error with the registration request");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.teal,
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.event["eventName"],
                    style: TextStyle(fontSize: 35, color: Colors.amberAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EventDetails(event: widget.event),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _studentNameController,
                  decoration: InputDecoration(hintText: "Student Name"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _regNoController,
                  decoration: InputDecoration(hintText: "Register No."),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  controller: _departmentController,
                  hintText: "Select Department",
                  width: double.infinity,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(label: "Computer Science", value: "CSE"),
                    DropdownMenuEntry(label: "Mechanical", value: "ME"),
                    DropdownMenuEntry(
                      label: "Electronics and Communication",
                      value: "ECE",
                    ),
                    DropdownMenuEntry(
                      label: "Information Technolgy",
                      value: "IT",
                    ),
                  ],
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  controller: _yearController,
                  hintText: "Select Year",
                  width: double.infinity,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(label: "I", value: 1),
                    DropdownMenuEntry(label: "II", value: 2),
                    DropdownMenuEntry(label: "III", value: 3),
                    DropdownMenuEntry(label: "IV", value: 4),
                  ],
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  controller: _sectionController,
                  hintText: "Select Section",
                  width: double.infinity,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(label: "A", value: "A"),
                    DropdownMenuEntry(label: "B", value: "B"),
                    DropdownMenuEntry(label: "C", value: "C"),
                    DropdownMenuEntry(label: "D", value: "D"),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: register,
                    child: Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
