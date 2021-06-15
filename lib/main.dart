import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/devices/otto.dart';
import 'package:ble_control_app/model/action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';

import 'model/utils.dart';

final Otto otto = new Otto(); // TODO: куда деть? Нужен вроде везде общий
bool isEditing = false;

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
          title: AutoSizeText(
            'Otto Control App',
            style: TextStyle(fontSize: 20),
            maxLines: 1)
      ),
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
  final AutoSizeText title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => myHomePageState;
}

final myHomePageState = _MyHomePageState();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.title,
          actions: [
            Builder( // Edit Button
              builder: (context) => IconButton(
                icon: Icon(Icons.edit),
                color: isEditing ? Colors.deepOrange : Colors.white,
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
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

          BaseActionWidget(otto.action(), () { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, otto.action());}),
          BaseActionWidget(otto.blink(), () { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, otto.blink());}),
          BaseActionWidget(otto.move(), () { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, otto.move());}),
          BaseActionWidget(otto.sound(), () { _homePage._homeActionsButtonsKey.currentState.addGridElementAt(0, otto.sound());}),
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

  void addGridElementAt(int position, BaseAction action) {
    if (position < 0 || position >= _gridSize) {
      throw ("Position is out of range");
    }

    _gridViewChildren[position].key.currentState.buildButton(action);
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
                    DraggableButton(button.action, resetButton);
              });
            },
          );
  }

  void resetButton() {
    setState(() {
      _button = null;
    });
  }

  void buildButton(BaseAction action) {
    setState(() {
      _button = DraggableButton(action, resetButton);
    });
  }
}

class DraggableButton extends StatefulWidget {
  final BaseAction _action;
  final Function _resetFunction;

  final key = GlobalKey<_DraggableButtonState>();

  DraggableButton(this._action, this._resetFunction);

  BaseAction get action => this._action;

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
                    widget.action.title,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
            onPressed: () {
              if (isEditing) {
                showModalBottomSheet(
                  context: context, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), 
                  builder: (context) => EditingModalBottomSheet(widget.action, widget.key));
              } else {
                widget.action.onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                primary: Colors.green.shade300),
            child: 
              AutoSizeText(widget.action.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 25), maxLines: 2, overflow: TextOverflow.clip,)
          ),
      );
    });
  }
}

class EditingModalBottomSheet extends StatefulWidget { //TODO: Работать с копией и сохранять на Done (copyWith())
  BaseAction _action;
  final GlobalKey<_DraggableButtonState> _draggableButtonState;
  
  EditingModalBottomSheet(this._action, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() => _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  void _updateState(Function foo) {
    setState(() {
      widget._draggableButtonState.currentState.setState(() {
        foo();  
      });
    });
  }

  Widget _sizeDropDownButton(bool axis, double dropdownValue) {
    return DropdownButton<double>(
      value: dropdownValue,
      underline: Container(
        height: 1,
      ),
      onChanged: (double newValue) {
        _updateState(() => axis? widget._action.width = newValue : widget._action.height = newValue);
      },
      items: <double>[1, 2, 3].map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text(value.toString(), style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: bottomSheetHeight,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Scrollbar(
        child: ListView(
          
          children: <Widget>[
            Container( // Title
              height: 45,
              child: ListTile(title: AutoSizeText("\"" + widget._action.title + "\" settings", style: CommonValues.bottomSheetTitleTextStyle, maxLines: 1,)),
            ),

            Container( // Change Name
              height: 100,
              padding: EdgeInsets.only(right: 15),
              child: TextFormField( 
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit, color: Colors.black38),
                  border: UnderlineInputBorder(),
                  labelText: "Edit name",
                  labelStyle: TextStyle(color: Colors.black38)
                ),
                maxLength: 20,
                initialValue: widget._action.title,
                onChanged: (text) {
                  _updateState(() { widget._action.title = text; });
                },
              ),
            ),

            Container( // Mode Switch
              height: bottomSheetHeight * 0.25,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("switch", style: CommonValues.bottomSheetSwitchTextStyle,),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                        value: widget._action.mode, 
                        onChanged: (bool value) {
                            setState(() { widget._action.mode = value; });
                        },
                    ),
                  ),
                  Text("hold", style: CommonValues.bottomSheetSwitchTextStyle,),
                ],
              ),
            ),
            
            Container( // Pin Slider
              padding: EdgeInsets.all(2),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Pin", style: CommonValues.bottomSheetTextStyle,),

                  SliderTheme(data: SliderThemeData(
                    trackShape: RectangularSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  ), 
                  child: 
                  Container (
                    width: MediaQuery.of(context).size.width * 0.83,
                    child: Slider(
                      min: 1,
                      max: 32,
                      divisions: 31,
                      label: widget._action.pin.toString(),
                      value: widget._action.pin,
                      onChanged: (value) {
                        setState(() {
                          widget._action.pin = value;
                        });
                      },
                    ),)
                  )
                ],
              ),
            ),

            
            Container( // SizeChanger
            height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("width:", style: CommonValues.bottomSheetTextStyle,),
                  _sizeDropDownButton(true, widget._action.width),
                  Text("height:", style: CommonValues.bottomSheetTextStyle,),
                  _sizeDropDownButton(false, widget._action.height)
                ],
              ),
            ),

            Container( // Done Button
              height: 80,
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 15),
              child: ElevatedButton.icon(
                icon: Icon(Icons.done, size: 20),
                label: Text('Done', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  myHomePageState.setState(() { isEditing = false; });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}