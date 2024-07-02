import 'package:flutter/material.dart';
import 'package:shared_resource/lib/ui.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SearchBar(controller: controller,
                hintText: "Search ...",
                trailing: [IconButton(icon: const Icon(Icons.search),onPressed: (){
                  setState(() {
                    url=controller.text;
                  });
                },)],
      
              ),
            ),
            url==null?const Center(child: Text("键入关键词以搜索"),):
            LoadFilesPage("/search/$url"),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
