import 'package:compete/main.dart';
import 'package:flutter/material.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Event Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownMenu(
                    hintText: "Choose a department",
                    width: double.infinity,
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
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Organizer Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
