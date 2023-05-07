import 'dart:convert';

import 'package:http/http.dart' as http;


Future<http.Response> getLocationData(String text) async {
  http.Response response;

  response= await http.get(
    /*
    * https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c
    *
    * http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$text
    * */
    Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c'),
    headers: {"Content-Type": "application/json"});

  print(jsonDecode(response.body));
  return response;

}