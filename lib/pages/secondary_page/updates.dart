import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text("Check Update"),
      ),
      body: kIsWeb
          ? Column(
              children: [
                commonCard(
                    context: context,
                    title: "Current Version",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Version $currentVersion"),
                        const Text(
                            "With Github Action, Web version is always the latest")
                      ],
                    )),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonCard(
                    context: context,
                    title: "Current Version",
                    child: Text(currentVersion)),
                commonCard(
                    context: context,
                    title: "Latest Version",
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
                        ? const Text("Failed to Load")
                        : latestVersion == null
                            ? loading()
                            : isNewVersion
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "New Version Available!",
                                        textScaler: TextScaler.linear(1.1),
                                      ),
                                      Text("Latest Version $latestVersion"),
                                      const Text("Click Here to Download")
                                    ],
                                  )
                                : const Text("Current Version Is Up to Date")),
                ElevatedButton(
                    onPressed: () {
                      fetch();
                    },
                    child: const Text("Check Update"))
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
        latestVersion = request["tag_name"];
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
