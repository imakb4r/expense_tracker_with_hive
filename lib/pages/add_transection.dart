import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:expense_tracer_using_hive/static.dart' as Static;

class AddTranssection extends StatefulWidget {
  const AddTranssection({Key? key}) : super(key: key);

  @override
  State<AddTranssection> createState() => _AddTranssectionState();
}

class _AddTranssectionState extends State<AddTranssection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //actions: [Icon(Icons.arrow_back)],
        toolbarHeight: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text(
            "Add Transection",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
