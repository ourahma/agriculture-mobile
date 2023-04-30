// ignore_for_file: avoid_init_to_null

import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static Future<Db> connect() async {
    var db = null;
    /*
    * mongodb+srv://maroua:1234@cluster0.fiyvmrf.mongodb.net/agricultureapp?retryWrites=true&w=majority

    mongodb+srv://groupe:eagriculture@cluster0.zicrcop.mongodb.net/test
    * */
    if (db == null) {
      db = await Db.create(
          'mongodb+srv://maroua:1234@cluster0.fiyvmrf.mongodb.net/agricultureapp?retryWrites=true&w=majority');
      await db.open(); //open the connection
      inspect(db);
      var statut = db.serverStatus();
      print('database status is $statut');
      return db;
    } else {
      return db;
    }
  }
}
