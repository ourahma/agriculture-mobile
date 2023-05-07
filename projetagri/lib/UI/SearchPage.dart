import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projetagri/Reposistory/fetchinfofromdb.dart';

import '../Reposistory/Models/infosearchmodel.dart';
import '../common/Info.dart';
import '../common/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<InfoSearchModel>> _future = Future.value([]);
  search() {
    sol = items[0];
  }

  String? sol, _selectedsol;
  var items = ["Summer", "Winter", "Autumn", "Spring", "All"];
  String s = "We can help you to know more information !";
  String? _plant;
  TextEditingController _plantcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                ' Select a season, or tap a name of a plant ',
                style: GoogleFonts.alike(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, right: 10),
                    height: height * 0.25,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          onSaved: (value) => _selectedsol = value.toString(),
                          iconSize: 30,
                          borderRadius: BorderRadius.circular(20),
                          hint: const Text(
                            "Select a season:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          value: sol,
                          items: items.map((e) {
                            return DropdownMenuItem(
                                value: e,
                                child: Text(e,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              sol = value.toString();
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            size: 30,
                            color: AppColor.primarygreencolor,
                          ),
                          dropdownColor: AppColor.backgroundcolor,
                          decoration: const InputDecoration(
                              labelText: 'Seasons',
                              border: UnderlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          autocorrect: false,
                          autofocus: true,
                          controller: _plantcontroller,
                          onChanged: (value) => setState(() => _plant = value),
                          decoration: InputDecoration(
                            hintText: 'Type a name of a plant',
                            suffixIcon: const Icon(
                              MdiIcons.tree,
                              color: AppColor.primarygreencolor,
                            ),
                            border: UnderlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        print('sol is $sol');
                        print('_plant is $_plant');

                        FetchDBInfo c = FetchDBInfo();

                        _future = c.fetchinfofromDb(sol ?? "All", _plant ?? "");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primarygreencolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  child: FutureBuilder<List<InfoSearchModel>>(
                future: _future,
                builder: (connection, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final data = snapshot.data;
                    return Container(
                      height: height * 0.5, // add a fixed height
                      child: ListView.builder(
                        itemCount: data?.length,
                        itemBuilder: (context, index) {
                          final item = data?[index];
                          return Container(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.green.shade100
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    item!.plant,
                                    style: GoogleFonts.alike(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    item!.season,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Temperature",
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .secondarycolor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons
                                                      .thermostat_auto_outlined,
                                                  color:
                                                      AppColor.secondarycolor,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "max :" + item.temperatureMax,
                                              style: TextStyle(
                                                  color:
                                                      AppColor.secondarycolor),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              " min :" + item.temperatureMin,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Humidity",
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .primarygreencolor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.opacity,
                                                  color: AppColor
                                                      .primarygreencolor,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "max :" + item.humidityMax,
                                              style: TextStyle(
                                                  color:
                                                      AppColor.secondarycolor),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              " min :" + item.humidityMin,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Rain",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  MdiIcons.weatherRainy,
                                                  color: Colors.blue,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "max :" + item.rainMax,
                                              style: TextStyle(
                                                  color:
                                                      AppColor.secondarycolor),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              " min :" + item.rainMin,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )
                                          ])
                                    ],
                                  )
                                ],
                              ));
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      child: Container(
                        child: Text("Error"),
                      ),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                              width: width - 50,
                              child: Image.asset("images/infonotfound.png")),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.clear,
                                color: AppColor.primarygreencolor,
                              ),
                              Text(
                                "   Nothing found ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.primarygreencolor),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
