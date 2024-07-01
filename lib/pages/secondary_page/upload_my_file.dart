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
  String? fileNameOrigin;
  TextEditingController kcmC=TextEditingController();
  TextEditingController kchC=TextEditingController();
  TextEditingController fileNameC=TextEditingController();
  TextEditingController detailC=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload My File"),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: fileNameC,decoration: InputDecoration(labelText: "文件名",icon: Icon(Icons.file_copy)),),
            TextField(controller:kcmC,decoration: InputDecoration(labelText: "课程名(可选)",icon: Icon(Icons.book)),),
            TextField(controller:kchC,decoration: InputDecoration(labelText: "课程号(可选)",icon: Icon(Icons.numbers)),),
            TextField(controller:detailC,decoration: InputDecoration(labelText: "详细信息",icon: Icon(Icons.details)),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton(onPressed: ()async{
                const XTypeGroup typeGroup = XTypeGroup();
                final XFile? file =
                    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                setState(() {
                  filePath=file?.path;
                  fileNameOrigin=file?.name;
                  if(fileNameC.text.isEmpty){
                    fileNameC.text=fileNameOrigin??"";
                  }
                });
              }, child: Text(fileNameOrigin??"Choose a File")),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: ()async{
                //check
                if(filePath==null|| filePath!.isEmpty||fileNameC.text.isEmpty||detailC.text.isEmpty){
                  await showInfoDialog(context: context,content: "资料不完善，无法提交");
                  return;
                }
                UploadResources(details: detailC.text, fileName: fileNameC.text, filePath: filePath!, uploader: myAccount!);
              }, child: Text("Upload",textScaler: TextScaler.linear(1.1),style: TextStyle(color: Colors.red),)),
            )
          ],
        ),
      ),
    );
  }
}
