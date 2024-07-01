import 'dart:async';
import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_resource/lib/ui.dart';

String base="http://124.221.108.135:5000";
//String base="http://10.134.41.156:5000";

Future<http.Response> httpPost(String uri)async{
  return await http.post(Uri.parse(base+uri));
}
Dio dio=Dio();
Future<Response> httpPostWithForm(String uri,Map<String,dynamic> parameter)async{
  //return await http.post(Uri.parse(base+uri),body: parameter);
  var response = await dio.post(base+uri, data: FormData.fromMap(parameter));
  return response;
}
Future<Response> UploadResources({String? kcm,String? kch,required String details,
  required String fileName,required String filePath,required String uploader})async{

  final formData=FormData.fromMap({
    "kcm":kcm,
    "kch":kch,
    "details":details,
    "file_name":fileName,
    "file":await MultipartFile.fromFile(filePath),
    "uploader":uploader

  });
  return await dio.post(base+"/upload",data: formData);
}

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
        rating: toDouble(i["rating"]),
        ratingNumber: i["rating_number"],
        uploader: i["uploader"]);
    l.add(f);
  }
  return l;
}
double toDouble(dynamic num){
  if(num is int){
    return num.toDouble();
  }
  return num as double;
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
        rating: toDouble(i["rating"]))
    );
  }
  return l;
}