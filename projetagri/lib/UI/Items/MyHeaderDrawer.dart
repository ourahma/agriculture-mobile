import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/color.dart';




class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}
class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  final userdata=GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primarygreencolor,
      //decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/agriculture.png"))),
      width: double.infinity,
      height:200,
      padding: const EdgeInsets.only(top:20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom:10),
            height:70,
            decoration: const BoxDecoration(
              shape:BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("images/farmer.png"),))),
          const Text("Username", style: TextStyle(color:Colors.white,fontSize: 20),),
           Text(userdata.read('email').toString(), style: const TextStyle(color:Colors.white,fontSize: 14),),
        ],
      ),
    );
  }
}
