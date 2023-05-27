//Map_Screen
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:projetagri/UI/DetailPage.dart';
import 'package:projetagri/common/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Reposistory/Geolocation/geolocationRepository.dart';
import '../bloc/Location/location_bloc.dart';



class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

const kGoogleApiKey = 'AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen> {

  final kGoogleApiKey = 'AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c';
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(31.792305849269, -7.080168000000015), zoom: 14.0);

  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;
  var locBloc;
  final Completer<GoogleMapController> _controller = Completer();
  Future<Location>? _future ;


  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  Future<Location>  loaddata() async {
    GeolocationRepository geo = GeolocationRepository() ;
    Position value  = await geo.determinePosition();
    Location location = Location(lat: value.latitude, lng: value.longitude);
    markersList.add(
        Marker(
            markerId: MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(title: "Current Position ")));
    CameraPosition cameraPosition = CameraPosition(zoom: 17, target: LatLng(value.latitude, value.longitude));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
    return location;
  }



  @override
  void initState() {
    locBloc= BlocProvider.of<LocationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      body: FutureBuilder<Location>(
        future: _future,
        builder: (context , data ) {
          if(data.hasData){
            return DetailPage();
          }else if( data.hasError){
            return Text('${data.error}');
          } else {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: markersList,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    _controller.complete(controller);
                  },
                ),
                Column(
                  children: [
                    SizedBox(height: 9,),
                    Container(
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          onPressed: (){
                            setState(() {
                              _future = _handlePressButton();
                            });
                          },
                          child: Icon(Icons.search),
                          backgroundColor: AppColor.primarygreencolor,
                        ),
                      ),
                    ),
                    SizedBox(height: 4,),
                    Container(
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          backgroundColor: AppColor.primarygreencolor,
                          onPressed: () async {
                            setState(() {
                              _future = loaddata();
                            });
                          },
                          child: Icon(Icons.local_activity),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),

    );
  }

  Future<Location> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))
        ),
        components: [Component(Component.country,"MA"),Component(Component.country,"usa")]
    );
    return displayPrediction(p!,homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<Location> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));CameraPosition cameraPosition = CameraPosition(
        zoom: 17, target: LatLng(lat, lng));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
    print(detail.result.geometry!.location);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("long", lng.toString());
    prefs.setString("lat", lat.toString());
    print('map_screen  : $lat >> $lng');
    return detail.result.geometry!.location;
  }
}




