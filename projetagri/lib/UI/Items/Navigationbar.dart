import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../common/color.dart';
import '../AddEsp.dart';
import '../DetailPage.dart';
import '../HomePage.dart';
import '../SearchPage.dart';
import '../ProfilePage.dart';



class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavBarState();
}

class _NavBarState extends State<Navigation> {
  final home=const HomePage();
  final search= const SearchPage();
  final profile= const ProfilePage();
  final addesp=const AddEsp();
  final detail= const DetailPage();

  int _page=0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Widget _pagechooser(int page){
    switch(page){
      case 0:
        return home;
      case 1:
        return search;
      case 2:
        return detail;
      case 3:
        return profile;
      default:
        return Container(child: const Text("No Page found"),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pagechooser(_page),
      bottomNavigationBar: CurvedNavigationBar(height: 60,
        buttonBackgroundColor: AppColor.backgroundcolor,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(microseconds: 500),
        onTap: (int index){
          final CurvedNavigationBarState? navBarState = _bottomNavigationKey.currentState;
          navBarState?.setPage(index);
          setState(() {
            _page=index;
          });
        },
        items: const [
          Icon(Icons.home),
          Icon(Icons.search_outlined),
          Icon(Icons.add_circle_outline),
          Icon(Icons.person)
        ],
      ),
    );
  }
}
