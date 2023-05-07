import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projetagri/Reposistory/Models/weather_data.dart';
import 'package:projetagri/UI/Items/HitoricalDataGraph.dart';
import '../Reposistory/Geolocation/geolocationRepository.dart';
import '../Reposistory/Models/historicdatamodel.dart';
import '../bloc/DataGraph/data_graph_bloc.dart';
import '../common/color.dart';
import 'Items/PredictionGraph.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var bloc;
  get width => MediaQuery.of(context).size.width;
  final GeolocationRepository c = GeolocationRepository();
  var datacurrent = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    GeolocationRepository c = GeolocationRepository();

    return BlocBuilder<DataGraphBloc, DataGraphState>(
      builder: (context, state) {
        if (state is StartEventLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is StartEventLoadedState) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          Container(
                              width: width,
                              height: height * 0.40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  image: const DecorationImage(
                                    image: AssetImage("images/agriculture.png"),
                                    fit: BoxFit.cover,
                                  ))),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _valuecontainer(
                                    "Humidity",
                                    Icons.water,
                                    AppColor.primarygreencolor,
                                    (state.datacurrent['hourly']
                                                ['relativehumidity_2m'][0]
                                            .toString()) +
                                        ' %'),
                                _valuecontainer(
                                    "Temperature",
                                    Icons.sunny,
                                    AppColor.secondarycolor,
                                    state.datacurrent['current_weather']
                                                ['temperature']
                                            .toString() +
                                        ' °C'),
                                _valuecontainer(
                                    "Rain",
                                    Icons.water_drop,
                                    Colors.blue,
                                    state.datacurrent['hourly']['rain'][0]
                                            .toString() +
                                        ' mm'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Historical Data',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 5),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: AppColor.primarygreencolor),
                              ),
                              Text("Humidity")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 5),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: AppColor.secondarycolor),
                              ),
                              Text("Temperature")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 5),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(color: Colors.blue),
                              ),
                              Text("Rain")
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 250,
                        width: width,
                        child: Scaffold(
                          body: FutureBuilder<List<HistoricalDataModel>>(
                            future: Future.delayed(Duration(seconds: 5), () {
                              print("loading data");
                              Future<List<HistoricalDataModel>> datahis =
                                  c.getHistoricdata();
                              return datahis;
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return HitoricalDataGraph(data);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text('Predictions',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200,
                        width: width,
                        child: Scaffold(
                          body: FutureBuilder<List<WeatherData>>(
                            future: Future.delayed(Duration(seconds: 5), () {
                              Future<List<WeatherData>> datahis =
                                  c.fetchWeatherData();
                              return datahis;
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return WeatherChart(data);
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.dangerous_sharp,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('${snapshot.error}')
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ],
              ));
        } else if (state is StartEventErrorState) {
          return Text(state.message);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _valuecontainer(
      String title, IconData icon, Color color, String data) {
    return Container(
      width: width * 0.27,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        //color: AppColor.secondarybackgroundcolor,
        boxShadow: const [
          BoxShadow(
              color: Colors.white,
              //blurRadius: 2.0,
              offset: Offset(
                0,
                5.0,
              )),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 0, right: 0),
        child: Column(
          children: [
            Center(
                child: Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Icon(icon, color: color, size: 40),
            const SizedBox(
              height: 10,
            ),
            Text(
              data,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
