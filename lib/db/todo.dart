import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class VazifaDb {
  Box? box;

  Future<void> openBox() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    box = await Hive.openBox("todos");
  }

  Future<void> writeToDb(String data) async {
    await openBox();
    box!.add(data);
  }

  Future<dynamic> getDbData() async {
    await openBox();
    return box!.values.toList();
  }

  Future<void> editDbData(int index, String newData) async {
    await openBox();
    box!.putAt(index, newData);
  }

  Future<void> deleteDbData(int index) async {
    await openBox();
    box!.deleteAt(index);
  }
}
