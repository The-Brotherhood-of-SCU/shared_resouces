import 'package:flutter/material.dart';
import 'package:shared_resource/pages/for_you_page.dart';
import 'package:shared_resource/pages/home_page.dart';
import 'package:shared_resource/pages/me_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late List<BottomNavigationBarItem> bottomNavItems ;
  @override
  void initState() {
    super.initState();

  }

  final pages = [const HomePage(), const ForYouPage(), const MePage(), ];
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
    bottomNavItems= [
      BottomNavigationBarItem(
        //backgroundColor: Colors.blue,
          icon: Icon(Icons.search_outlined),
          label: (AppLocalizations.of(context)!.search),
          activeIcon: Icon(Icons.search)
      ),
      BottomNavigationBarItem(
        //backgroundColor: Colors.green,
        icon: Icon(Icons.star_outline),
        activeIcon: Icon(Icons.star),
        label: (AppLocalizations.of(context)!.for_You),
      ),
      BottomNavigationBarItem(
        //backgroundColor: Colors.amber,
        icon: Icon(Icons.account_circle_outlined),
        activeIcon: Icon(Icons.account_circle),
        label: (AppLocalizations.of(context)!.me),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.shared_resources),),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        onTap: _changePage,
      ),
      body: pages[currentIndex],
    );
  }
}
