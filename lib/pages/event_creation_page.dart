import 'dart:convert';

import 'package:compete/main.dart';
import 'package:compete/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  DateTime? _selectedDate;
  DateTime? _expireDate;

  final _eventName = TextEditingController();
  final _eventDepartment = TextEditingController();
  final _eventOrganizer = TextEditingController();
  final _eventDescription = TextEditingController();

  String? _fillErr;

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickExpiryDate() async {
    final today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (pickedDate != null && pickedDate != _expireDate) {
      setState(() {
        _expireDate = pickedDate;
      });
    }
  }

  Future<void> postEvent() async {
    if (_selectedDate == null ||
        _eventName.text == "" ||
        _eventDepartment.text == "" ||
        _eventOrganizer.text == "" ||
        _eventDescription.text == "") {
      setState(() {
        _fillErr = "Fill out all the fields";
      });
      return;
    }
    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:5000/event"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "eventName": _eventName.text,
          "eventDepartment": _eventDepartment.text,
          "eventOrganizer": _eventOrganizer.text,
          "eventDescription": _eventDescription.text,
          "eventDate": _selectedDate?.toIso8601String(),
          "expiresAt": _expireDate?.toIso8601String(),
        }),
      );

      if (res.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Created Successfully",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent,
          ),
        );
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 20),
            Text("Create a New Event!", style: TextStyle(fontSize: 30)),
            SizedBox(height: 30),
            SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _eventName,
                    decoration: InputDecoration(
                      labelText: "Event Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amberAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu(
                        controller: _eventDepartment,
                        width: constraints.maxWidth,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                        ),
                        hintText: "Choose a department",
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: "CSE",
                            label: "Computer Science Engineering",
                          ),
                          DropdownMenuEntry(
                            value: "ECE",
                            label: "Electronics and Communication Engineering",
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _eventOrganizer,
                    decoration: InputDecoration(
                      labelText: "Organizer Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amberAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _eventDescription,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amberAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          _selectedDate == null
                              ? "No date selected"
                              : DateFormat("MMMM d, y").format(_selectedDate!),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _pickDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            "Choose a date for the event",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          _expireDate == null
                              ? "No date selected"
                              : DateFormat("MMMM d, y").format(_expireDate!),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _pickExpiryDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            "Choose last date for registration",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: postEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        "CREATE!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
