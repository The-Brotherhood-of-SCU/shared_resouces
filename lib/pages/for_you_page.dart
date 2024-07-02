import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/ui.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  @override
  Widget build(BuildContext context) {
    var grades=preferences.getInt(GRADES_Str);
    var interest=preferences.getString(INTEREST_Str);
    if(grades==null||interest==null){
      return const Center(child: Text("请先在Me选项卡中设置个性化推荐信息"));
    }else{
      return LoadFilesPage("/recommend?keyword=${Uri.encodeFull(interest)}&grades=${grades/100}");
    }

  }
}
