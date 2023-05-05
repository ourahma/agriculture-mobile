import 'DataBase.dart';
import 'Models/infosearchmodel.dart';

class FetchDBInfo {
  // Future<List<InfoSearchModel>> fetchinfofromDb(
  //     String season, String plant) async {
  //   List<InfoSearchModel> info = [];
  //   final plantes;
  //   try {
  //     var db = await Database.connect();
  //     var collection = db.collection('plantes');

  //     if (plant == "" || season == "All") {
  //       plantes = await collection.find({
  //         r'$and': [
  //           {
  //             'element.season': {'\$exists': true}
  //           },
  //           {
  //             'element.plant': {'\$exists': true}
  //           }
  //         ]
  //       }).toList();
  //     } else {
  //       plantes = await collection.find({
  //         r'$or': [
  //           {'element.season': season},
  //           {'element.plant': plant}
  //         ]
  //       }).toList();
  //     }

  //     info = plantes
  //         .map((json) => InfoSearchModel.fromJson(json as Map<String, dynamic>))
  //         .toList();
  //     print("info in model is $info");
  //     return info;
  //   } catch (e) {
  //     print("Error in fetching data from db : " + e.toString());
  //     return info;
  //   }
  // }

  Future<List<InfoSearchModel>> fetchinfofromDb(
      String season, String plant) async {
    List<InfoSearchModel> info = [];
    List<dynamic> plantes;
    try {
      var db = await Database.connect();
      var collection = db.collection('plantes');

      if (plant == "" || season == "All") {
        plantes = await collection.find({
          r'$and': [
            {
              'element.season': {'\$exists': true}
            },
            {
              'element.plant': {'\$exists': true}
            }
          ]
        }).toList();
      } else {
        plantes = await collection.find({
          r'$or': [
            {'element.season': season},
            {'element.plant': plant}
          ]
        }).toList();
      }

      info = plantes
          .map((json) => InfoSearchModel.fromJson(json as Map<String, dynamic>))
          .toList();
      print("info in model is $info");
      return info;
    } catch (e) {
      print("Error in fetching data from db : " + e.toString());
      return info;
    }
  }
}
