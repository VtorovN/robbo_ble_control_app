import 'package:ble_control_app/devices/otto.dart';
import 'package:ble_control_app/model/action.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';

import 'model/utils.dart';

final Otto otto = new Otto(); // TODO: куда деть? Нужен вроде везде общий

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
      home: MyHomePage(
          title: Text(
        'Otto Control App',
        style: TextStyle(fontSize: 20),
      )),
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
  final _homeActionsButtonsKey = GlobalKey<_HomeActionButtonsState>();
  final Text title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.title,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        body: HomeActionButtons(widget._homeActionsButtonsKey),
        drawer: DrawerWidget(),
        endDrawer: EndDrawerWidget(widget),
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
              child: Text('Menu',
                  style: TextStyle(fontSize: 50, color: Colors.white)),
            ),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
          ),
          ListTile(
            title: Text(
              'Devices',
              style: CommonValues.drawerDefaultTextStyle,
            ),
            leading: Icon(Icons.adb),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/devices');
            },
          ),
          ListTile(
            title: Text('About', style: CommonValues.drawerDefaultTextStyle),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            title: Text('Scripts', style: CommonValues.drawerBlockedTextStyle),
            leading: Icon(Icons.auto_fix_high),
            // onTap: () {
            //   Navigator.pop(context);
            //   Navigator.pushNamed(context, '/scripts');
            // },
          ),
          ListTile(
            title: Text('Settings', style: CommonValues.drawerBlockedTextStyle),
            leading: Icon(Icons.settings),
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

class EndDrawerWidget extends StatelessWidget {

  MyHomePage _homePage;
  EndDrawerWidget(this._homePage);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150, // TODO: constraints
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('Add action',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
            ),
          ),


          otto.action(() { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Action", () {}); }),
          otto.blink(() { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Blink", () {}); }),
          otto.move(() { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Move", () {}); }),
          otto.sound(() { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Ough", () {}); }),

          // ListTile(
          //   title: Text(
          //     'Blink',
          //     style: CommonValues.drawerDefaultTextStyle,
          //   ),
          //   leading: Icon(Icons.lightbulb),
          //   onTap: () {
          //     _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Blink", () {});
          //      Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   title: Text(
          //     'Move',
          //     style: CommonValues.drawerDefaultTextStyle,
          //   ),
          //   leading: Icon(Icons.accessibility),
          //   onTap: () {
          //     _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Move", () {});
          //      Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   title: Text(
          //     'Sound',
          //     style: CommonValues.drawerDefaultTextStyle,
          //   ),
          //   leading: Icon(Icons.audiotrack),
          //   onTap: () {
          //     _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, "Ough", () {});
          //      Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}

class HomeActionButtons extends StatefulWidget {
  final GlobalKey<_HomeActionButtonsState> key;

  HomeActionButtons(this.key) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomeActionButtonsState();
}

class _HomeActionButtonsState extends State<HomeActionButtons> {
  List<GridViewElementWithDraggableData> _gridViewChildren;
  final int _gridSize = 12;

  void addGridElementAt(int position, String text, Function onPressed) {
    if (position < 0 || position >= _gridSize) {
      throw ("Position is out of range");
    }

    _gridViewChildren[position].key.currentState.buildButton(text, onPressed);
  }

  @override
  void initState() {
    super.initState();

    _gridViewChildren = List.filled(_gridSize, null);

    for (int i = 0; i < _gridSize; i++) {
      _gridViewChildren[i] = GridViewElementWithDraggableData(
          i, GlobalKey<_GridViewElementWithDraggableDataState>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
          children: _gridViewChildren),
    );
  }
}

class GridViewElementWithDraggableData extends StatefulWidget {
  final int position;
  final GlobalKey<_GridViewElementWithDraggableDataState> key;

  GridViewElementWithDraggableData(this.position, this.key) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      new _GridViewElementWithDraggableDataState();
}

class _GridViewElementWithDraggableDataState
    extends State<GridViewElementWithDraggableData> {
  DraggableButton _button;

  @override
  Widget build(BuildContext context) {
    return _button != null
        ? _button
        : DragTarget<DraggableButton>(
            builder: (context, candidates, rejects) {
              return candidates.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    )
                  : Container();
            },
            onWillAccept: (value) {
              return value != null;
            },
            onAccept: (button) {
              setState(() {
                _button =
                    DraggableButton(button.text, button.onPressed, resetButton);
              });
            },
          );
  }

  void resetButton() {
    setState(() {
      _button = null;
    });
  }

  void buildButton(String text, Function onPressed) {
    setState(() {
      _button = DraggableButton(text, onPressed, resetButton);
    });
  }
}

class DraggableButton extends StatefulWidget {
  final String _text;
  final Function _onPressed;
  final Function _resetFunction;

  String get text => _text;
  Function get onPressed => _onPressed;

  DraggableButton(this._text, this._onPressed, this._resetFunction);

  @override
  _DraggableButtonState createState() => new _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return LongPressDraggable<DraggableButton>(
        data: widget,
        onDragCompleted: () {
          setState(() {
            widget._resetFunction();
          });
        },
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Text(
                    widget._text,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
            onPressed: widget._onPressed,
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                primary: Colors.green.shade300),
            child: Text(widget._text, style: TextStyle(fontSize: 25))),
      );
    });
  }
}
