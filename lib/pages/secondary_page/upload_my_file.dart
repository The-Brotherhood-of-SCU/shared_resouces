

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/lib/ui.dart';

class UploadMyFilePage extends StatefulWidget {
  const UploadMyFilePage({super.key});

  @override
  State<UploadMyFilePage> createState() => _UploadMyFilePageState();
}

class _UploadMyFilePageState extends State<UploadMyFilePage> {
  String? filePath;
  String? suffix;
  String? fileNameOrigin;
  TextEditingController kcmC=TextEditingController();
  TextEditingController kchC=TextEditingController();
  TextEditingController fileNameC=TextEditingController();
  TextEditingController detailC=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload My File"),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: fileNameC,decoration: const InputDecoration(labelText: "文件名",icon: Icon(Icons.file_copy)),),
            TextField(controller:kcmC,decoration: const InputDecoration(labelText: "课程名(可选)",icon: Icon(Icons.book)),),
            TextField(controller:kchC,decoration: const InputDecoration(labelText: "课程号(可选)",icon: Icon(Icons.numbers)),),
            TextField(controller:detailC,decoration: const InputDecoration(labelText: "详细信息",icon: Icon(Icons.details)),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton(onPressed: ()async{
                const XTypeGroup typeGroup = XTypeGroup();
                final XFile? file =await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

                fileNameOrigin=file?.name;
                if(fileNameOrigin!=null){
                  var dotIndex=fileNameOrigin!.lastIndexOf(".");
                  if(dotIndex==-1){
                    await showInfoDialog(context: context,title: "Error",content: "文件没有后缀名");
                    return;
                  }
                  filePath=file?.path;
                  suffix=fileNameOrigin!.substring(dotIndex);
                  var nameWithoutSuffix=fileNameOrigin!.substring(0,dotIndex);

                  if(fileNameC.text.isEmpty){
                    setState(() {
                      fileNameC.text=nameWithoutSuffix;
                    });

                  }


                  }


              }, child: Text(fileNameOrigin??"Choose a File")),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: ()async{
                bool done=false;
                //check
                if(filePath==null|| filePath!.isEmpty||fileNameC.text.isEmpty||detailC.text.isEmpty||suffix==null||suffix!.isEmpty){
                  await showInfoDialog(context: context,title: "Warn",content: "资料不完善，无法提交");
                  return;
                }
                await showLoadingDialog(context: context, func: ()async{
                  await UploadResources(details: detailC.text, fileName: fileNameC.text+suffix!, filePath: filePath!, uploader: myAccount!);
                  done=true;

                },
                onError: ()async{
                  await showInfoDialog(context: context,title: "Error",content: "An error occurred");
                },title: "Uploading"
                );
                if(done){
                  if(context.mounted){
                    await showInfoDialog(context: context,title: "Success!");
                    Navigator.of(context).pop();
                  }

                }
              }, child: const Text("Upload",textScaler: TextScaler.linear(1.1),style: TextStyle(color: Colors.red),)),
            )
          ],
        ),
      ),
    );
  }
}
