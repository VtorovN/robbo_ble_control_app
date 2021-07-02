import 'package:ble_control_app/devices/device.dart';
import 'package:ble_control_app/devices/otto.dart';
import 'package:ble_control_app/devices/robbo_platform.dart';
import 'package:ble_control_app/model/Sets.dart';
import 'package:ble_control_app/screens/home/widgets/drawer.dart';
import 'package:ble_control_app/screens/home/widgets/end_drawer.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final List<Device> devices = <Device>[new Otto(), new RobboPlatform()];
  static Sets sets = Sets(devices);

  static final GlobalKey<_HomePageState> _homepageKey = GlobalKey<_HomePageState>();
  final AutoSizeText title;

  static GlobalKey<_HomePageState> get homepageKey => _homepageKey;

  HomePage({ this.title }) : super(key: homepageKey);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: [
          Builder(
            // Edit Button
            builder: (context) => IconButton(
                icon: Icon(Icons.edit),
                color: isEditing ? Colors.deepOrange : Colors.white,
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                }),
          ),
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    HomeGridView.globalKey
                        .currentState.clearGrid();
                  });
                }
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: HomeGridView(),
      drawer: DrawerWidget(),
      endDrawer: EndDrawerWidget(),
    );
  }
}