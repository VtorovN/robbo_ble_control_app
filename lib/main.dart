import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROBBO Bluetooth Control',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'BLE Device Control App'),
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

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Drawer Header',
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
            ),
            ListTile(
              title: Text('Devices'),
              leading: Icon(
                Icons.adb
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/devices');
              },
            ),
            ListTile(
              title: Text('Scripts'),
              leading: Icon(
                Icons.auto_fix_high
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/scripts');
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(
                  Icons.settings
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(
                  Icons.info
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}
