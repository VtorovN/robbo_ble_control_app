import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool selectModeActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
    );
  }
}