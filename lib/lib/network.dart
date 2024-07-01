import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_resource/lib/ui.dart';

String base="http://124.221.108.135:5000";


Future<String> httpGet(String uri) async {
  return await http.read(Uri.parse(base+uri));
}
Future<dynamic> httpGetJson(String uri)async{
  return await jsonDecode(await httpGet(uri));
}

Future<List<FileDetail>> getFileDetails(String url)async{
  var l=<FileDetail>[];
  var result=await httpGetJson(url);
  for(var i in result){
    var f=FileDetail(
        kch: i["kch"],
        kcm: i["kcm"],
        details: i["details"],
        fileName: i["file_name"],
        fileSize: i["file_size"],
        filePointer: i["file_pointer"],
        uploadTime: i["upload_time"],
        rating: i["rating"],
        ratingNumber: i["rating_number"],
        uploader: i["uploader"]);
    l.add(f);
  }
  return l;
}
Future<List<CommentDetail>> getCommentDetails(String url)async{
  var l=<CommentDetail>[];
  var result=await httpGetJson(url);
  for(var i in result){
    l.add(CommentDetail(
        account: i["account"],
        filePointer: i["file_pointer"],
        timestamp: i["timestamp"],
        text: i["text"],
        rating: i["rating"])
    );
  }
  return l;
}