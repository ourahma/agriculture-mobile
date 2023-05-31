import 'dart:async';

import 'package:projetagri/UI/Items/EspGraph.dart';

import '../Reposistory/Models/EspData.dart';
import '../Reposistory/EspRepository/esp_data_repo.dart';
import '../bloc/Espdata/esp_data_bloc.dart';
import '../library.dart';

class EspDataScreen extends StatefulWidget {
  const EspDataScreen({Key? key}) : super(key: key);

  @override
  State<EspDataScreen> createState() => _EspDataScreenState();
}

class _EspDataScreenState extends State<EspDataScreen> {
  get width => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EspdataRepo repo = EspdataRepo();
    return BlocBuilder<EspDataBloc, EspDataState>(
      builder: (context, state) {
        if (state is EspdataLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is EspdataLoadedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primarygreencolor,
              title: Center(child: Text('Suivi Esp32', style: TextStyle(fontWeight: FontWeight.bold),)),
            ),
            //backgroundColor: AppColor.primarygreencolor,
            body: Stack(
              children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image:AssetImage("images/espagri.png"),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    ///---
                    ListView(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 20,),
                            Container(
                              width: 340,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'Mac Address : ${state.data.last.macaddress}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 340,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Historical Data', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10,),
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
                                            decoration: BoxDecoration(color: AppColor.primarygreencolor),
                                          ),
                                          Text("Humidity",style: TextStyle(fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20, right: 5),
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(color: AppColor.secondarycolor),
                                          ),
                                          Text("Temperature",style: TextStyle(fontWeight: FontWeight.bold),)
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
                                          Text("Rain",style: TextStyle(fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            EspGraphTemperature(state.data),
                            SizedBox(height: 15,),
                            EspGraphHumidity(state.data),
                            SizedBox(height: 15,),
                            EspGraphRain(state.data),
                            const SizedBox(height: 30,),
                          ],
                        ),
                      ],
                    )
              ],
            ),
          );
        } else if (state is EspdataErrorState) {
          return Text(state.message);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _valuecontainer(String title, IconData icon, Color color, String data) {
    return Container(
      width: width * 0.29,
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
