import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SettingsPage extends StatelessWidget {
  static const keyLanguage ='key_language' ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        iconTheme: IconThemeData.fallback(),
        shadowColor: Colors.transparent,
      ),
      body: Container(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.settings,color: Colors.grey.shade700,size: 30,),SizedBox(width: 10,),Text('Settings',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey.shade700),)],),
              const Divider( color: Colors.green, height: 25, ),
              buildLanguage(), //1
              SettingsMenuWidget( //2
                icon: Icons.language,
                title: 'Language',
                onPress: (){},
              ),
              SettingsMenuWidget(
                icon: Icons.wifi,
                title: 'Wifi Settings',
                onPress: (){
                  AppSettings.openWIFISettings(callback: () {
                    print("sample callback function called");
                  });
                },
              ),
              SettingsMenuWidget(
                icon: Icons.location_on_rounded,
                title: 'Location Settings',
                onPress: (){
                  AppSettings.openLocationSettings();
                },
              ),
              SettingsMenuWidget(
                icon: Icons.notifications,
                title: 'Notifications',
                onPress: (){
                  AppSettings.openNotificationSettings();
                },
              ),
              SettingsMenuWidget(
                icon: Icons.delete,
                title: 'Delete Account',
                onPress: (){},
              ),
            ],
          )
      ),
    );
  }


  Widget buildLanguage()=>DropDownSettingsTile(
    title: 'Language',
    settingKey: keyLanguage,
    selected: 1,
    values: <int,String>{
      1:'English',
      2:'Spanish',
      3:'Chinese',
      4:'Arabic',
    },
    onChange: (language){
      /* NOOP */
    },
  );
}
class SettingsMenuWidget extends StatelessWidget {
  const SettingsMenuWidget({
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
          color: Colors.green.withOpacity(0.1),
        ),
        child: const Icon(LineAwesomeIcons.angle_right, size: 19, color: Colors.grey,),
      ):null ,
    );
  }
}