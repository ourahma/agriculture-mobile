import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/color.dart';


class AddEsp extends StatefulWidget {
  const AddEsp({Key? key}) : super(key: key);

  @override
  State<AddEsp> createState() => _AddEspState();
}

class _AddEspState extends State<AddEsp> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover,image: AssetImage("images/backesp.png")
              )),),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white38),),
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60,left: 10,right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Text('Add A Virtual Zone ',style: GoogleFonts.alike(fontSize: 24,fontWeight: FontWeight.bold)),
              Form(
                child: Column(
                  children: [
                     Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                          const Text('Device : ',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),), const SizedBox(height: 100,),
                     textfield('  ESP 32 ')],),
                    const SizedBox(height: 10,),
                    const Text('Sensors',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
                    radiowidget('Humidity'),
                    radiowidget('Temperature'),
                    radiowidget('Rain'),
                    const Text('Position',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)), const SizedBox(height: 15,),
                    Row(
                      children: [
                        textfield(' -5.554722'), const SizedBox(width: 10),
                        textfield('33.895000'),],),const SizedBox(height: 10),
                  ],
                ),),const SizedBox(height: 10,),
              SizedBox(height: 50,width: MediaQuery.of(context).size.width-150,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColor.primarygreencolor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    onPressed: (){Navigator.pushReplacementNamed(context, '/DetailPage');},
                    child: Text('Add ')),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget radiowidget(String title){
    return
      RadioListTile(title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),value: title,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
          groupValue: title,
          onChanged: (value)=> setState(() {
          }));
  }
  Widget textfield(String title){
    return Expanded(
      child: TextField(
        controller: TextEditingController(text: title),
        enabled: false,
        decoration:InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),),),
    );
  }
}
