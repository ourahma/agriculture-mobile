import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http ;
import 'package:flutter/services.dart';
import '../Models/historicdatamodel.dart';
import '../Models/weather_data.dart';


class GeolocationRepository {
  GeolocationRepository();

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    //permission = await Geolocator.requestPermission();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      //await Location().requestService();
      if (!await Geolocator.openLocationSettings()) {
        return Future.error('Location services are disabled.');
      }
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<Map<String, dynamic>> getCurrentdata() async {
    // Récupération de la localisation actuelle de l'utilisateur
    var geoloc = await Geolocator.getCurrentPosition();
    var url = 'https://api.open-meteo.com/v1/forecast?latitude=${geoloc
        .latitude}&longitude=${geoloc
        .longitude}&current_weather=true&hourly=temperature_2m,relativehumidity_2m,rain';
    var response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"}
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  Future<List<Placemark>> getLocation(Position position) async {
    debugPrint('location: ${position.latitude}');
    List<Placemark> addresses = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    var first = addresses.first;
    print("${first.name} : ${first..administrativeArea}");
    return addresses;
  }

//List<HistoricalDataModel> HistoricalDataModelFromJson(String str) => List<HistoricalDataModel>.from(json.decode(str).map((x) => HistoricalDataModel.fromJson(x))).toList();

// getHistoricdata() async {
//   var position = await determinePosition();
//   //var url ='https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&past_days=10&hourly=temperature_2m,relativehumidity_2m,rain';
//   var url = 'https://archive-api.open-meteo.com/v1/era5?latitude=${position.latitude}&longitude=${position.longitude}&start_date=2021-01-01&end_date=2021-12-31&hourly=temperature_2m,relativehumidity_2m,rain' ;
//   var response = await http.get(Uri.parse(url),
//
//       headers: {"Content-Type": "application/json"}
//   );
//   final json = jsonDecode(response.body);
//   List<HistoricalDataModel> his =[];
//
//   for (int i = 0; i < json['hourly'].length; i++) {
//     Hourly hourly= Hourly(
//       time: DateTime.parse(json['hourly']['time'][i]),
//       temperature2m: json['hourly']['temperature_2m'][i],
//       relativehumidity2m: json['hourly']['relativehumidity_2m'][i],
//       rain: json['hourly']['rain'][i],
//     );
//     HistoricalDataModel historicalDataModel = HistoricalDataModel(hourly: hourly);
//     print('historicalDataModel.toString() dans function --->>>>>> ${historicalDataModel.toString()}');
//     his.add(historicalDataModel );
//   }
// print('listHistoric ===>>>>>>>>>> $his');
//   return his;
// }


  //todo: me

  /*Future<List<HistoricalDataModel>> getHistoricdata() async {
    var position = await determinePosition();
    var date = new DateTime.now();
    int day = date.day;
    int year=date.year;
    int month=date.month;
    String datenow='$year-$month-$day';
    String datelastyear='${year-1}-$month-$day';
    print("this date is ${datenow}");
    print("last year is ${datelastyear}");
    var url ='https://archive-api.open-meteo.com/v1/era5?latitude=${position.latitude}&longitude=${position.longitude}&start_date=$datelastyear&end_date=$datenow&hourly=temperature_2m,rain,relativehumidity_2m';
    var response = await http.get(Uri.parse(url),

        headers: {"Content-Type": "application/json"}
    );
    final json = jsonDecode(response.body);
    List<HistoricalDataModel> his =[];

    int data_day;
    int data_month;
    String concatenation;
    for (int i = 0; i < json['hourly']['time'].length; i++) {
      data_day=DateTime.parse(json['hourly']['time'][i]).day;
      data_month=DateTime.parse(json['hourly']['time'][i]).month;
      concatenation="$data_month/$data_day";
      HistoricalDataModel object= HistoricalDataModel(
          hourly: Hourly(
            time: concatenation,
            temperature2m: json['hourly']['temperature_2m'][i],
            relativehumidity2m: json['hourly']['relativehumidity_2m'][i],
            rain: json['hourly']['rain'][i],
          ));

      print(object.toString());
      his.add(object);
    }
    return his;
  }*/

  Future<List<HistoricalDataModel>> getHistoricdata() async {
    List<HistoricalDataModel> listHistoric = [];
    var geoloc = await Geolocator.getCurrentPosition();
    var date = new DateTime.now();
    int day = date.day;
    int year=date.year;
    int month=date.month;
    String datenow ;
    String datelastyear ;
    if(month > 9 ){
       datenow='$year-$month-$day';
       datelastyear='${year-1}-$month-$day';
    }else{
       datenow='$year-0$month-$day';
       datelastyear='${year-1}-0$month-$day';
    }
    print("this date is ${datenow}");
    print("last year is ${datelastyear}");
    //var url ='https://archive-api.open-meteo.com/v1/era5?latitude=${geoloc.latitude}&longitude=${geoloc.longitude}&start_date=$datelastyear&end_date=$datenow&hourly=temperature_2m,rain,relativehumidity_2m';
    var url = 'https://archive-api.open-meteo.com/v1/era5?latitude=${geoloc.latitude}&longitude=${geoloc.longitude}&start_date=$datelastyear&end_date=$datenow&hourly=temperature_2m,relativehumidity_2m,rain' ;
    var response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"}
    );
    final data = jsonDecode(response.body);

    // for (var i = 0; i < data['hourly']['time'].length; i++){
    //   Hourly hourly = Hourly(
    //       time : data['hourly']['time'][i],
    //       temperature2m: data['hourly']['temperature_2m'][i],
    //       relativehumidity2m:data['hourly']['relativehumidity_2m'][i],
    //       rain:data['hourly']['rain'][i]);
    //   HistoricalDataModel historicalDataModel = HistoricalDataModel(hourly:hourly);
    //   listHistoric.add(historicalDataModel);
    // }

    for (var i = 0; i < data['hourly']['time'].length; i++) {
      DateTime date = DateTime.parse(data['hourly']['time'][i]);
      int day = date.day;
      int month = date.month;
      Hourly hourly = Hourly(
          time: "$day/$month",
          temperature2m: data['hourly']['temperature_2m'][i],
          relativehumidity2m: data['hourly']['relativehumidity_2m'][i],
          rain: data['hourly']['rain'][i]);
      HistoricalDataModel historicalDataModel =
      HistoricalDataModel(hourly: hourly);
      listHistoric.add(historicalDataModel);
    }
    return listHistoric ;
  }

  Future<List<WeatherData>> fetchWeatherData() async {
    var geoloc = await Geolocator.getCurrentPosition();
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=${geoloc.latitude}&lon=${geoloc.longitude}&appid=02856aa462a81ad7719fc0a414504500'));
    //final response = await http.get(Uri.parse('api.openweathermap.org/data/2.5/forecast/daily?lat=${geoloc.latitude}&lon=${geoloc.longitude}&cnt=7&appid=02856aa462a81ad7719fc0a414504500'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['list'];
      return List<WeatherData>.generate(list.length, (i) {
        final item = list[i];

        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final temperature = item['main']['temp'].toDouble();
        final humidity =item['main']['humidity'].toDouble();
        return WeatherData(temperature : temperature, humidity: humidity ,date: date);
      });
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

}