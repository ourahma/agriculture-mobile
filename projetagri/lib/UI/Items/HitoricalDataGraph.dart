import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetagri/Reposistory/Geolocation/geolocationRepository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Reposistory/Models/historicdatamodel.dart';
import '../../Reposistory/Models/weather_data.dart';

import 'package:syncfusion_flutter_charts/charts.dart' as charts ;

import '../../common/color.dart';





class HitoricalDataGraph extends StatelessWidget {

  final List<HistoricalDataModel> data;
  HitoricalDataGraph(this.data);


  @override
  Widget build(BuildContext context) {

    return (SfCartesianChart(backgroundColor: Colors.white,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<HistoricalDataModel,String>(yAxisName: 'Temperature',
          color: Colors.yellow,
          dataSource: data,
          xValueMapper:(HistoricalDataModel data ,_)=> data.hourly!.time,
          yValueMapper: (HistoricalDataModel data,_)=> data.hourly!.temperature2m,
        ),
        LineSeries<HistoricalDataModel,String>(color: Colors.blue,
          dataSource: data,
          xValueMapper:(HistoricalDataModel data,_)=> data.hourly!.time,
          yValueMapper: (HistoricalDataModel data,_)=> data.hourly!.rain   ,
        ),
        LineSeries<HistoricalDataModel,String>(color: Colors.green,
            animationDuration: 500,
            dataSource: data,
            xValueMapper:(HistoricalDataModel data,_)=> data.hourly!.time,
            yValueMapper: (HistoricalDataModel data,_)=> data.hourly!.relativehumidity2m
        )
      ],

    ));
  }
}