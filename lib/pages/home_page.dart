import 'package:compete/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Event Management System", style: TextStyle(fontSize: 30)),
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset("logo.png", fit: BoxFit.cover),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [CalendarWidget(), VerticalDivider(), EventListWidget()],
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 500,
      height: 500,
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime(_focusedDay.year, _focusedDay.month - 1, 1),
        lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 1),
        onDaySelected:
            (selectedDay, focusedDay) => {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              }),
            },
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amberAccent,
          ),
          defaultTextStyle: TextStyle(color: Colors.white),
          weekendTextStyle: TextStyle(color: Colors.amberAccent[100]),
          outsideTextStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

class EventListWidget extends StatefulWidget {
  const EventListWidget({super.key});

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  List<Map<String, String>> _events = [];
  String? _eventFetchError;

  Future<void> fetchEventData() async {
    final url = Uri.parse("http://127.0.0.1:5000/events");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _events = json.decode(response.body);
      });
    } else {
      setState(() {
        _eventFetchError = response.body;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: context.percentWidth(.15),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Image.network("https://picsum.photos/1080/1920"),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _events[index]["eventName"]!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _events[index]["eventDepartment"]!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  _events[index]["eventOrganizer"]!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              _events[index]["eventDate"]!,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                          ),
                          onPressed: () {},
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
