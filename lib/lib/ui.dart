import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/star.dart';
import 'package:flutter_star/star_score.dart';
import 'package:intl/intl.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/pages/secondary_page/personal_page.dart';
import 'package:shared_resource/pages/secondary_page/resource_detail.dart';

Future showInfoDialog(
    {required BuildContext context,
    String title = "",
    String content = "",
    String button = "OK"}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}

class ContextWrapper {
  BuildContext? context;
}

Future showLoadingDialog(
    {required BuildContext context,
    String title = "Loading",
    required Future Function() func,
    String button = "Cancel",
    void Function()? onError}) {
  ContextWrapper contextWrapper = ContextWrapper();
  var future = func().then((v) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (contextWrapper.context != null) {
        Navigator.pop(contextWrapper.context!);
      }
    });
  }).onError((error, stackTrace) {
    //await Future.delayed(const Duration(microseconds: 5000));
    if (contextWrapper.context != null) {
      Navigator.pop(contextWrapper.context!);
    }

    if (onError != null) {
      onError();
    }
  });
  var myCancelableFuture = CancelableOperation.fromFuture(
    future,
  );

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        contextWrapper.context = context;
        return AlertDialog(
          title: Text(title),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  myCancelableFuture.cancel();
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}

var day2Str = <String>["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

String time2StringConverter(int time) {
  int b = 1 ~/ 2;
  var day = (time ~/ (24 * 60));
  time %= 24 * 60;
  int hour = time ~/ 60;
  var minute = time % 60;

  return "${day2Str[day]} ${hour.toString()}:${minute.toString()}";
}

int string2TimeConverter(int week, int hour, int minute) {
  bool flag = 0 <= week &&
      week <= 7 &&
      0 <= hour &&
      hour < 60 &&
      0 <= minute &&
      minute < 60;
  if (!flag) {
    throw Exception("invalid time");
  }
  return (week * 24 + hour) * 60 + minute;
}

({int day, int hour, int minute}) parseIntTime(int time) {
  var day = (time ~/ (24 * 60));
  time %= 24 * 60;
  var hour = time ~/ 60;
  var minute = time % 60;
  return (
    day: day,
    hour: hour,
    minute: minute,
  );
}

Widget titleText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Text(
      text,
      textScaler: const TextScaler.linear(1.3),
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}

const Widget empty = Text("");

Widget basicCard(
    {required BuildContext context,
    required Widget? child,
    void Function(BuildContext context)? onTap}) {
  Widget? realChild;
  if (onTap == null) {
    realChild = child;
  } else {
    realChild = InkWell(
        highlightColor: Colors.transparent,
        // 透明色
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          onTap(context);
        },
        child: child);
  }
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
        alignment: Alignment.topLeft,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          color: Theme.of(context).colorScheme.secondaryContainer,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), //color of shadow
              spreadRadius: 0.1, //spread radius
              blurRadius: 10, // blur radius
              //offset: Offset(0, 2), // changes position of shadow
              //first parameter of offset is left-right
              //second parameter is top to down
            )
          ],
        ),
        width: double.infinity,
        child: realChild),
  );
}

Widget commonCard(
    {required BuildContext context,
    required String title,
    required Widget? child,
    Widget? icon,
    void Function(BuildContext context)? onTap}) {
  return basicCard(
      onTap: onTap,
      context: context,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [titleText(title), icon ?? empty],
              ),
              child ?? Container()
            ],
          )));
}

Widget loading() {
  return const Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: CircularProgressIndicator(),
      ));
}

class FileDetail {
  late final String? kcm;
  late final String? kch;
  final String details;
  final String fileName;
  final int fileSize;
  final int filePointer;
  late final DateTime uploadTime;
  final double rating;
  final int ratingNumber;
  final String? uploader;

  FileDetail({
    required this.details,
    required this.fileName,
    required this.fileSize,
    required this.filePointer,
    required int uploadTime,
    required this.rating,
    required this.ratingNumber,
    this.uploader,
    String? kcm,
    String? kch,
  }) {
    this.uploadTime = DateTime.fromMillisecondsSinceEpoch(uploadTime * 1000);
    if(kcm==null||kcm.isEmpty){
      this.kcm=null;
    }else{
      this.kcm=kcm;
    }
    if(kch==null||kch.isEmpty){
      this.kch=null;
    }else{
      this.kch=kch;
    }
  }
}

class CommentDetail {
  final String account;
  final int filePointer;
  late final DateTime timestamp;
  final String text;
  final double rating;
  final String? fileName;

  CommentDetail(
      {required this.account,
      required this.filePointer,
      required int timestamp,
      required this.fileName,
      required this.text,
      required this.rating}) {
    this.timestamp = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}

class FileDetailCard extends StatefulWidget {
  final FileDetail fileDetail;

  const FileDetailCard(
    this.fileDetail, {
    super.key,
  });

  @override
  State<FileDetailCard> createState() => _FileDetailCardState();
}

final DateFormat dateFormat = DateFormat("y-M-d");

class _FileDetailCardState extends State<FileDetailCard> {
  late FileDetail fileDetail;

  @override
  void initState() {
    super.initState();
    fileDetail = widget.fileDetail;
  }

  @override
  Widget build(BuildContext context) {
    return commonCard(
        context: context,
        title: fileDetail.fileName,
        child: Wrap(
          spacing: 5,
          children: [
            fileDetail.kcm == null
                ? Container()
                : Text("课程名：${fileDetail.kcm}"),
            fileDetail.kch == null
                ? Container()
                : Text("课程号：${fileDetail.kch}"),
            Text("详情：${fileDetail.details}"),
            Text("文件大小：${getFileSizeStr(fileDetail.fileSize)}"),
            Text("Uploader: ${fileDetail.uploader}"),
            Text("上传时间：${dateFormat.format(fileDetail.uploadTime)}")
          ],
        ),
        onTap: (context) {
          Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
            return FileDetailPage(fileDetail);
          }));
        });
  }
}

String getFileSizeStr(int byte) {
  if (byte < 1024) {
    return "$byte B";
  }
  byte=byte >> 10;
  if (byte < 1024) {
    return "$byte KB";
  }
  byte=byte >> 10;
  if (byte < 1024) {
    return "$byte MB";
  }
  byte=byte >> 10;
  return "$byte GB";
}

class CommentDetailCard extends StatelessWidget {
  final CommentDetail detail;
  final void Function()? onTap;

  const CommentDetailCard(this.detail, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return commonCard(
        context: context,
        title: "${detail.account} says",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.text),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("File: ${detail.fileName ?? ""}"),
                Text(dateFormat.format(detail.timestamp))
              ],
            )
          ],
        ),
        onTap: (context) {
          if (onTap == null) {
            Navigator.of(context).push(CupertinoPageRoute(builder: (builder) {
              return PersonalPage(account: detail.account);
            }));
          } else {
            onTap!();
          }
        },
        icon: StarScore(
          score: detail.rating,
          star: Star(
              fillColor: Colors.yellow, emptyColor: Colors.grey.withAlpha(88)),
        ));
  }
}

class LoadCommentPage extends StatefulWidget {
  final String url;
  final bool isShowFilePage;

  const LoadCommentPage(this.url, {super.key, this.isShowFilePage = false});

  @override
  State<LoadCommentPage> createState() => _LoadCommentPageState();
}

class _LoadCommentPageState extends State<LoadCommentPage> {
  late List<CommentDetail> comments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCommentDetails(widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          }
          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("An error occurred, press to reload"),
              ),
            );
          }
          comments = snapshot.data!;
          if (comments.isEmpty) {
            return const Center(
              child: Text("暂无"),
            );
          }
          var children = <Widget>[];
          for (var i in comments) {
            children.add(CommentDetailCard(
              i,
              onTap: widget.isShowFilePage
                  ? () async {
                      FileDetail? fileDetail;
                      await showLoadingDialog(
                          context: context,
                          func: () async {
                            fileDetail = await getOneFileDetail(
                                "/file_detail/${i.filePointer}");
                          },onError: (){
                            showInfoDialog(context: context,title: "Error");
                      });
                      if(fileDetail!=null){
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (builder) {
                          return FileDetailPage(fileDetail!);
                        }));
                      }
                    }
                  : null,
            ));
          }
          return SingleChildScrollView(
            child: Column(
              children: children,
            ),
          );
        });
  }
}

class LoadFilesPage extends StatefulWidget {
  final String url;

  const LoadFilesPage(this.url, {super.key});

  @override
  State<LoadFilesPage> createState() => _LoadFilesPageState();
}

class _LoadFilesPageState extends State<LoadFilesPage> {
  late List<FileDetail> files;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFileDetails(widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          }
          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("An error occurred, press to reload"),
              ),
            );
          }
          files = snapshot.data!;
          if (files.isEmpty) {
            return const Center(
              child: Text("暂无"),
            );
          }
          var children = <Widget>[];
          for (var i in files) {
            children.add(FileDetailCard(i));
          }
          return Column(
              children: children,

          );
        });
  }
}
