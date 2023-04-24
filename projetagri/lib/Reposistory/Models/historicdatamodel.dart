import 'dart:convert';


class HistoricalDataModel {
  Hourly? hourly;

  HistoricalDataModel({this.hourly});

}


class Hourly {
  String? time;
  double? temperature2m;
  int? relativehumidity2m;
  double? rain;

  Hourly({this.time, this.temperature2m, this.relativehumidity2m, this.rain});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature2m = json['temperature_2m'];
    relativehumidity2m = json['relativehumidity_2m'];
    rain = json['rain'];
  }
  @override
  String toString() {
    
    return "temperature is ${this.temperature2m} rain is ${this.rain} humidity is ${this.relativehumidity2m}";
  }

}