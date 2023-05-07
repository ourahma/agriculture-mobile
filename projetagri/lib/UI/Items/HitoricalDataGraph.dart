import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Reposistory/Models/historicdatamodel.dart';
import '../../common/color.dart';

class HitoricalDataGraph extends StatelessWidget {
  final List<HistoricalDataModel> data;
  HitoricalDataGraph(this.data);

  @override
  Widget build(BuildContext context) {
    return (SfCartesianChart(
      backgroundColor: Colors.white,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<HistoricalDataModel, String>(
          yAxisName: 'Temperature',
          color: AppColor.secondarycolor,
          dataSource: data,
          xValueMapper: (HistoricalDataModel data, _) => data.hourly!.time,
          yValueMapper: (HistoricalDataModel data, _) =>
              data.hourly!.temperature2m,
        ),
        LineSeries<HistoricalDataModel, String>(
          color: Colors.blue,
          dataSource: data,
          xValueMapper: (HistoricalDataModel data, _) => data.hourly!.time,
          yValueMapper: (HistoricalDataModel data, _) => data.hourly!.rain,
        ),
        LineSeries<HistoricalDataModel, String>(
            color: AppColor.primarygreencolor,
            animationDuration: 500,
            dataSource: data,
            xValueMapper: (HistoricalDataModel data, _) => data.hourly!.time,
            yValueMapper: (HistoricalDataModel data, _) =>
                data.hourly!.relativehumidity2m)
      ],
    ));
  }
}
