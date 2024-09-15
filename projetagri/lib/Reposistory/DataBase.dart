// ignore_for_file: avoid_init_to_null

import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static Future<Db> connect() async {
    var db = null;
   
    if (db == null) {
      db = await Db.create(
          'link');
      await db.open(); //open the connection
      inspect(db);
      var statut = db.serverStatus();

      return db;
    } else {
      return db;
    }
  }
}
