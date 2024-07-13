import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      return  Center(child: Text(AppLocalizations.of(context)!.set_p));
    }else{
      return LoadFilesPage("/recommend?keyword=${Uri.encodeFull(interest)}&grades=${grades/100}");
    }

  }
}
