

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:shared_resource/lib/assets.dart';
import 'package:shared_resource/lib/network.dart';
import 'package:shared_resource/lib/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.upload_My_File),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: fileNameC,decoration: InputDecoration(labelText: filePath==null?AppLocalizations.of(context)!.choose_file:AppLocalizations.of(context)!.filename,icon: Icon(Icons.file_copy)),readOnly: filePath==null,),
            TextField(controller:kcmC,decoration: InputDecoration(labelText: AppLocalizations.of(context)!.course_name,icon: Icon(Icons.book)),),
            TextField(controller:kchC,decoration: InputDecoration(labelText: AppLocalizations.of(context)!.course_id,icon: Icon(Icons.numbers)),),
            TextField(controller:detailC,decoration: InputDecoration(labelText: AppLocalizations.of(context)!.detail,icon: Icon(Icons.account_tree)),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton(onPressed: ()async{
                const XTypeGroup typeGroup = XTypeGroup();
                final XFile? file =await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

                setState(() {
                  fileNameOrigin=file?.name;
                });

                if(fileNameOrigin!=null){
                  var dotIndex=fileNameOrigin!.lastIndexOf(".");
                  if(dotIndex==-1){
                    await showInfoDialog(context: context,title: AppLocalizations.of(context)!.error,content: AppLocalizations.of(context)!.suffix);
                    return;
                  }
                  filePath=file?.path;
                  suffix=fileNameOrigin!.substring(dotIndex);
                  var nameWithoutSuffix=fileNameOrigin!.substring(0,dotIndex);

                  setState(() {
                    fileNameC.text=nameWithoutSuffix;
                  });




                  }


              }, child: Text(fileNameOrigin??AppLocalizations.of(context)!.choose_a_file)),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: ()async{
                bool done=false;
                //check
                if(filePath==null|| filePath!.isEmpty||fileNameC.text.isEmpty||detailC.text.isEmpty||suffix==null||suffix!.isEmpty){
                  await showInfoDialog(context: context,title: AppLocalizations.of(context)!.warn,content: AppLocalizations.of(context)!.not_complete);
                  return;
                }
                await showLoadingDialog(context: context, func: ()async{
                  await UploadResources(details: detailC.text, fileName: fileNameC.text+suffix!, filePath: filePath!, uploader: myAccount!);
                  done=true;

                },
                onError: ()async{
                  await showInfoDialog(context: context,title: AppLocalizations.of(context)!.error,content: AppLocalizations.of(context)!.error_occur);
                },title: AppLocalizations.of(context)!.uploading
                );
                if(done){
                  if(context.mounted){
                    await showInfoDialog(context: context,title: AppLocalizations.of(context)!.success);
                    Navigator.of(context).pop();
                  }

                }
              }, child: Text(AppLocalizations.of(context)!.upload,textScaler: TextScaler.linear(1.1),style: TextStyle(color: Colors.lightBlue),)),
            )
          ],
        ),
      ),
    );
  }
}
