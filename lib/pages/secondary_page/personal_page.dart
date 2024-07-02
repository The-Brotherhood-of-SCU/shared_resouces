import 'package:flutter/material.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/lib/ui.dart';

class PersonalPage extends StatefulWidget {
  final String account;

  const PersonalPage({super.key, required this.account});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.account}的个人主页"),
      ),
      body: Scaffold(
        appBar: TabBar(
            controller: tabController,
            tabs: const [Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("Uploads"),
            ), Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("Comments"),
            )]),
        body: TabBarView(
          controller: tabController,
          children: [UserUploads(widget.account), UserComments(widget.account)],
        ),
      ),
    );
  }
}
class UserUploads extends StatelessWidget {
  final String account;
  const UserUploads(this.account,{super.key});

  @override
  Widget build(BuildContext context) {
    return LoadFilesPage("/user/${Uri.encodeFull(account)}/files");
  }
}
class UserComments extends StatelessWidget {
  final String account;
  const UserComments(this.account,{super.key});

  @override
  Widget build(BuildContext context) {
    return LoadCommentPage("/user/${Uri.encodeFull(account)}/comments",isShowFilePage: true,);
  }
}


