import 'package:expense_tracer_using_hive/pages/homepage.dart';
import 'package:expense_tracer_using_hive/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracer',
      theme: myTheme,
      home: const HomePage(),
    );
  }
}
