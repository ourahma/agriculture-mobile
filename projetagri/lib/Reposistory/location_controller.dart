import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:http/http.dart'  as http;

import 'location_service.dart';


class LocationController extends GetxController{

  Placemark _pickPlaceMark= Placemark();
  Placemark  get pickPlaceMark=>_pickPlaceMark;

  List<Prediction> _predicionList=[];  // will contain the list of the places


  Future<List<Prediction>> searchLocation( String text) async {
    if(text != null && text.isNotEmpty){
      http.Response response= await getLocationData(text);

      var data=jsonDecode(response.body.toString()); // decode the datat received from the getLocation function
      print("mu status is "+ data["status"]);
      if(data["status"] == "OK"){
        _predicionList =[];
        data["predictions"].forEach((prediction)
          => _predicionList.add(Prediction.fromJson(prediction)));
      }else{
        // ApiChecker.checkApi(response);
      }
    }
    return _predicionList;
  }
}