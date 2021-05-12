import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';

const double margin = 8.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ROBBO Bluetooth Control',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title:  Text('Otto Control App', style: TextStyle(fontSize: 20),)),
      routes: {
        DevicesScreen.routeName: (context) => DevicesScreen(),
        ScriptsScreen.routeName: (context) => ScriptsScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final Text title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
      ),
      floatingActionButton: FloatingActionButtonsWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: HomeActionButtons(),
      drawer: DrawerWidget()
    );
  }
}

class FloatingActionButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.audiotrack, color: Colors.white,),
          ),
          FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.accessibility_new, color: Colors.white,),
          ),
          FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.wb_incandescent_outlined, color: Colors.white,),
          ),
        ],
      );
  }

}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomRight,
                child:  Text( 'Menu', style: TextStyle(fontSize: 50, color: Colors.white)),
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
            ),
            ListTile(
              title: Text('Devices', style: CommonValues.drawerDefaultTextStyle,),
              leading: Icon( Icons.adb ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/devices');
              },
            ),
            ListTile(
              title: Text('About', style: CommonValues.drawerDefaultTextStyle),
              leading: Icon( Icons.info ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: Text('Scripts', style: CommonValues.drawerBlockedTextStyle),
              leading: Icon( Icons.auto_fix_high ),
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.pushNamed(context, '/scripts');
              // },
            ),
            ListTile(
              title: Text('Settings', style: CommonValues.drawerBlockedTextStyle),
              leading: Icon( Icons.settings ),
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.pushNamed(context, '/settings');
              // },
            ),
          ],
        ),
      );
  }
}

class HomeActionButtons extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeActionButtonsState();
}

class _HomeActionButtonsState extends State<HomeActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.all(5),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
          ),
        
          children: <Widget> [
            ActiveButton("🦾"),
            ActiveButton("🦿"),
            ActiveButton("🔔"),
            ActiveButton("🟦"),
            ActiveButton("🟥"),
            ActiveButton("🟩"),
          ],
        ),
    );
  }
}

class ActiveButton extends StatefulWidget {
  String _text; 
  ActiveButton(this._text);

  @override 
  _ActiveButtonState createState() => new _ActiveButtonState();
}

class _ActiveButtonState extends State<ActiveButton> {
  // bool _isPressed = false;
  // Command _command;

  void _pressButton() {
    setState(() {
      // if (_isPressed) {
      //   _command.run();
      // }
      // _isPressed = !_isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.all(margin),
              child: ElevatedButton(
                onPressed: () { _pressButton(); },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  // side: BorderSide(width: 2.0, color: Colors.black),
                  // primary: _isPressed ? Colors.green.shade300 : Colors.blue.shade200
                  primary: Colors.green.shade300
                ),
                child: Text(widget._text, style: TextStyle(fontSize: 40))
              ),
            );
  }
}


class CommonValues {
  static TextStyle drawerDefaultTextStyle = TextStyle(fontSize: 20);
  static TextStyle drawerBlockedTextStyle = TextStyle(fontSize: 20, decoration: TextDecoration.lineThrough, color: Colors.black.withOpacity(0.5));
}