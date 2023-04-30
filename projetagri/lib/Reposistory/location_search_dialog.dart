import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

import 'location_controller.dart';
class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({this.mapController}) ;

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    final TextEditingController _controller = TextEditingController();
    return Container(
      margin: EdgeInsets.only(top: 150),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(width: width-20, child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: 'Seach a Location',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(style: BorderStyle.none,width: 0)),
              hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 16,color: Theme.of(context).disabledColor),
              filled: true, fillColor: Theme.of(context).cardColor
            ),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color ,fontSize: 20,)),


          suggestionsCallback: (pattern) async{
            return await Get.find<LocationController>().searchLocation(pattern);
          },
          itemBuilder: (context, Prediction suggestion ){
            return Padding(padding: EdgeInsets.all(10),
            child: Row(children: [
              Icon(Icons.location_on),
              Expanded(
                child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,fontSize: 20)),
              )
            ],),
            );
          }, onSuggestionSelected: (Prediction suggestion) {
            GetStorage userdata=GetStorage();
            userdata.write("address", suggestion.description);
            print("my location is "+ suggestion.description!);

            //Get.find<LocationController>().setLocation(suggestion.placeId,suggestion.description,mapController);
            Get.back();
        },
        ),),
      ),
    );
  }
}
