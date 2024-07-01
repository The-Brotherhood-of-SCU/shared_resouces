import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/star.dart';
import 'package:flutter_star/star_score.dart';
import 'package:intl/intl.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:shared_resource/pages/secondary_page/personal_page.dart';

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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,20,0,10),
                            child: Icon(Icons.file_copy,size: 100,),
                          ),
                          Text(fileDetail.fileName,textScaler: TextScaler.linear(1.5),)
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
                      return Text("暂无评分");
                    }else{
                      return  StarScore(
                        score:fileDetail.rating,
                        star: Star(
                            fillColor: Colors.yellow,
                            emptyColor: Colors.grey.withAlpha(88)),
                        tail: Column(
                          children: <Widget>[
                            Text("评分"),
                            Text(fileDetail.rating.toString()),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              icon: Text("点击查看评论"),
              onTap: (context){
                Navigator.of(context).push(CupertinoModalPopupRoute(builder: (builder){
                  return _Comments("/comment/${fileDetail.filePointer}");
                }));
              }

            ),
        
            commonCard(context: context, title: "Uploader",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("上传者：${fileDetail.uploader}"),
                    Text("文件指针：${fileDetail.filePointer}"),
                  ],
                ),
              onTap: (c){
                Navigator.of(context).push(CupertinoPageRoute(builder: (builder){
                  return PersonalPage(account: fileDetail.uploader);
                }));
              }
            ),
            commonCard(context: context,
                title: "Download",
                child: Text("Tap to download"),
                icon: Icon(Icons.download),
                onTap: (context){
                  //TODO:download
                })
          ],
        ),
      ),
    );
  }
}

class _Comments extends StatelessWidget {
  final String url;
  const _Comments(this.url,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments"),),
      body: LoadCommentPage(url),
    );
  }
}
