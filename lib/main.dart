import 'package:ble_control_app/devices/otto.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/devices.dart';
import 'package:ble_control_app/screens/scripts.dart';
import 'package:ble_control_app/screens/settings.dart';
import 'package:ble_control_app/screens/about.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.title,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                widget._homeActionsButtonsKey.currentState
                    .addGridElementAt(2, 2, 2, 2, "T", () {});
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                widget._homeActionsButtonsKey.currentState
                    .addGridElementAt(1, 1, 1, 3, "T", () {});
              },
            ),
          ],
        ),
        body: HomeActionButtons(widget._homeActionsButtonsKey),
        drawer: DrawerWidget());
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

class HomeActionButtons extends StatefulWidget {
  final Otto otto = new Otto();
  final GlobalKey<_HomeActionButtonsState> key;
  final int _gridSize = 36;
  final int _crossAxisCount = 4;

  HomeActionButtons(this.key) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomeActionButtonsState();
}

class _HomeActionButtonsState extends State<HomeActionButtons> with TickerProviderStateMixin {
  Ticker scrollTicker;
  ScrollController gridScrollController = ScrollController();
  List<List<_GridLayoutCellPlaceholder>> _gridCellsLayout;
  List<StaggeredTileWithDraggableData> _staggeredGridViewChildren;
  List<StaggeredTile> _staggeredTiles;

  bool hasPlace(int posX, int posY, int width, int height) {
    if (posX + width - 1 >= _gridCellsLayout.length
        || posY + height - 1 >= _gridCellsLayout[0].length) {
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

  bool hasPlaceExcludingButton(int buttonPosX, int buttonPosY,
      int buttonWidth, int buttonHeight,
      int posX, int posY) {
    if (posX + buttonWidth - 1 >= _gridCellsLayout.length
        || posY + buttonHeight - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + buttonWidth; i++) {
      for (int j = posY; j < posY + buttonHeight; j++) {
        if (!isIncluded(i, j, buttonPosX, buttonPosY,
            buttonWidth, buttonHeight)) {
          if (_gridCellsLayout[i][j].isOccupied) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool isIncluded (int posX, int posY,
      int rectPosX, int rectPosY, int rectWidth, int rectHeight) {
    if (posX < rectPosX || posY < rectPosY
        || posX > rectPosX + rectWidth - 1 || posY > rectPosY + rectHeight - 1) {
      return false;
    }

    return true;
  }

  void addGridElementAt(int posX, int posY, int width, int height,
      String text, Function onPressed) {
    if (posX < 0 || posY < 0
        || posX >= _gridCellsLayout.length
        || posY >= _gridCellsLayout[0].length) {
      throw ("Position is out of range");
    }

    if (!hasPlace(posX, posY, width, height)) {
      throw ('Tiles cannot overlap: position is occupied');
    }

    addTileAndRebuild(posX, posY, width, height, text, onPressed);
  }

  void addTileAndRebuild(int posX, int posY, int width, int height, String text,
      Function onPressed) {
    _gridCellsLayout[posX][posY] =
        _GridLayoutCellPlaceholder(true, true, text: text, onPressed: onPressed,
            width: width, height: height);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
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

  void moveTileAndRebuild(int oldPosX, int oldPosY, int posX, int posY,
      int width, int height, String text, Function onPressed) {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        _gridCellsLayout[oldPosX + i][oldPosY + j] =
            _GridLayoutCellPlaceholder(false, false);
      }
    }

    _gridCellsLayout[posX][posY] =
        _GridLayoutCellPlaceholder(true, true, text: text, onPressed: onPressed,
            width: width, height: height);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
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
      _staggeredGridViewChildren = List.filled(
          0,
          null,
          growable: true
      );
      _staggeredTiles = List.filled(
          0,
          null,
          growable: true
      );

      for (int j = 0; j < _gridCellsLayout[0].length; j++) {
        for (int i = 0; i < _gridCellsLayout.length; i++) {
          if (_gridCellsLayout[i][j].isElementCell) {
            var element = StaggeredTileWithDraggableData(i, j, true,
              width: _gridCellsLayout[i][j].width,
              height: _gridCellsLayout[i][j].height,
              text: _gridCellsLayout[i][j].text,
              onPressed: _gridCellsLayout[i][j].onPressed
            );

            _staggeredGridViewChildren.add(element);
            _staggeredTiles.add(
                StaggeredTile.count(
                    _gridCellsLayout[i][j].width,
                    _gridCellsLayout[i][j].height.toDouble()
                )
            );
          }
          else if (_gridCellsLayout[i][j].isOccupied) {
            continue;
          }
          else {
            _staggeredGridViewChildren.add(StaggeredTileWithDraggableData(i, j, false));
            _staggeredTiles.add(StaggeredTile.count(1, 1));
          }
        }
      }
    } );
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
          if ((offsetPerFrame < 0 && position.pixels <= position.minScrollExtent) ||
              (offsetPerFrame > 0 && position.pixels >= position.maxScrollExtent)) {
            scrollTicker.stop();
            scrollTicker.dispose();
            scrollTicker = null;
          } else {
            gridScrollController.jumpTo(gridScrollController.offset + offsetPerFrame);
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

    _staggeredGridViewChildren = List.filled(
        0,
        null,
        growable: true
    );
    _staggeredTiles = List.filled(
        0,
        null,
        growable: true
    );

    // Cartesian coordinate system (x, y)
    _gridCellsLayout = List.generate(widget._crossAxisCount,
        (i) => List.generate(widget._gridSize ~/ widget._crossAxisCount, (i) => null));

    for (int i = 0; i < widget._crossAxisCount; i++) {
      for (int j = 0; j < widget._gridSize ~/ widget._crossAxisCount; j++) {
        _staggeredGridViewChildren.add(StaggeredTileWithDraggableData(i, j, false));
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
                child: buildEdgeScroller(-10)
            ),
            Positioned(
                top: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(-5)
            ),
            Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(5)
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(10)
            ),
          ],
        ),
      ),
    );
  }
}

class StaggeredTileWithDraggableData extends StatelessWidget {
  final int posX;
  final int posY;
  final isDataTile;
  final int width;
  final int height;
  final String text;
  final Function onPressed;

  StaggeredTileWithDraggableData(this.posX, this.posY, this.isDataTile,
      { this.width: 1, this.height: 1, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (isDataTile) {
      if (text == null || width == null || height == null) {
        throw ('Need text, width and height to build widget');
      }

      return DraggableButton(posX, posY, width, height, text, onPressed);
    }
    else {
      return DragTarget<DraggableButton>(
        builder: (context, candidates, rejects) {
          if (candidates.isEmpty) {
            return Container();
          }
          else {
            return Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(),
                    left: BorderSide(),
                  ),
                )
            );
          }
        },
        onWillAccept: (value) {
          return value != null
              && context.findAncestorWidgetOfExactType<HomeActionButtons>().key
                  .currentState.hasPlaceExcludingButton(value.posX, value.posY,
                  value.width, value.height, posX, posY);
        },
        onAccept: (button) {
          context.findAncestorWidgetOfExactType<HomeActionButtons>().key
              .currentState.moveTileAndRebuild(button.posX, button.posY,
              posX, posY, button.width, button.height,
              button.text, button.onPressed);
        },
      );
    }
  }
}

class _GridLayoutCellPlaceholder {
  // Action action;
  final String text;
  final Function onPressed;

  // Means that this is exactly the cell where element is located
  final bool isElementCell;
  // Means that this cell is a part of an element
  final bool isOccupied;
  final int width;
  final int height;

  _GridLayoutCellPlaceholder(this.isElementCell, this.isOccupied,
      { this.text, this.onPressed, this.width: 1, this.height: 1 }) {
    if (width <= 0 || height <= 0) {
      throw ("Width and height must be more than zero");
    }
  }
}

class DraggableButton extends StatefulWidget {
  final int posX;
  final int posY;
  final int width;
  final int height;
  final String text;
  final Function onPressed;

  DraggableButton(this.posX, this.posY, this.width, this.height,
      this.text, this.onPressed);

  @override
  _DraggableButtonState createState() => new _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Listener (
        child: LongPressDraggable<DraggableButton>(
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
                  child: Center(
                    child: Text(
                      widget.text,
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  primary: Colors.green.shade300),
              child: Text(widget.text, style: TextStyle(fontSize: 35))),
        ),
      );
    });
  }
}

class CommonValues {
  static final double margin = 8.0;
  static final TextStyle drawerDefaultTextStyle = TextStyle(fontSize: 20);
  static final TextStyle drawerBlockedTextStyle = TextStyle(
      fontSize: 20,
      decoration: TextDecoration.lineThrough,
      color: Colors.black.withOpacity(0.5));
}
