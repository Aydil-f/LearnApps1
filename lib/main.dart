import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: tdBg,
        colorScheme: const ColorScheme.dark(primary: tdBlue),
      ),
      home: const Home(),
    );
  }
}