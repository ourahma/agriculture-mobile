
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Places {

  Future<List<Placemark>> getLocation(Position position) async {
    debugPrint('location: ${position.latitude}');
    List<Placemark> addresses = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    var first = addresses.first;
    print("${first.name} : ${first..administrativeArea}");
    return addresses;
  }

}