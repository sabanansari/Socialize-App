import 'package:flutter/material.dart';
import 'package:socialize_app/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
      title: 'Socialize',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
