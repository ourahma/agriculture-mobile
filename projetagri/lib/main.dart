import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:projetagri/bloc/DataGraph/data_graph_bloc.dart';
import 'package:projetagri/bloc/Location/location_bloc.dart';
import 'package:projetagri/common/color.dart';
import 'Reposistory/Geolocation/geolocationRepository.dart';
import 'Reposistory/auth_repo.dart';
import 'Reposistory/location_controller.dart';
import 'UI/ForgetPassword.dart';
import 'UI/DetailPage.dart';
import 'UI/Items/Navigationbar.dart';
import 'UI/ProfilePage.dart';
import 'UI/SearchPage.dart';
import 'UI/Login.dart';
import 'UI/HomePage.dart';

import 'UI/SignUp.dart';
import 'UI/map_screen.dart';
import 'UI/settings.dart';
import 'bloc/Authentification/authentification_bloc.dart';
import 'bloc/Authentification/authentification_event.dart';
import 'bloc/NetworkBloc/network_bloc_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final userdata = GetStorage();
  @override
  State<MyApp> createState() => _mainState();
}

class _mainState extends State<MyApp> {
  

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  void dispose() {
    Hive.box('user').compact();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());

    return MultiRepositoryProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthentificationBloc(
                  AuthentificationInitial(), AuthReposistory())
                ..add(StartEvent())),
          RepositoryProvider<GeolocationRepository>(
              create: (_) => GeolocationRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => AuthentificationBloc(
                    AuthentificationInitial(), AuthReposistory())
                  ..add(StartEvent())),
            BlocProvider(
                create: (context) =>
                    NetworkBlocBloc()..add(NetworkObserveEvent())),
            BlocProvider(
                create: (context) => LocationBloc(
                    OnpressedLocationLoadingState(), GeolocationRepository())),
            BlocProvider(
                create: (context) => DataGraphBloc(GeolocationRepository())
                  ..add(StartEventDataGraph()))
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: app(),
          ),
        ));
  }

  Widget app() {
    double height = MediaQuery.of(context).size.height;
    final userdata = GetStorage();
    bool? isloggedin = userdata.read("isloggedin");
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<NetworkBlocBloc, NetworkBlocState>(
        builder: (context, state) {
          if (state is NetworkFailureState) {
            /*Container(decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover,image: Image.asset('nointernetpic.png'))),)*/
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/noNetwok.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(
                      color: AppColor.primarygreencolor,
                    ))
              ],
            );
          } else if (state is NetworkSuccessState) {
            return FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return AlertDialog(
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        title: Text("Something went wrong "),
                        content: Text(snapshot.error.toString()));
                  } else {
                    return home(context);
                  }
                } else {
                  return home(context);
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

Widget home(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/nav',
    routes: {
      '/': (context) => const Login(),
      '/Signup': (context) => const Signup(),
      '/HomePage': (context) => const HomePage(),
      'forgetpassword': (context) => const ForgetPassword(),
      '/searchpage': (context) => const SearchPage(),
      '/profile': (context) => const ProfilePage(),
      '/nav': (context) => const Navigation(),
      '/DetailPage': (context) => const DetailPage(),
      '/settings': (context) => SettingsPage(),
      '/mapscreen': (context) => MapScreen()
    },
  );
}
 /*initial(){
  final userdata = GetStorage();
  bool? isloggedin = userdata.read("isloggedin");
  if(isloggedin==true){
    FlutterNativeSplash.remove();
    Navigator.pushReplacementNamed(context, "/nav");
  }else{
    FlutterNativeSplash.remove();
    Navigator.pushReplacementNamed(context, "/");
  }
 
  
}*/
