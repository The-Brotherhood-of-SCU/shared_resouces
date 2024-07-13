import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:shared_resource/pages/secondary_page/personal_page.dart';
import 'package:shared_resource/pages/secondary_page/updates.dart';
import 'package:shared_resource/pages/secondary_page/upload_my_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0,20,0,10),
                      child: Icon(Icons.account_circle,size: 100,),
                    ),
                    Text(myAccount!,textScaler: const TextScaler.linear(1.5),)
                  ],
                ),
              ),
            ),
          ),
       Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buttonWithPadding(AppLocalizations.of(context)!.my_p, (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return PersonalPage(account: myAccount!,);}));}),
                //buttonWithPadding("My Comments", (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return MyComments();}));}),
                //buttonWithPadding("Test", (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return TestPage();}));}),
                buttonWithPadding(AppLocalizations.of(context)!.p_d, (){showInterestEditPopup(context);}),
                buttonWithPadding(AppLocalizations.of(context)!.m_d, (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return const UploadMyFilePage();}));}),
                buttonWithPadding(AppLocalizations.of(context)!.check_update, (){Navigator.of(context).push(CupertinoPageRoute(builder: (builder){return const CheckUpdates();}));}),
                redButtonWithPadding(AppLocalizations.of(context)!.logout, (){
                  myAccount=null;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                    return const LoginPage();
                  }));
                })
              ],
            ),
          
        ],
      ),
    );
  }

  Widget redButtonWithPadding(String text,void Function() f){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(onPressed: f, child: Text(text,style: const TextStyle(color: Colors.red),)),
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
        title: Text(AppLocalizations.of(context)!.p_d),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: interestController,decoration: InputDecoration(icon: Icon(Icons.text_fields),labelText: AppLocalizations.of(context)!.interest),),
            TextField(controller: gradesController,decoration: InputDecoration(icon: Icon(Icons.text_increase),labelText: AppLocalizations.of(context)!.grade))
          ],
        ),
        actions:  <Widget>[
          TextButton(
            child:  Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ensure),
            onPressed: () async{
              try{
                if(interestController.text.isEmpty){
                  throw Exception();
                }
                preferences.setInt(GRADES_Str, int.parse(gradesController.text));
                preferences.setString(INTEREST_Str, interestController.text);
              }catch(e){
                await showInfoDialog(context: builder,title: AppLocalizations.of(context)!.error,content: AppLocalizations.of(context)!.w_i);
              }
              Navigator.of(context).pop(); // 关闭对话框
            },
          ),
        ],
      );
  }
  );
}