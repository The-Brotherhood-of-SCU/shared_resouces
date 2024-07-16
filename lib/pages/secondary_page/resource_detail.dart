
import 'dart:async';

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class FileDetailPage extends StatefulWidget {
  final FileDetail fileDetail;
  const FileDetailPage(this.fileDetail,{super.key});

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}


class _FileDetailPageState extends State<FileDetailPage> {
  late  FileDetail fileDetail;
  @override
  void initState() {
    super.initState();
    fileDetail=widget.fileDetail;
  }
  Future refresh()async{
    try{
      var result =
          await getOneFileDetail("/file_detail/${fileDetail.filePointer}");
      setState(() {
        fileDetail = result;
      });
    }catch(e){
      await showInfoDialog(context: context,title: AppLocalizations.of(context)!.error,content: e.toString());
    }
  }
  static final DateFormat dateFormat = DateFormat("y-M-d");
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
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
              commonCard(context: context, title: AppLocalizations.of(context)!.details,
                  child: Text(fileDetail.details)
              ),
              commonCard(context: context, title: AppLocalizations.of(context)!.b_i,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${AppLocalizations.of(context)!.name}：${fileDetail.kcm??"None"}"),
                      Text("${AppLocalizations.of(context)!.id}：${fileDetail.kch??"None"}"),
                      Text("${AppLocalizations.of(context)!.f}：${getFileSizeStr(fileDetail.fileSize)}"),
                      Text("${AppLocalizations.of(context)!.date}${dateFormat.format(fileDetail.uploadTime)}"),
                    ],
                  )
              ),
              commonCard(context: context, title: AppLocalizations.of(context)!.rating, child:
                  Center(
                    child: Builder(builder: (builder){
                      if(fileDetail.rating<0){
                        return  Text(AppLocalizations.of(context)!.n_r);
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
                                     Text(AppLocalizations.of(context)!.rating),
                                    Text(fileDetail.rating.toStringAsFixed(2)),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                                child: Text("${fileDetail.ratingNumber}"+AppLocalizations.of(context)!.lc),
                              )
                            ],

                          ),
                        );
                      }
                    }),
                  ),
                icon:  Text(AppLocalizations.of(context)!.l_c),
                onTap: (context){
                  Navigator.of(context).push(CupertinoModalPopupRoute(builder: (builder){
                    return _Comments("/comment/${fileDetail.filePointer}",fileDetail,onComment: refresh,);
                  }));
                }

              ),

              commonCard(context: context, title: AppLocalizations.of(context)!.uploader,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.uploader+"：${fileDetail.uploader??"unknown"}"),
                      Text(AppLocalizations.of(context)!.f_p+"：${fileDetail.filePointer}"),
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
                  title: AppLocalizations.of(context)!.download,
                  child:  Text(AppLocalizations.of(context)!.tap),
                  icon: const Icon(Icons.download),
                  onTap: (context){
                    launchUrl(Uri.parse("$base/file/${fileDetail.filePointer}"));
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: TextButton(child: Text("Delete",style: TextStyle(color: Colors.red),), onPressed: ()async {
                  var result=await showDeleteConfirmDialog1();
                  if(result==true){
                    httpGet("/delete/${fileDetail.filePointer}");
                    Navigator.of(context).pop();
                  }

                },),),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool?> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text("DELETE"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
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
      appBar: AppBar(title:  Text(AppLocalizations.of(context)!.comments),),
      body: LoadCommentPage(widget.url),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context,barrierDismissible:true,builder: (builder){
            return AlertDialog(
              title:  Text(AppLocalizations.of(context)!.comments),
              content: _CommentComponent(rating,(v){rating=v;},text,(v){text=v;}),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(builder).pop();
                }, child: Text(AppLocalizations.of(context)!.cancel)),
                TextButton(onPressed: ()async{
                  //send rating
                  await httpPost("/rate?file_pointer=${widget.fileDetail.filePointer}&rating=$rating");

                  if(text.trim().isNotEmpty){
                    if (kDebugMode) {
                      print(AppLocalizations.of(context)!.comments);
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

                }, child:  Text(AppLocalizations.of(context)!.comments))
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
          decoration: InputDecoration(icon: Icon(Icons.brush),hintText: AppLocalizations.of(context)!.haha),
          onChanged: widget.textSetter,
        )

      ],
    );
  }
}



