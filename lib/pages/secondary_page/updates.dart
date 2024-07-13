import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../lib/ui.dart';
import '../../lib/utils.dart';



class CheckUpdates extends StatefulWidget {
  const CheckUpdates({super.key});

  @override
  State<CheckUpdates> createState() => _CheckUpdatesState();
}

class _CheckUpdatesState extends State<CheckUpdates> {
  static const String uri =
      "https://api.github.com/repos/The-Brotherhood-of-SCU/shared_resouces/releases/latest";
  String? latestVersion;
  bool isError = false;



  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    bool isNewVersion = currentVersion != latestVersion && currentVersion!="$latestVersion.0";
    //isNewVersion=false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.check_update),
      ),
      body: kIsWeb
          ? Column(
              children: [
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.current_version,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.current_version+" $currentVersion"),
                          Text(
                              AppLocalizations.of(context)!.long)
                      ],
                    )),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.current_version,
                    child: Text(currentVersion)),
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.latest_version,
                    icon: isNewVersion && latestVersion != null
                        ? const Icon(Icons.arrow_circle_up_rounded)
                        : Container(),
                    onTap: (c) {
                      if (isNewVersion) {
                        launchUrl(Uri.parse(
                            "https://github.com/The-Brotherhood-of-SCU/shared_resouces/releases/latest"));
                      }
                    },
                    child: isError
                        ?  Text(AppLocalizations.of(context)!.failed_to_load)
                        : latestVersion == null
                            ? loading()
                            : isNewVersion
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        AppLocalizations.of(context)!.new_v,
                                        textScaler: TextScaler.linear(1.1),
                                      ),
                                      Text(AppLocalizations.of(context)!.latest_version+" $latestVersion"),
                                      Text(AppLocalizations.of(context)!.click_h)
                                    ],
                                  )
                                : Text(AppLocalizations.of(context)!.up_to)),
                ElevatedButton(
                    onPressed: () {
                      fetch();
                    },
                    child: Text(AppLocalizations.of(context)!.check_update))
              ],
            ),
    );
  }

  void fetch() async {
    setState(() {
      isError=false;
      latestVersion = null;
    });
    try{
      var request = json.decode(await http.read(Uri.parse(uri)));
      setState(() {
        // latestVersion = request["tag_name"];
        latestVersion = request[AppLocalizations.of(context)!.tag_name];
      });
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isError=true;
      });
    }

  }
}
