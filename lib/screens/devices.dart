import 'package:ble_control_app/bluetooth/scanner.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';

  @override
  _DevicesScreenState createState() {
    return _DevicesScreenState();
  }
}

class _DevicesScreenState extends State<DevicesScreen> {
  Widget _buildBluetoothStateScreen(
      BuildContext context, BleStatus bluetoothState) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.black,
            ),
            Text(
              'Bluetooth Adapter is ${bluetoothState != null ? bluetoothState.toString().substring(15) : 'not available'}.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context) {
    BLEAPI.instance.startScan(5);

    return StreamProvider(
      create: (_) => BLEAPI.instance.getScannerState(),
      initialData: const BleScannerState(
        discoveredDevices: [],
        scanIsInProgress: false,
      ),
      child: Builder(
        builder: (context) {
          var scannerState = Provider.of<BleScannerState>(context);

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async => BLEAPI.instance.startScan(5),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Column(
                        children: scannerState.discoveredDevices.map(
                              (r) => ScanResultTile(
                                result: r,
                                onTap: () async {
                                  bool connectionSuccess =
                                    await BLEAPI.instance.connect(r);
                                  if (connectionSuccess) {
                                    setState(() {});
                                  }
                                  return connectionSuccess;
                                  },
                              ),
                        ).toList()
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Builder(
                builder: (context) {
                  if (scannerState.scanIsInProgress) {
                    return FloatingActionButton(
                      child: Icon(Icons.stop),
                      onPressed: () => BLEAPI.instance.stopScan(),
                      backgroundColor: Colors.red,
                    );
                  }
                  else {
                    return FloatingActionButton(
                      child: Icon(Icons.search),
                      onPressed: () => BLEAPI.instance.startScan(5),
                    );
                  }
                }
            ),
          );
        }
      )
    );
  }

  Widget _buildDeviceName(BuildContext context) {
    DiscoveredDevice device = BLEAPI.instance.connectedDevice;

    if (device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          Text(
            device.id.toString(),
            style: TextStyle(color: Colors.grey, fontSize: 15),
          )
        ],
      );
    } else {
      return Text(
        device.id.toString(),
        style: TextStyle(color: Colors.black, fontSize: 24),
      );
    }
  }

  Future<Widget> _buildDeviceInfo(BuildContext context) async {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDeviceName(context),
            Text(
              BLEAPI.instance.connectedDevice.name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
            ),
            ElevatedButton(
                child: Text('DISCONNECT'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white))
                ),
                onPressed: () async {
                  await BLEAPI.instance.disconnect();
                  setState(() {});
                }
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    BLEAPI.instance.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Devices", style: TextStyle(fontSize: 20)),
      ),
      body: StreamBuilder(
          stream: BLEAPI.instance.getBluetoothState(),
          builder:
              (BuildContext context, AsyncSnapshot<BleStatus> snapshot) {
            if (snapshot.hasData && snapshot.data != BleStatus.ready) {
              return _buildBluetoothStateScreen(context, snapshot.data);
            } else
              return FutureBuilder(
                future: BLEAPI.instance.isConnected(),
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return FutureBuilder<Widget>(
                        future: _buildDeviceInfo(context),
                        initialData: Center(child: CircularProgressIndicator()),
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  } else {
                    return _buildDeviceList(context);
                  }
                },
              );
          }),
    );
  }
}

class ScanResultTile extends StatefulWidget {
  ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final DiscoveredDevice result;
  final Future<bool> Function() onTap;

  @override
  _ScanResultTileState createState() =>
      _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  bool connecting = false;

  Widget _buildTitle(BuildContext context) {
    if (widget.result.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.result.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(widget.result.id.toString());
    }
  }

  Widget _buildButton(BuildContext context) {
    if (connecting) {
      return CircularProgressIndicator();
    } else {
      return ElevatedButton(
        child: Text('CONNECT'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(color: Colors.white))),
        onPressed: () async {
          connecting = true;
          bool connectionSuccess = await widget.onTap();
          if (!connectionSuccess) {
            setState(() {
              connecting = false;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.result == null) {
      return Container();
    }

    return ListTile(
      title: _buildTitle(context),
      trailing: _buildButton(context),
    );
  }
}
