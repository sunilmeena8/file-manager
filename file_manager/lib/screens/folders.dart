import 'dart:io';

import 'package:core_file_manager/widgets/file_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;
import 'package:core_file_manager/widgets/folder_item.dart';
import 'package:core_file_manager/widgets/custom_alert.dart';

class Folder extends StatefulWidget{
  final String title,path;

  Folder({Key key, this.title,this.path}) : super(key: key);
  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder>{
  List<FileSystemEntity> files= List();
  List<String> paths = List();
  String path;

  getFiles() {
    files = Directory(path).listSync();
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    path = widget.path;
    paths.add(path);
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: (){
              if(paths.length == 1){
                Navigator.pop(context);
              }else{
                paths.removeLast();
                setState(() {
                  path = paths.last;
                });
                getFiles();
              }
            },
          ),
        title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                pathlib.basename(path),
              ),
              Text(
                "$path",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (BuildContext context,int index){
          FileSystemEntity file = files[index];
          List<String> splited = file.path.split('/'); 
          return file.toString().split(":")[0] == "Directory"
          ? FolderItem(
            popTap: (v) async{
                if(v == 0){
                  renameDialog(context, file.path, "dir");
                }else if(v == 1){
                  await Directory(file.path).delete().catchError((e){
                    print(e.toString());
                    
                  });
                  getFiles();
                }
              },
              folder: file,
              tap: (){
                paths.add(file.path);
                setState(() {
                  path = file.path;
                });
                getFiles();
              },
            )
            : FileItem(
              file: file,
              popTap: (v) async{
                if(v == 0){
                  renameDialog(context, file.path, "file");
                }else if(v == 1){
                  await File(file.path).delete().catchError((e){
                    print(e.toString());
                    if(e.toString().contains("Permission denied")){
                      // Provider.of<CoreProvider>(context, listen: false).showToast("Cannot write to this Storage device!");
                    }
                  });
                  getFiles();
                }
              },
            );
        },
      ),
      );
  }
  renameDialog(BuildContext context, String path, String type){
    final TextEditingController name = TextEditingController();
    setState(() {
      name.text = pathlib.basename(path);
    });
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                "Rename Item",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 25),

              TextField(
                controller: name,
                keyboardType: TextInputType.text,
              ),

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 130,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: Theme.of(context).accentColor),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: ()=>Navigator.pop(context),
                      color: Colors.white,
                    ),
                  ),


                  Container(
                    height: 40,
                    width: 130,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "Rename",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async{
                        if(name.text.isNotEmpty){
                          if(type == "file"){
                            if(!File(path.replaceAll(pathlib.basename(path), "")+"${name.text}").existsSync()){
                              await File(path).rename(path.replaceAll(pathlib.basename(path), "")+"${name.text}").catchError((e){
                                print(e.toString());
                                if(e.toString().contains("Permission denied")){
                                  // Provider.of<CoreProvider>(context, listen: false).showToast("Cannot write to this device!");
                                }
                              });
                            }else{
                              // Provider.of<CoreProvider>(context, listen: false).showToast("A File with that name already exists!");
                            }
                          }else{
                            if(Directory(path.replaceAll(pathlib.basename(path), "")+"${name.text}").existsSync()){
                              // Provider.of<CoreProvider>(context, listen: false).showToast("A Folder with that name already exists!");
                            }else{
                              await Directory(path).rename(path.replaceAll(pathlib.basename(path), "")+"${name.text}").catchError((e){
                                print(e.toString());
                                if(e.toString().contains("Permission denied")){
                                  // Provider.of<CoreProvider>(context, listen: false).showToast("Cannot write to this device!");
                                }
                              });
                            }
                          }
                          Navigator.pop(context);
                          getFiles();
                        }
                      },
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}