import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SavedDevicesDatabase {
  static Database _database;

  static void init() {
    if (_database == null) {
      _openDatabase();
    }
  }

  static void _openDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), 'saved_devices.db'),
        onCreate: (db, version) {
          return db.execute('CREATE TABLE devices_table(device TEXT PRIMARY KEY)');
        },
        version: 1
    );
  }

  static Future<bool> contains(String deviceID) async {
    List<String> devices = await getSavedDevices();
    return devices.contains(deviceID);
  }

  static Future<void> addDeviceID(String deviceID) async {
    await _database.insert('devices_table', {'device': deviceID},
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  static Future<List<String>> getSavedDevices() async {
    final List<Map<String, dynamic>> table = await _database.query('devices_table');

    return List.generate(table.length, (index) {
      String deviceID = table[index]['device'].toString();
      return deviceID;
    });
  }

  static Future<void> removeDeviceID(String deviceID) async {
    final Database db = _database;

    return db.delete(
        'devices_table',
        where: 'device = ?',
        whereArgs: [deviceID]
    );
  }
}