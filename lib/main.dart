import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todoapps/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDoApps',
      home: Home(),
    );
  }
}