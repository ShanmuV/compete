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
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Text(
                              event["eventName"],
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
