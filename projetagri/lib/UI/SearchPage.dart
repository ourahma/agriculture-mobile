import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../common/Info.dart';
import '../common/color.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    return SingleChildScrollView(
      child: Scaffold(
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
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
                            suffixIcon: const Icon(Icons.forest),
                            border: UnderlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print('sol is $sol');
                      print('_plant is $_plant');
                      print('selected sol  is $_selectedsol');
                      
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
              SizedBox(
                height: height * 0.45,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    child: Column(
                      children: [
                        article(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget article() {
    return ReadMoreText(
      Info.informationtypesol,
      trimLines: 12,
      textAlign: TextAlign.justify,
      trimMode: TrimMode.Line,
      trimCollapsedText: "read more",
      trimExpandedText: "read less",
      lessStyle: TextStyle(
          fontWeight: FontWeight.bold, color: AppColor.primarygreencolor),
      moreStyle: TextStyle(
          fontWeight: FontWeight.bold, color: AppColor.primarygreencolor),
      style: const TextStyle(fontSize: 16),
    );
  }
}
