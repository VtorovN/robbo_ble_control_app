import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/bluetooth/scanner.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final BleScanner _scanner = BleScanner(_ble);

  runApp(
      MultiProvider(
          providers: [
            StreamProvider<BleScannerState>(
              create: (_) => _scanner.state,
              initialData: const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
            ),
          ],
          child: App()
      )
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROBBO Bluetooth Control',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 20,
          ),
          bodyText2: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      home: HomePage(
          title: AutoSizeText('Otto Control App',
              style: TextStyle(fontSize: 20), maxLines: 1)),
      routes: {
        DevicesScreen.routeName: (context) => DevicesScreen(),
        ScriptsScreen.routeName: (context) => ScriptsScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
      },
    );
  }
}
