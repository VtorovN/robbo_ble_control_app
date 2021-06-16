import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/devices/otto.dart';
import 'package:ble_control_app/model/action.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'model/utils.dart';

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
  static final GlobalKey<_MyHomePageState> _homepageKey = GlobalKey<_MyHomePageState>();
  static final Otto otto = new Otto();
  final AutoSizeText title;

  static GlobalKey<_MyHomePageState> get homepageKey => _homepageKey;

  MyHomePage({ this.title }) : super(key: homepageKey);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  HomeActionButtons.globalKey
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
      body: HomeActionButtons(),
      drawer: DrawerWidget(),
      endDrawer: EndDrawerWidget(),
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
  EndDrawerWidget();

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
          BaseActionWidget(MyHomePage.otto.action(), () {
            HomeActionButtons.globalKey.currentState
                .addGridElement(
                  Tile(
                      TileSize(1, 1),
                      TilePosition(0, 0),
                      MyHomePage.otto.action()
                  )
            );
          }),
          BaseActionWidget(MyHomePage.otto.blink(), () {
            HomeActionButtons.globalKey.currentState
                .addGridElement(
                Tile(
                    TileSize(1, 1),
                    TilePosition(0, 0),
                    MyHomePage.otto.blink()
                )
            );
          }),
          BaseActionWidget(MyHomePage.otto.move(), () {
            HomeActionButtons.globalKey.currentState
                .addGridElement(
                Tile(
                    TileSize(1, 1),
                    TilePosition(0, 0),
                    MyHomePage.otto.move()
                )
            );
          }),
          BaseActionWidget(MyHomePage.otto.sound(), () {
            HomeActionButtons.globalKey.currentState
                .addGridElement(
                Tile(
                    TileSize(1, 1),
                    TilePosition(0, 0),
                    MyHomePage.otto.sound()
                )
            );
          }),
        ],
      ),
    );
  }
}

class HomeActionButtons extends StatefulWidget {
  static final GlobalKey<_HomeActionButtonsState> _homeActionButtonsKey = GlobalKey<_HomeActionButtonsState>();
  final int _gridSize = 36;
  final int _crossAxisCount = 4;

  static GlobalKey<_HomeActionButtonsState> get globalKey => _homeActionButtonsKey;

  HomeActionButtons() : super(key: _homeActionButtonsKey);

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

  bool hasPlaceExcludingOldButton(int buttonPosX, int buttonPosY,
      int buttonWidth, int buttonHeight,
      int oldButtonWidth, int oldButtonHeight,
      int posX, int posY) {
    if (posX + buttonWidth - 1 >= _gridCellsLayout.length ||
        posY + buttonHeight - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + buttonWidth; i++) {
      for (int j = posY; j < posY + buttonHeight; j++) {
        if (!isIncluded(
            i, j, buttonPosX, buttonPosY, oldButtonWidth, oldButtonHeight)) {
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

  void clearGrid() {
    _staggeredGridViewChildren = List.filled(0, null, growable: true);
    _staggeredTiles = List.filled(0, null, growable: true);

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

  void addGridElement(Tile tile) {
    if (tile.position.x < 0 ||
        tile.position.y < 0 ||
        tile.position.x >= _gridCellsLayout.length ||
        tile.position.y >= _gridCellsLayout[0].length) {
      throw ("Button position is out of range of grid");
    }

    if (!hasPlace(tile.position.x, tile.position.y,
        tile.size.width, tile.size.height)) {
      throw ('Tiles cannot overlap: position is occupied');
    }

    addTileAndRebuild(tile);
  }

  void _addTile(Tile tile) {
    _gridCellsLayout[tile.position.x][tile.position.y] =
        _GridLayoutCellPlaceholder(true, true, tile: tile);
    for (int i = 0; i < tile.size.width; i++) {
      for (int j = 0; j < tile.size.height; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        _gridCellsLayout[tile.position.x + i][tile.position.y + j] =
            _GridLayoutCellPlaceholder(false, true);
      }
    }
  }

  void addTileAndRebuild(Tile tile) {
    _addTile(tile);
    buildGrid();
  }

  void _removeTile(Tile tile) {
    for (int i = 0; i < tile.size.width; i++) {
      for (int j = 0; j < tile.size.height; j++) {
        _gridCellsLayout[tile.position.x + i][tile.position.y + j] =
            _GridLayoutCellPlaceholder(false, false);
      }
    }
  }

  void removeTileAndRebuild(Tile tile) {
    _removeTile(tile);
    buildGrid();
  }

  void _moveTile(Tile tile, int newX, int newY) {
    _removeTile(tile);
    tile.position = TilePosition(newX, newY);
    _addTile(tile);
  }

  void moveTileAndRebuild(Tile tile, int newX, int newY) {
    _moveTile(tile, newX, newY);
    buildGrid();
  }

  void _resizeTile(Tile tile, int newWidth, int newHeight) {
    _removeTile(tile);
    tile.size = TileSize(newWidth, newHeight);
    _addTile(tile);
  }

  void resizeTileAndRebuild(Tile tile, int newWidth, int newHeight) {
    _resizeTile(tile, newWidth, newHeight);
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
              tile: _gridCellsLayout[i][j].tile,
            );

            _staggeredGridViewChildren.add(element);
            _staggeredTiles.add(StaggeredTile.count(
                _gridCellsLayout[i][j].tile.size.width,
                _gridCellsLayout[i][j].tile.size.height.toDouble()));
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
    clearGrid();
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
  final Tile tile;

  StaggeredTileWithDraggableData(this.posX, this.posY, this.isDataTile,
      {this.tile});

  @override
  Widget build(BuildContext context) {
    if (isDataTile) {
      if (this.tile == null) {
        throw ('Need tile to build widget');
      }

      return DraggableButton(posX, posY, tile);
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
              HomeActionButtons.globalKey
                  .currentState
                  .hasPlaceExcludingButton(value.posX, value.posY,
                      value.tile.size.width,
                      value.tile.size.height,
                      posX, posY);
        },
        onAccept: (button) {
          HomeActionButtons.globalKey
              .currentState
              .moveTileAndRebuild(button.tile, posX, posY);
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

  final Tile tile;

  _GridLayoutCellPlaceholder(this.isElementCell, this.isOccupied,
      {this.tile});
}

class DraggableButton extends StatefulWidget {
  final Tile _tile;
  final int posX;
  final int posY;
  final key = GlobalKey<_DraggableButtonState>();

  Tile get tile => this._tile;

  DraggableButton(this.posX, this.posY, this._tile);

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
                      widget.tile.action.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
            onPressed: () {
              if (MyHomePage.homepageKey.currentState.isEditing) {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    builder: (context) =>
                        EditingModalBottomSheet(widget.tile, widget.key));
              } else {
                widget.tile.action.onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                primary: Colors.green.shade300),
            child: AutoSizeText(
              widget.tile.action.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
              maxLines: 2,
              overflow: TextOverflow.clip,
            )),
      );
    });
  }
}

class EditingModalBottomSheet extends StatefulWidget {
  //TODO: Работать с копией и сохранять на Done (copyWith())
  final Tile _tile;
  final GlobalKey<_DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._tile, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _updateState(Function updatingFunction) {
    setState(() {
      widget._draggableButtonState.currentState.setState(() {
        updatingFunction();
      });
    });
  }

  Widget _sizeDropDownButton(bool axis, int dropdownValue) {
    return DropdownButton<int>(
      value: dropdownValue,
      underline: Container(
        height: 1,
      ),
      onChanged: (int newValue) {
        bool hasPlace = HomeActionButtons
            .globalKey
            .currentState
            .hasPlaceExcludingOldButton(
            widget._tile.position.x,
            widget._tile.position.y,
            axis
                ? newValue
                : widget._tile.size.width,
            axis
                ? widget._tile.size.height
                : newValue,
            widget._tile.size.width,
            widget._tile.size.height,
            widget._tile.position.x,
            widget._tile.position.y);
        if (hasPlace) {
          _updateState(() {
            HomeActionButtons.globalKey.currentState.resizeTileAndRebuild(
                widget._tile,
                axis
                    ? newValue
                    : widget._tile.size.width,
                axis
                    ? widget._tile.size.height
                    : newValue,
            );
          });
        }
        else {
          final scaffoldMessenger = ScaffoldMessenger
              .of(_scaffoldKey.currentContext);
          scaffoldMessenger.showSnackBar(
            SnackBar(
                content: Text ('Cannot resize button: not enough space'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
            ),
          );
        }
      },
      items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
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
    return Scaffold(
      key: _scaffoldKey,
      body:Container(
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
                        "\"" + widget._tile.action.title + "\" settings",
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
                    initialValue: widget._tile.action.title,
                    onChanged: (text) {
                      _updateState(() {
                        widget._tile.action.title = text;
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
                          value: widget._tile.action.mode,
                          onChanged: (bool value) {
                            setState(() {
                              widget._tile.action.mode = value;
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
                              label: widget._tile.action.pin.toInt().toString(),
                              value: widget._tile.action.pin,
                              onChanged: (value) {
                                setState(() {
                                  widget._tile.action.pin = value;
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
                      _sizeDropDownButton(true, widget._tile.size.width),
                      Text(
                        "height:",
                        style: CommonValues.bottomSheetTextStyle,
                      ),
                      _sizeDropDownButton(false, widget._tile.size.height)
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
                      HomeActionButtons.globalKey.currentState.setState(() {
                        MyHomePage.homepageKey.currentState.isEditing = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ))
    );
  }
}
