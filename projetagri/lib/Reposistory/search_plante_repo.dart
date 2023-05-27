

import 'DataBase.dart';

class SearchRepo {

  fetchPlante(String season) async {
    var db = await Database.connect();
    var collection = db.collection('plantes');
    try{
      //var plante = await collection.find({"season": "$season"}).toList();
      var plante = await collection.find({"element.season": "$season"}).toList();
      if(plante.isNotEmpty){
        print(plante);
        return plante ;
      }else{
        return null ;
      }

    }catch(e) {
      print('${e.toString()}');
      return null;
    }
  }


}