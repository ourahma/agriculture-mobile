import 'library.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get/get.dart';

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
  bool isloggedin = false;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  void dispose() {
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
    //final SharedPreferences prefs =await SharedPreferences.getInstance();
    isloggedin = true;
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<NetworkBlocBloc, NetworkBlocState>(
        builder: (context, state) {
          if (state is NetworkFailureState) {
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
  Widget home(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: isloggedin?'/nav':'/',
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
}


