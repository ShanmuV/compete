import 'package:compete/main.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [CustomAppBar()]));
  }
}

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Register Number"),
            VerticalDivider(),
            Text("Student Name"),
            VerticalDivider(),
            Text("Department"),
            VerticalDivider(),
            Text("Year"),
            VerticalDivider(),
            Text("Section"),
            VerticalDivider(),
          ],
        ),
      ],
    );
  }
}
