
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:projetagri/UI/settings.dart';
import '../Reposistory/Geolocation/geolocationRepository.dart';
import '../bloc/Authentification/authentification_bloc.dart';
import '../bloc/Authentification/authentification_event.dart';
import '../common/color.dart';
import 'EditProfile.dart';
import 'infoaccount.dart';


class ProfilePage extends StatefulWidget  {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  var authBloc ;
  GetStorage userdata=GetStorage();

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthentificationBloc>(context) ;
    //AuthReposistory repo=AuthReposistory();
    //authBloc=AuthentificationBloc(AuthentificationState(), repo);
    super.initState();

  }

  /*SignupUser getuser(){
    final userBox= Hive.box('user');
    SignupUser u=userBox.get(0);
    print('==================================================${u.email} ${u.firstname} ${u.props}' );
    return u;
  }*/

  Future<bool> onPressedLogOut(BuildContext context) async{
    String email=userdata.read("email").toString();
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context){
          return  BlocConsumer<AuthentificationBloc,AuthentificationState>(
              builder: (context , state ) {
                if(state is LogoutLoadingState){
                  print("login Loadi State");
                  return  Center(child: CircularProgressIndicator());
                }else if(state is LogoutErrorState){
                  return SnackBar(content: Text('ERROR while trying to log out, try again ',
                  ),showCloseIcon: true,);
                }else{
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                      icon: Icon(Icons.add_alert, color: Colors.red.withOpacity(0.7),),
                    title: Text('Are you sure you want to log out ?',
                        style: TextStyle(fontSize: 14),
                    ),
                    content: Padding(padding: EdgeInsets.only(left: 12,right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primarygreencolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              authBloc.add(LogoutButtonPressed());
                              // // Log out the user
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // await prefs.setBool('isLoggedIn', false);
                              // // Navigate to the login screen
                              // Navigator.pushNamedAndRemoveUntil(context, '/',
                              //   ModalRoute.withName('/'),
                              // );
                            },
                            child: Text('Log Out'),),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primarygreencolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),),
                            onPressed: () async {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Cancel'))])));}},
              listener: (context , state ){
                if (state is LogoutSucessState){
                  print("page Log out Sucees Satate");
                  Navigator.pushReplacementNamed(context, "/");
                }});});
    return exitApp ?? false ;
  }


  static const keyDarkMode ='key_dark_mode';
  Map data = {};
  bool isobscuredPassword = true ;
  GeolocationRepository g = GeolocationRepository() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(backgroundColor: AppColor.primarygreencolor, title: const Text('Profile'),
            actions: [
              IconButton(
                  onPressed:()=>Navigator.pushReplacementNamed(context, "/settings") ,
                  icon: const Icon(Icons.settings , color: Colors.white,))],
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 15 , right: 15 , top: 20),
            child: GestureDetector( //sert à détecter les gestes. Les gestes sont tout type d'événement d'interaction : tapotements, glissements etc.
              onTap: (){FocusScope.of(context).unfocus();},
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                              border:Border.all(width: 4, color: Colors.white),
                              boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1))],
                              shape: BoxShape.circle,
                              image:  DecorationImage(fit: BoxFit.cover,
                                  image: AssetImage("images/emptyprofil.png"))),
                        ),
                        Container(width: 40,
                            decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                            margin: EdgeInsets.only(left: 90, top:100),
                            child: IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.edit,color: AppColor.primarygreencolor,size: 30,)))],),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [/*${getStorage.data['firstname']} ${getStorage.data['lastname']}*/
                      const SizedBox(height: 10,),
                      Text('', style: Theme.of(context).textTheme.headlineMedium,),
                      Text("email" ??"email", style: Theme.of(context).textTheme.titleLarge ,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));},
                      style: ElevatedButton.styleFrom(
                        padding:EdgeInsets.only(top: 13, bottom: 13) ,
                        backgroundColor: AppColor.primarygreencolor,
                        side: BorderSide.none,
                        shape: const StadiumBorder() ,),
                      child: Text(' Edit profile', style: TextStyle(color: Colors.white ,fontSize: 18),),
                    ),
                  ),
                  //buildDarkMode(),
                  const Divider( color: AppColor.primarygreencolor, height: 46.5, ),
                  //MENU
                  ProfileMenuWidget(
                    title: 'Informations About account',
                    icon: LineAwesomeIcons.info_circle,
                    onPress: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => InfosAccount())),
                  ),
                  ProfileMenuWidget(
                      title: 'Setting',
                      icon: LineAwesomeIcons.cog,
                      onPress: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()))),
                  ProfileMenuWidget(
                    title: 'Log Out',
                    icon: LineAwesomeIcons.alternate_sign_out,
                    onPress: () async {onPressedLogOut(context);},
                  ),],)
                  ,),),
                  );
                  }
                  
    
  }

  // Widget buildDarkMode()=> SwitchSettingsTile(
  //   title: 'Dark Mode',
  //   settingKey: keyDarkMode,
  //   leading: IconWidget(
  //     icon: Icons.dark_mode,
  //     color: Colors.green.shade800,
  //   ),
  //   onChange: (_){

  //   },
  // );







class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconWidget({ Key? key,
    required this.icon,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child:Icon(icon, color: Colors.white,),
      );
}
class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key ,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title ;
  final IconData icon ;
  final VoidCallback onPress ;
  final bool endIcon ;
  final Color? textColor ;

  @override
  Widget build(BuildContext context) {

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark ;
    var iconColor = isDark ? Colors.green.shade900 : Colors.green ;

    return ListTile( //contient une à trois lignes de texte facultativement flanquées d'icônes ou d'autres widgets, tels que des cases à cocher.
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40 ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.2),
        ),
        child: Icon(icon , color: iconColor ,),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColor.primarygreencolor.withOpacity(0.1),),
        child: const Icon(LineAwesomeIcons.angle_right, size: 19, color: Colors.black,),
      ):null ,
    );
  }
}