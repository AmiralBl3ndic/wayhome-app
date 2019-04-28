import 'package:flutter/material.dart';

import 'pages/pages_manager.dart';


void main() => runApp(WayHomeApp());

class WayHomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wayHome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PagesManager(title: 'wayHome'),
    );
  }
}
