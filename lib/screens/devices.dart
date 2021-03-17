import 'package:flutter/material.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {

  Widget _buildDeviceList(BuildContext context) {
    BLEAPI.instance.startScan();

    return Scaffold(
      appBar: AppBar(
        title: Text("Devices"),
      ),
      body: RefreshIndicator(
        onRefresh: () => BLEAPI.instance.startScan(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: BLEAPI.instance.getScanResults(),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () async {
                        bool connectionSuccess = await BLEAPI.instance.connect(r.device);
                        if (connectionSuccess) {
                          Navigator.pop(context);
                        }
                        return connectionSuccess;
                      },
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: BLEAPI.instance.isScanningStream(),
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => BLEAPI.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => BLEAPI.instance.startScan(),
            );
          }
        },
      ),
    );
  }

  Widget _buildDeviceName(BuildContext context) {
    BluetoothDevice device = BLEAPI.instance.connectedDevice;

    if (device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24
            ),
          ),
          Text(
            device.id.toString(),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15
            ),
          )
        ],
      );
    } else {
      return Text(
        device.id.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 24
        ),
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
              (await BLEAPI.instance.connectedDevice.state.first).toString(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
            ),
            RaisedButton(
                child: Text('DISCONNECT'),
                color: Colors.red,
                textColor: Colors.white,
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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BLEAPI.instance.isConnected(),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return FutureBuilder<Widget> (
              future: _buildDeviceInfo(context),
              initialData: CircularProgressIndicator(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return CircularProgressIndicator();
                }
              }
          );
        } else {
          return _buildDeviceList(context);
        }
      },
    );
  }
}

class ScanResultTile extends StatefulWidget {
  ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final Future<bool> Function() onTap;

  @override
  _ScanResultTileState createState() => _ScanResultTileState(result: result, onTap: onTap);
}

class _ScanResultTileState extends State<ScanResultTile> {
  _ScanResultTileState({this.result, this.onTap});

  final ScanResult result;
  final Future<bool> Function() onTap;

  bool connecting = false;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildButton(BuildContext context) {
    if (connecting) {
      return CircularProgressIndicator();
    } else {
      return RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: () async {
          connecting = true;
          bool connectionSuccess = await onTap();
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
    if (result == null || !result.advertisementData.connectable) {
      return Container();
    }

    return ListTile(
      title: _buildTitle(context),
      trailing: _buildButton(context),
    );
  }
}