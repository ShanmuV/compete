import 'package:compete/extensions/extensions.dart';
import 'package:compete/main.dart';
import 'package:flutter/material.dart';

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
    return Stack(
      children: [
        Column(
          children: [
            Text(
              event["eventName"],
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
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
                      return EventRegistrationForm();
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
  const EventRegistrationForm({super.key});

  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(hintText: "Student Name")),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(hintText: "Register No.")),
            SizedBox(height: 10),
            DropdownMenu(
              hintText: "Select Department",
              width: double.infinity,
              dropdownMenuEntries: [
                DropdownMenuEntry(label: "Computer Science", value: "CSE"),
                DropdownMenuEntry(label: "Mechanical", value: "ME"),
                DropdownMenuEntry(
                  label: "Electronics and Communication",
                  value: "ECE",
                ),
                DropdownMenuEntry(label: "Information Technolgy", value: "IT"),
              ],
            ),
            SizedBox(height: 10),
            DropdownMenu(
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
            Center(
              child: ElevatedButton(onPressed: () {}, child: Text("Register")),
            ),
          ],
        ),
      ),
    );
  }
}
