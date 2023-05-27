import 'package:flutter/material.dart';
import 'package:projetagri/UI/map_screen.dart';
import 'package:projetagri/library.dart';
import '../common/color.dart';
import 'Items/MyHeaderDrawer.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage= DrawerSection.home;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.primarygreencolor,title: Text("Choose your Location"),centerTitle: true,),
      body: MapScreen(),
      drawer: Drawer(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList()
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget MyDrawerList(){
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          munuItem(1,"Home",Icons.home,currentPage==DrawerSection.home ?true:false),
          munuItem(2,"Profile",Icons.person,currentPage==DrawerSection.profile ?true:false),
          munuItem(3,"Location",Icons.location_on,currentPage==DrawerSection.location ?true:false),
          munuItem(4,"Settings",Icons.settings,currentPage==DrawerSection.settings ?true:false),
        ],
      ),
    );
  }

  Widget munuItem(int id,String title,IconData icon ,bool selected){
    return  Material(
      color: selected?Colors.grey[300]:Colors.transparent,
      child: InkWell(
        onTap: ()=>{
          Navigator.pop(context),
          setState(() {
            if(id==1){
              //Navigator.pushReplacementNamed(context, '/HomePgae');
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              }
            else if(id==2){
              //Navigator.pushReplacementNamed(context, '/profile');
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            }
            else if(id==3){
              //Navigator.pushReplacementNamed(context, '/LocationScreen');
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
            }
            else if(id==4){
              //Navigator.pushReplacementNamed(context, '/settings');
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            }
          })
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(child: Icon(icon,size: 20,color: Colors.black,)),
              Expanded(flex:3,child: Text(title,style: TextStyle(color:Colors.black,fontSize: 16),))
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSection{
  home,
  profile,
  location,
  settings
}
