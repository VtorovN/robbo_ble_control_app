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
        title: Text("About", style: TextStyle(fontSize: 20),),
      ),
      body: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 23
          ),
          children: [
            TextSpan(text: "Данное приложение используется для контроля робота Отто.\n\n", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: "Для подключения к роботу необходимо:\n\n"),
            TextSpan(text: "1. Включить Bluetooth на своём устройстве\n\n2. Зайти во вкладку Devices\n\n3. Выбрать из списка робота Отто и нажать Connect")
          ]
        ),
      )
    );
  }
}