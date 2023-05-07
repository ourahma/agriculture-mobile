import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Reposistory/Models/weather_data.dart';



class WeatherChart extends StatelessWidget {
  final List<WeatherData> data;

  WeatherChart(this.data);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<WeatherData, DateTime>(
          id: 'Temperature',
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          domainFn: (WeatherData data, _) => data.date,
          measureFn: (WeatherData data, _) => data.temperature,
          data: data,
        ),
        charts.Series<WeatherData, DateTime>(
          id: 'Humidity',
          colorFn: ( _, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (WeatherData data, _) => data.date,
          measureFn: (WeatherData data, _) => data.humidity,
          data: data,
        ),

      ],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
      ),
      domainAxis: const charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd/MM',
            transitionFormat: 'dd/MM',
          ),
        ),
      ),
    );
  }
}
