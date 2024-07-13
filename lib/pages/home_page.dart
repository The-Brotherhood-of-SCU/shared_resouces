import 'package:flutter/material.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  TextEditingController controller = TextEditingController();
  String? url;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SearchBar(controller: controller,
                hintText: AppLocalizations.of(context)!.search,
                trailing: [IconButton(icon: const Icon(Icons.search),onPressed: (){
                  setState(() {
                    url=controller.text;
                  });
                },)],
      
              ),
            ),
            url==null? Center(child: Text(AppLocalizations.of(context)!.s_k),):
            LoadFilesPage("/search/${Uri.encodeFull(url!)}"),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
