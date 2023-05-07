import 'package:mongo_dart/mongo_dart.dart';

class InfoSearchModel {
  String plant;
  String season;
  String temperatureMax;
  String temperatureMin;
  String humidityMax;
  String humidityMin;
  String rainMax;
  String rainMin;

  InfoSearchModel({
    required this.plant,
    required this.season,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.humidityMax,
    required this.humidityMin,
    required this.rainMax,
    required this.rainMin,
  });

  factory InfoSearchModel.fromJson(Map<String, dynamic> json) {
    return InfoSearchModel(
      plant: json['element']['plant'],
      season: json['element']['season'],
      temperatureMax: json['element']['temperature']['max'],
      temperatureMin: json['element']['temperature']['min'],
      humidityMax: json['element']['humidity']['max'],
      humidityMin: json['element']['humidity']['min'],
      rainMax: json['element']['rain']['max'],
      rainMin: json['element']['rain']['min'],
    );
  }

  @override
  String toString() {
    return "plant is $plant season is $season ";
  }
}
