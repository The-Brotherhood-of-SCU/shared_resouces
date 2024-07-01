import 'package:flutter/material.dart';
import 'package:shared_resource/pages/for_you_page.dart';
import 'package:shared_resource/pages/home_page.dart';
import 'package:shared_resource/pages/me_page.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      //backgroundColor: Colors.blue,
      icon: Icon(Icons.search_outlined),
      label: ("Search"),
      activeIcon: Icon(Icons.search)
    ),
    BottomNavigationBarItem(
      //backgroundColor: Colors.green,
      icon: Icon(Icons.star_outline),
      activeIcon: Icon(Icons.star),
      label: ("For You"),
    ),
    BottomNavigationBarItem(
      //backgroundColor: Colors.amber,
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: ("Me"),
    ),
  ];

  final pages = [HomePage(), ForYouPage(), MePage(), ];
  int currentIndex=1;
  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Resources"),),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        onTap: _changePage,
      ),
      body: pages[currentIndex],
    );
  }
}
