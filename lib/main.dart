import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialize_app/pages/home.dart';

void main() async {
  runApp(MyApp());
  await Firestore.instance.settings(persistenceEnabled: false).then((_) {
    print('Timestamps enabled\n');
  }, onError: (_) {
    print('Error enabling timestamps');
  });
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
