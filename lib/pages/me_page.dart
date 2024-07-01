import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/pages/secondary_page/personal_page.dart';
import 'package:shared_resource/pages/secondary_page/test.dart';

import '../main.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Container(
            //color: Theme.of(context).primaryColor,
            decoration: BoxDecoration(color: Theme.of(context).disabledColor),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,10),
                    child: Icon(Icons.account_circle,size: 100,),
                  ),
                  Text(account!,textScaler: TextScaler.linear(1.5),)
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buttonWithPadding("My Personal Page", (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return PersonalPage(account: account!,);}));}),
              //buttonWithPadding("My Comments", (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return MyComments();}));}),
              buttonWithPadding("Test", (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return TestPage();}));}),
              buttonWithPadding("设置个性化推荐数据", (){showInterestEditPopup(context);}),
              redButtonWithPadding("Logout", (){
                account=null;
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                  return const LoginPage();
                }));
              })
            ],
          ),
        )
      ],
    );
  }

  Widget redButtonWithPadding(String text,void Function() f){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(onPressed: f, child: Text(text,style: TextStyle(color: Colors.red),)),
    );
  }
  Widget buttonWithPadding(String text,void Function() f){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: f, child: Text(text)),
    );
  }
}

void showInterestEditPopup(BuildContext context){
  final TextEditingController interestController=TextEditingController(text:preferences.getString(INTEREST_Str));
  int? grades0=preferences.getInt(GRADES_Str);
  final TextEditingController gradesController=TextEditingController(text: grades0?.toString());
  showDialog(context: context, builder: (builder){
      return AlertDialog(
        title: Text("设置个性化推荐数据"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: interestController,decoration: InputDecoration(icon: Icon(Icons.text_fields),labelText: "兴趣方向"),),
            TextField(controller: gradesController,decoration: InputDecoration(icon: Icon(Icons.text_increase),labelText: "这方面的成绩（0-100）"))
          ],
        ),
        actions:  <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
          ),
        ],
      );
  }
  );
}