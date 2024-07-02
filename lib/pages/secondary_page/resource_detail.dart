
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/custom_rating.dart';
import 'package:flutter_star/star.dart';
import 'package:flutter_star/star_score.dart';
import 'package:intl/intl.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:shared_resource/pages/secondary_page/personal_page.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDetailPage extends StatelessWidget {
  final FileDetail fileDetail;
  const FileDetailPage(this.fileDetail,{super.key});
  static final DateFormat dateFormat = DateFormat("y-M-d");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fileDetail.fileName),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,15),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).disabledColor),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0,20,0,10),
                            child: Icon(Icons.file_copy,size: 100,),
                          ),
                          Text(fileDetail.fileName,textScaler: const TextScaler.linear(1.5),)
                        ],
                      ),
                    ),
                ),
              ),
            ),
            commonCard(context: context, title: "Details",
                child: Text(fileDetail.details)
            ),
            commonCard(context: context, title: "Basic Info",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("课程名：${fileDetail.kcm??"None"}"),
                    Text("课程号：${fileDetail.kch??"None"}"),
                    Text("文件大小：${getFileSizeStr(fileDetail.fileSize)}"),
                    Text("上传日期${dateFormat.format(fileDetail.uploadTime)}"),
                  ],
                )
            ),
            commonCard(context: context, title: "Rating", child:
                Center(
                  child: Builder(builder: (builder){
                    if(fileDetail.rating<0){
                      return const Text("暂无评分");
                    }else{
                      return  Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StarScore(
                              score:fileDetail.rating,
                              star: Star(
                                  fillColor: Colors.yellow,
                                  emptyColor: Colors.grey.withAlpha(88)),
                              tail: Column(
                                children: <Widget>[
                                  const Text("评分"),
                                  Text(fileDetail.rating.toStringAsFixed(2)),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                              child: Text("共${fileDetail.ratingNumber}人评分"),
                            )
                          ],

                        ),
                      );
                    }
                  }),
                ),
              icon: const Text("点击查看评论"),
              onTap: (context){
                Navigator.of(context).push(CupertinoModalPopupRoute(builder: (builder){
                  return _Comments("/comment/${fileDetail.filePointer}",fileDetail,);
                }));
              }

            ),
        
            commonCard(context: context, title: "Uploader",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("上传者：${fileDetail.uploader??"unknown"}"),
                    Text("文件指针：${fileDetail.filePointer}"),
                  ],
                ),
              onTap: (c){
              if(fileDetail.uploader==null){
                return;
              }
                Navigator.of(context).push(CupertinoPageRoute(builder: (builder){

                  return PersonalPage(account: fileDetail.uploader!);
                }));
              }
            ),
            commonCard(context: context,
                title: "Download",
                child: const Text("Tap to download"),
                icon: const Icon(Icons.download),
                onTap: (context){
                  launchUrl(Uri.parse("$base/file/${fileDetail.filePointer}"));
                })
          ],
        ),
      ),
    );
  }
}
class _Comments extends StatefulWidget {
  final FileDetail fileDetail;
  final String url;
  final void Function()? onComment;
  const _Comments(this.url,this.fileDetail,{super.key,this.onComment});

  @override
  State<_Comments> createState() => _CommentsState();
}

class _CommentsState extends State<_Comments> {
  double rating=5;
  String text="";
  void refresh(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comments"),),
      body: LoadCommentPage(widget.url),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context,barrierDismissible:true,builder: (builder){
            return AlertDialog(
              title: const Text("Comment"),
              content: _CommentComponent(rating,(v){rating=v;},text,(v){text=v;}),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(builder).pop();
                }, child: const Text("Cancel")),
                TextButton(onPressed: ()async{
                  //send rating
                  await httpPost("/rate?file_pointer=${widget.fileDetail.filePointer}&rating=$rating");

                  if(text.trim().isNotEmpty){
                    if (kDebugMode) {
                      print("comment");
                    }
                    var parameter={
                      "account":myAccount,
                      "file_pointer":widget.fileDetail.filePointer,
                      "text":text,
                      "rating":rating
                    };
                    await httpPostWithForm("/comment", parameter);
                  }
                  await Future.delayed(Duration(milliseconds: 20));
                  Navigator.of(builder).pop();
                  if(widget.onComment!=null){
                    widget.onComment!();
                  }
                  refresh();

                }, child: const Text("Comment"))
              ],
            );
          });
        },

      ),
    );
  }
}
class _CommentComponent extends StatefulWidget {
  final void Function(double value) valueSetter;
  final double rating0;
  final void Function(String value) textSetter;
  final String text0;
  const _CommentComponent(this.rating0,this.valueSetter,  this.text0,this.textSetter,{super.key,  });

  @override
  State<_CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<_CommentComponent> {
  late double rating;
  TextEditingController controller=TextEditingController();
  @override
  void initState() {

    super.initState();
    rating=widget.rating0;
    controller.text=widget.text0;

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomRating(
              score: rating,
                onRating: (s) {
                widget.valueSetter(s);
              setState(() {
                rating=s;
              });
            }),
            Text(rating.toStringAsFixed(1))
          ],
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(icon: Icon(Icons.brush),hintText: "写评论"),
          onChanged: widget.textSetter,
        )

      ],
    );
  }
}



