import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Reposistory/location_controller.dart';
import '../Reposistory/location_search_dialog.dart';
import '../common/color.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _KgooglePlex;
  late GoogleMapController _mapController;

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId("ID MAEKER"),
        position: LatLng(33.445, 73.442),
        infoWindow: InfoWindow(title: "The title of the position "))
  ];

  loaddata() {
    getCurrentLocation().then((value) async {
      print("User location " +
          value.longitude.toString() +
          value.altitude.toString());
      _markers.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: "Current Position ")));
      CameraPosition cameraPosition = CameraPosition(
          zoom: 17, target: LatLng(value.latitude, value.longitude));
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }
  

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _KgooglePlex =
        CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    GetStorage userdata = GetStorage();
    String? adresse = userdata.read("address");
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Scaffold(
          body: ListView(
            children: [
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController mapController) {
                        _mapController = mapController;
                        _controller.complete(mapController);
                      },
                      initialCameraPosition: _KgooglePlex,
                      markers: Set<Marker>.of(_markers),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 10,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          Get.dialog(LocationSearchDialog(
                              mapController: _mapController));
                          setState(() {
                            adresse;
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              // visualiser l'adreese en haut
                              Expanded(
                                child: Text(
                                  adresse ??
                                      'Press on the green button to get your address',
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.search,
                                  size: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color)
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                    top: height / 2.5,
                    left: 5,
                    right: width - 50,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: FloatingActionButton(
                        backgroundColor: AppColor.primarygreencolor,
                        onPressed: () async {
                          loaddata();
                        },
                        child: Icon(Icons.local_activity),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  width: width,
                  height: 100,
                  decoration: BoxDecoration(
                      color: AppColor.primarygreencolor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Text("Your address : ",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adresse ??
                            'Press on the green button to get your address',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}
