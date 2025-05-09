import 'package:compete/extensions/extensions.dart';
import 'package:compete/main.dart';
import 'package:compete/pages/event_details_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notification.title ?? "New Notification")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
          SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalendarWidget(),
                VerticalDivider(),
                EventListWidget(),
              ],
            ),
          ),
        ],
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
  Map<DateTime, List<String>> _events = {};

  DateTime normalizeDate(DateTime? date) {
    if (date == null) return DateTime.now();
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> fetchEventData() async {
    final url = Uri.parse("http://127.0.0.1:5000/events");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        final eventJSON = json.decode(response.body);
        for (var item in eventJSON) {
          DateTime? date = normalizeDate(DateTime.parse(item["eventDate"]));
          if (_events[date] != null) {
            _events[date]!.add(item["eventName"]);
          } else {
            _events[date] = [item["eventName"]];
          }
        }
        debugPrint(_events.toString());
      });
    } else {
      debugPrint("Error occured while fecthing events");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    DateTime normalizedSelectedDay = normalizeDate(_selectedDay);
    return Container(
      margin: EdgeInsets.all(20),
      width: 500,
      height: 500,
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(_focusedDay.year, _focusedDay.month - 1, 1),
            lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 1),
            onDaySelected:
                (selectedDay, focusedDay) => {
                  setState(() {
                    _selectedDay = selectedDay;
                    normalizedSelectedDay = normalizedSelectedDay;
                  }),
                },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amberAccent,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.amberAccent[100]),
              outsideTextStyle: TextStyle(color: Colors.white70),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final normalizedDay = normalizeDate(day);
                if (_events[normalizedDay] != null &&
                    _events[normalizedDay]!.isNotEmpty) {
                  debugPrint("Day : $day");
                  return Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(150),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          if (_events[normalizedSelectedDay] != null) ...<Widget>[
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _events[normalizeDate(_selectedDay!)]!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        _events[normalizedSelectedDay]![index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
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
  List<dynamic> _events = [];
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
    return _eventFetchError == null
        ? Expanded(
          child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        debugPrint(_events[index]["_id"]);
                        return EventDetailsPage(event: _events[index]);
                      },
                    ),
                  );
                },
                child: Card(
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
                              SizedBox(
                                width: 200,
                                child: Hero(
                                  //TODO: Fix this Hero animation
                                  tag: _events[index]["_id"],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "https://picsum.photos/1080/1920",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    DateFormat('MMMM d, y').format(
                                      DateTime.parse(
                                        _events[index]["eventDate"]!,
                                      ),
                                    ),
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
                ),
              );
            },
          ),
        )
        : Text(
          "Error : $_eventFetchError",
          style: TextStyle(fontSize: 24, color: Colors.redAccent),
        );
  }
}
