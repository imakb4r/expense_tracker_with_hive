import 'package:expense_tracer_using_hive/pages/add_name.dart';
import 'package:expense_tracer_using_hive/pages/homepage.dart';
import 'package:expense_tracer_using_hive/pages/splash.dart';
import 'package:expense_tracer_using_hive/themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
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
      home: const Splash(),
    );
  }
}
