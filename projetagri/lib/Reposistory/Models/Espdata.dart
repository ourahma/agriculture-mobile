class Espdata {
  String? time;
  var temperature;
  int? humidity;
  int? rain;
  String? macaddress;

  Espdata(
      {this.time, this.temperature, this.humidity, this.rain, this.macaddress});

  Espdata.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    rain = json['rain'];
    macaddress = json['macaddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['rain'] = this.rain;
    data['macaddress'] = this.macaddress;
    return data;
  }
}