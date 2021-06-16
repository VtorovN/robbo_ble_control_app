import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/devices/otto.dart';
import 'package:ble_control_app/model/action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  final MyHomePage _homePage;

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
          BaseActionWidget(otto.action(), () {
            _homePage._homeActionsButtonsKey.currentState
                .addGridElementAt(0, 0, otto.action());
          }),
          BaseActionWidget(otto.blink(), () {
            _homePage._homeActionsButtonsKey.currentState
                .addGridElementAt(0, 0, otto.blink());
          }),
          BaseActionWidget(otto.move(), () {
            _homePage._homeActionsButtonsKey.currentState
                .addGridElementAt(0, 0, otto.move());
          }),
          BaseActionWidget(otto.sound(), () {
            _homePage._homeActionsButtonsKey.currentState
                .addGridElementAt(0, 0, otto.sound());
          }),
        ],
      ),
    );
  }
}

class HomeActionButtons extends StatefulWidget {
  final GlobalKey<_HomeActionButtonsState> key;
  final int _gridSize = 36;
  final int _crossAxisCount = 4;

  HomeActionButtons(this.key) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomeActionButtonsState();
}

class _HomeActionButtonsState extends State<HomeActionButtons>
    with TickerProviderStateMixin {
  Ticker scrollTicker;
  ScrollController gridScrollController = ScrollController();
  List<List<_GridLayoutCellPlaceholder>> _gridCellsLayout;
  List<StaggeredTileWithDraggableData> _staggeredGridViewChildren;
  List<StaggeredTile> _staggeredTiles;

  bool hasPlace(int posX, int posY, int width, int height) {
    if (posX + width - 1 >= _gridCellsLayout.length ||
        posY + height - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + width; i++) {
      for (int j = posY; j < posY + height; j++) {
        if (_gridCellsLayout[i][j].isOccupied) {
          return false;
        }
      }
    }

    return true;
  }

  bool hasPlaceExcludingButton(int buttonPosX, int buttonPosY, int buttonWidth,
      int buttonHeight, int posX, int posY) {
    if (posX + buttonWidth - 1 >= _gridCellsLayout.length ||
        posY + buttonHeight - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + buttonWidth; i++) {
      for (int j = posY; j < posY + buttonHeight; j++) {
        if (!isIncluded(
            i, j, buttonPosX, buttonPosY, buttonWidth, buttonHeight)) {
          if (_gridCellsLayout[i][j].isOccupied) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool isIncluded(int posX, int posY, int rectPosX, int rectPosY, int rectWidth,
      int rectHeight) {
    if (posX < rectPosX ||
        posY < rectPosY ||
        posX > rectPosX + rectWidth - 1 ||
        posY > rectPosY + rectHeight - 1) {
      return false;
    }

    return true;
  }

  void addGridElementAt(int posX, int posY, BaseAction action) {
    if (posX < 0 ||
        posY < 0 ||
        posX >= _gridCellsLayout.length ||
        posY >= _gridCellsLayout[0].length) {
      throw ("Position is out of range");
    }

    if (!hasPlace(posX, posY, action.width, action.height)) {
      throw ('Tiles cannot overlap: position is occupied');
    }

    addTileAndRebuild(posX, posY, action);
  }

  void addTileAndRebuild(int posX, int posY, BaseAction action) {
    _gridCellsLayout[posX][posY] =
        _GridLayoutCellPlaceholder(true, true, action: action);
    for (int i = 0; i < action.width; i++) {
      for (int j = 0; j < action.height; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        _gridCellsLayout[posX + i][posY + j] =
            _GridLayoutCellPlaceholder(false, true);
      }
    }

    buildGrid();
  }

  void removeTileAndRebuild(int posX, int posY, int width, int height,
      String text, Function onPressed) {
    _gridCellsLayout[posX][posY] = _GridLayoutCellPlaceholder(false, false);
    for (int i = 1; i < width; i++) {
      for (int j = 1; j < height; j++) {
        _gridCellsLayout[posX + i][posY + j] =
            _GridLayoutCellPlaceholder(false, false);
      }
    }

    buildGrid();
  }

  void moveTileAndRebuild(
      int oldPosX, int oldPosY, int posX, int posY, BaseAction action) {
    for (int i = 0; i < action.width; i++) {
      for (int j = 0; j < action.height; j++) {
        _gridCellsLayout[oldPosX + i][oldPosY + j] =
            _GridLayoutCellPlaceholder(false, false);
      }
    }

    _gridCellsLayout[posX][posY] =
        _GridLayoutCellPlaceholder(true, true, action: action);
    for (int i = 0; i < action.width; i++) {
      for (int j = 0; j < action.height; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        _gridCellsLayout[posX + i][posY + j] =
            _GridLayoutCellPlaceholder(false, true);
      }
    }

    buildGrid();
  }

  void buildGrid() {
    setState(() {
      _staggeredGridViewChildren = List.filled(0, null, growable: true);
      _staggeredTiles = List.filled(0, null, growable: true);

      for (int j = 0; j < _gridCellsLayout[0].length; j++) {
        for (int i = 0; i < _gridCellsLayout.length; i++) {
          if (_gridCellsLayout[i][j].isElementCell) {
            var element = StaggeredTileWithDraggableData(
              i,
              j,
              true,
              action: _gridCellsLayout[i][j].action,
            );

            _staggeredGridViewChildren.add(element);
            _staggeredTiles.add(StaggeredTile.count(
                _gridCellsLayout[i][j].action.width,
                _gridCellsLayout[i][j].action.height.toDouble()));
          } else if (_gridCellsLayout[i][j].isOccupied) {
            continue;
          } else {
            _staggeredGridViewChildren
                .add(StaggeredTileWithDraggableData(i, j, false));
            _staggeredTiles.add(StaggeredTile.count(1, 1));
          }
        }
      }
    });
  }

  Widget buildEdgeScroller(double offsetPerFrame) {
    return DragTarget<DraggableButton>(
      builder: (context, candidateData, rejectedData) => Container(),
      onWillAccept: (data) {
        scrollTicker = this.createTicker((elapsed) {
          if (!gridScrollController.hasClients) {
            return;
          }
          final position = gridScrollController.position;
          if ((offsetPerFrame < 0 &&
                  position.pixels <= position.minScrollExtent) ||
              (offsetPerFrame > 0 &&
                  position.pixels >= position.maxScrollExtent)) {
            scrollTicker.stop();
            scrollTicker.dispose();
            scrollTicker = null;
          } else {
            gridScrollController
                .jumpTo(gridScrollController.offset + offsetPerFrame);
          }
        });
        scrollTicker.start();
        return false;
      },
      onLeave: (data) {
        scrollTicker?.stop();
        scrollTicker?.dispose();
        scrollTicker = null;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _staggeredGridViewChildren = List.filled(0, null, growable: true);
    _staggeredTiles = List.filled(0, null, growable: true);

    // Cartesian coordinate system (x, y)
    _gridCellsLayout = List.generate(
        widget._crossAxisCount,
        (i) => List.generate(
            widget._gridSize ~/ widget._crossAxisCount, (i) => null));

    for (int i = 0; i < widget._crossAxisCount; i++) {
      for (int j = 0; j < widget._gridSize ~/ widget._crossAxisCount; j++) {
        _staggeredGridViewChildren
            .add(StaggeredTileWithDraggableData(i, j, false));
        _staggeredTiles.add(StaggeredTile.count(1, 1));
        _gridCellsLayout[i][j] = _GridLayoutCellPlaceholder(false, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: [
            StaggeredGridView.count(
              crossAxisCount: widget._crossAxisCount,
              controller: gridScrollController,
              staggeredTiles: _staggeredTiles,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: _staggeredGridViewChildren,
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(-10)),
            Positioned(
                top: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(-5)),
            Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(5)),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(10)),
          ],
        ),
      ),
    );
  }
}

class StaggeredTileWithDraggableData extends StatelessWidget {
  final isDataTile;
  final int posX;
  final int posY;
  final BaseAction action;

  StaggeredTileWithDraggableData(this.posX, this.posY, this.isDataTile,
      {this.action});

  @override
  Widget build(BuildContext context) {
    if (isDataTile) {
      if (this.action == null) {
        throw ('Need action to build widget');
      }

      return DraggableButton(posX, posY, action);
    } else {
      return DragTarget<DraggableButton>(
        builder: (context, candidates, rejects) {
          if (candidates.isEmpty) {
            return Container();
          } else {
            return Container(
                decoration: BoxDecoration(
              border: Border(
                top: BorderSide(),
                left: BorderSide(),
              ),
            ));
          }
        },
        onWillAccept: (value) {
          return value != null &&
              context
                  .findAncestorWidgetOfExactType<HomeActionButtons>()
                  .key
                  .currentState
                  .hasPlaceExcludingButton(value.posX, value.posY,
                      value.action.width, value.action.height, posX, posY);
        },
        onAccept: (button) {
          context
              .findAncestorWidgetOfExactType<HomeActionButtons>()
              .key
              .currentState
              .moveTileAndRebuild(
                  button.posX, button.posY, posX, posY, button.action);
        },
      );
    }
  }
}

class _GridLayoutCellPlaceholder {
  // Means that this is exactly the cell where element is located
  final bool isElementCell;
  // Means that this cell is a part of an element
  final bool isOccupied;

  final BaseAction action;

  _GridLayoutCellPlaceholder(this.isElementCell, this.isOccupied,
      {this.action});
}

class DraggableButton extends StatefulWidget {
  final BaseAction _action;
  final int posX;
  final int posY;
  final key = GlobalKey<_DraggableButtonState>();

  BaseAction get action => this._action;

  DraggableButton(this.posX, this.posY, this._action);

  @override
  _DraggableButtonState createState() => new _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return LongPressDraggable<DraggableButton>(
        data: widget,
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
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: AutoSizeText(
                      widget.action.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
            onPressed: () {
              if (isEditing) {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    builder: (context) =>
                        EditingModalBottomSheet(widget.action, widget.key));
              } else {
                widget.action.onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                primary: Colors.green.shade300),
            child: AutoSizeText(
              widget.action.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
              maxLines: 2,
              overflow: TextOverflow.clip,
            )),
      );
    });
  }
}

class EditingModalBottomSheet extends StatefulWidget {
  //TODO: Работать с копией и сохранять на Done (copyWith())
  final BaseAction _action;
  final GlobalKey<_DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._action, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
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
        _updateState(() => axis
            ? widget._action.width = newValue
            : widget._action.height = newValue);
      },
      items: <double>[1, 2, 3].map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 18),
          ),
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
              Container(
                // Title
                height: 45,
                child: ListTile(
                    title: AutoSizeText(
                  "\"" + widget._action.title + "\" settings",
                  style: CommonValues.bottomSheetTitleTextStyle,
                  maxLines: 1,
                )),
              ),
              Container(
                // Change Name
                height: 100,
                padding: EdgeInsets.only(right: 15),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit, color: Colors.black38),
                      border: UnderlineInputBorder(),
                      labelText: "Edit name",
                      labelStyle: TextStyle(color: Colors.black38)),
                  maxLength: 20,
                  initialValue: widget._action.title,
                  onChanged: (text) {
                    _updateState(() {
                      widget._action.title = text;
                    });
                  },
                ),
              ),
              Container(
                // Mode Switch
                height: bottomSheetHeight * 0.25,
                padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "switch",
                      style: CommonValues.bottomSheetSwitchTextStyle,
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        value: widget._action.mode,
                        onChanged: (bool value) {
                          setState(() {
                            widget._action.mode = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      "hold",
                      style: CommonValues.bottomSheetSwitchTextStyle,
                    ),
                  ],
                ),
              ),
              Container(
                // Pin Slider
                padding: EdgeInsets.all(2),
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Pin",
                      style: CommonValues.bottomSheetTextStyle,
                    ),
                    SliderTheme(
                        data: SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                        ),
                        child: Container(
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
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                // SizeChanger
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "width:",
                      style: CommonValues.bottomSheetTextStyle,
                    ),
                    _sizeDropDownButton(true, widget._action.width),
                    Text(
                      "height:",
                      style: CommonValues.bottomSheetTextStyle,
                    ),
                    _sizeDropDownButton(false, widget._action.height)
                  ],
                ),
              ),
              Container(
                // Done Button
                height: 80,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(right: 15),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.done, size: 20),
                  label: Text('Done',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    myHomePageState.setState(() {
                      isEditing = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
