import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projetagri/bloc/Location/location_bloc.dart';

import '../Reposistory/location_controller.dart';
import '../Reposistory/location_search_dialog.dart';
import '../common/color.dart';
import 'DetailPage.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller=Completer();
  late CameraPosition _KgooglePlex;
  late GoogleMapController _mapController;
  var locBloc;


  final List<Marker> _markers= <Marker>[
    Marker(
        markerId: MarkerId("ID MAEKER"),
        position: LatLng(33.445,73.442),
        infoWindow: InfoWindow(title: "The title of the position ")
    )
  ];

  loaddata(){
    getCurrentLocation().then((value) async {
      print('******************$value');
      print("User location "+value.longitude.toString()+ value.altitude.toString() );
      _markers.add(
          Marker(
              markerId: MarkerId("2"),
              position: LatLng(value.latitude,value.longitude),
              infoWindow: InfoWindow(title: "Current Position ")
          )
      );
      CameraPosition cameraPosition=CameraPosition(zoom:17,target: LatLng(value.latitude,value.longitude));
      final GoogleMapController controller=await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //setState(() {});
    });
  }
  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    locBloc= BlocProvider.of<LocationBloc>(context);
    super.initState();
    _KgooglePlex=CameraPosition(target: LatLng(
        45.521563,-122.677433),zoom: 17);
    loaddata();
  }


  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    GetStorage userdata=GetStorage();
    String adresse =userdata.read("address").toString();
    //Position position;
    Position position= Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);

    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context ,state){
                    if(state is OnpressedLocationLoadingState){
                      return map(position);
                    }if(state is OnpressedLocationErrorState){
                      return Center(child: Text(state.message),);
                    }else if(state is OnpressedLocationLoadedState) {
                      return DetailPage();
                    }
                    else {
                      return Center(child: Text('Error'),);
                    }},),),
              
              Positioned(
                  top: height/2.5,
                  left: 5, right: width-50,
                  child: SizedBox(height: 200, width: 200,
                      child: FloatingActionButton(backgroundColor: AppColor.primarygreencolor,
                        onPressed: ()async  {
                          locBloc.add(OnpressedLocationEvent());
                        },
                        child: Icon(Icons.local_activity),)))
            ],
          ),

          // Container(
          //     padding: EdgeInsets.all(10),
          //     margin: EdgeInsets.all(20),
          //     width: width,
          //     height: 100,
          //     decoration: BoxDecoration(color: Colors.green[100],borderRadius: BorderRadius.circular(20)),
          //     child: Column(children: [Text("Your address : ",style: TextStyle(fontSize: 18)), SizedBox(height: 5,),
          //       Text(adresse! ?? '',style: TextStyle(fontSize: 24),)
          //     ],))
        ],),
    );
  }


  Widget map(Position position){
    return GoogleMap(
      mapType: MapType.normal ,
      onMapCreated: (GoogleMapController mapController){
        _mapController=mapController;
        _controller.complete(mapController);
        // locationController.setMapController(mapController);
      },
      initialCameraPosition: CameraPosition(target: LatLng(position.latitude,position.longitude)),
      markers: Set<Marker>.of(_markers),
    );
  }
}