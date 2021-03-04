import 'package:flutter/material.dart';

class ScriptsScreen extends StatefulWidget {
  static const routeName = '/scripts';

  @override
  _ScriptsScreenState createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  bool selectModeActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scripts"),
      ),
    );
  }
}