import 'package:flutter/material.dart';

import '../../lib/ui.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    FileDetail fileDetail=FileDetail(details: 'this is a test', fileName: 'abc.docx', fileSize: 1000, filePointer: 123, uploadTime: 1719812210, rating: 3.5, ratingNumber: 2, uploader: '57u',);
    CommentDetail commentDetail=CommentDetail(account: "57u", filePointer: 123, timestamp: 1719812210, text: "i love it", rating: 4.7,fileName: "114514.doc");
    return Scaffold(
      appBar: AppBar(title: Text("Test"),),
      body: Column(
        children: [
          FileDetailCard(fileDetail),
          CommentDetailCard(commentDetail),
        ],
      ),
    );
  }
}
