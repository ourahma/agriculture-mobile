import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/historicdatamodel.dart';
import '../Models/weather_data.dart';

class GeolocationRepository {
  String? long;
  String? lat;
  GeolocationRepository();

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
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
    // Store user position in shared preferences

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    lat = position.latitude.toString();
    long = position.longitude.toString();
    prefs.setString("long", long!);
    prefs.setString("lat", lat!);

    return position;
  }

  Future<Map<String, dynamic>> getCurrentdata() async {
    // Récupération de la localisation actuelle de l'utilisateur

    if (lat == null || long == null) {
      var geoloc = await Geolocator.getCurrentPosition();
      lat = geoloc.latitude.toString();
      long = geoloc.longitude.toString();
    }
    var url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current_weather=true&hourly=temperature_2m,relativehumidity_2m,rain';
    var response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});

    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  Future<List<Placemark>> getLocation(Position position) async {
    List<Placemark> addresses =
        await placemarkFromCoordinates(double.parse(lat!), double.parse(long!));

    var first = addresses.first;
    print(
        "in function getLocation ${first.name} : ${first..administrativeArea}");
    return addresses;
  }

  Future<List<HistoricalDataModel>> getHistoricdata() async {
    List<HistoricalDataModel> listHistoric = [];
    if (lat == null || long == null) {
      var geoloc = await Geolocator.getCurrentPosition();
      lat = geoloc.latitude.toString();
      long = geoloc.longitude.toString();
    }

    var date = new DateTime.now();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print(formattedDate);

    DateTime lastYear = DateTime(now.year - 1, now.month, now.day);
    String formattedLastYearDate = DateFormat('yyyy-MM-dd').format(lastYear);
    print(formattedLastYearDate);
    //var url ='https://archive-api.open-meteo.com/v1/era5?latitude=${geoloc.latitude}&longitude=${geoloc.longitude}&start_date=$datelastyear&end_date=$datenow&hourly=temperature_2m,rain,relativehumidity_2m';
    var url =
        'https://archive-api.open-meteo.com/v1/era5?latitude=$lat&longitude=$long&start_date=$formattedLastYearDate&end_date=$formattedDate&hourly=temperature_2m,relativehumidity_2m,rain';
    var response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print(url);
    final data = jsonDecode(response.body);
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
    return listHistoric;
  }

  Future<List<WeatherData>> fetchWeatherData() async {
    if (lat == null || long == null) {
      var geoloc = await Geolocator.getCurrentPosition();
      lat = geoloc.latitude.toString();
      long = geoloc.longitude.toString();
    }
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=02856aa462a81ad7719fc0a414504500'));
    //final response = await http.get(Uri.parse('api.openweathermap.org/data/2.5/forecast/daily?lat=${geoloc.latitude}&lon=${geoloc.longitude}&cnt=7&appid=02856aa462a81ad7719fc0a414504500'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['list'];
      return List<WeatherData>.generate(list.length, (i) {
        final item = list[i];

        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final temperature = item['main']['temp'].toDouble();
        final humidity = item['main']['humidity'].toDouble();
        return WeatherData(
            temperature: temperature, humidity: humidity, date: date);
      });
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
