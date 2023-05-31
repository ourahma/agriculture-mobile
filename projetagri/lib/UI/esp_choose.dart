import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:projetagri/UI/esp_data_screen.dart';
import 'package:projetagri/bloc/Espdata/esp_data_bloc.dart';

import '../library.dart';

class EspChoose extends StatefulWidget {
  const EspChoose({Key? key}) : super(key: key);

  @override
  State<EspChoose> createState() => _EspChooseState();
}

class _EspChooseState extends State<EspChoose> {

  final formKey = GlobalKey<FormState>();
  TextEditingController macaddressController = TextEditingController();
  var espBloc;String input ='';


  @override
  void initState() {
    espBloc = BlocProvider.of<EspDataBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EspDataBloc,EspDataState>(
        builder: (context , state ){
          if(state is EspdataLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }else if(state is EspdataLoadedState){
            return EspDataScreen();
          }else{
            return Stack(
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
                Center(
                  child: Container(
                    width: 290,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  'Check your esp agricultural field',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold ,
                                      fontSize: 18 ,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              SizedBox(height: 25,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  // autofillHints: [AutofillHints.name],
                                  controller: macaddressController ,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Enter the Mac Address of your esp";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mac address' ,
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                          color: AppColor.primarygreencolor,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                          color: AppColor.primarygreencolor,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                          color:AppColor.primarygreencolor,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed:() async {
                                    if(formKey.currentState!.validate()){
                                      print('onTapped');
                                      espBloc.add(EspButtonPressedEvent(macaddressController.text));
                                    }
                                  } ,
                                  child: Text('Check', style: TextStyle(color: Colors.black),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primarygreencolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                )
              ],
            );
          }
        },
        listener: (context , state){
          if (state is EspdataErrorState) {
            Get.snackbar(
              "Something went wrong ! Mac Address Invalid",
              state.message,
              icon: Icon(
                Icons.error,
                size: 25,
                color: Colors.red, //4022d860ed38
              ),
              backgroundColor: Colors.white,
              duration: Duration(seconds: 3),
            );
          }
        }
    );
  }
}
