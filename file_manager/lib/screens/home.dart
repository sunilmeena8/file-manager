import 'dart:io';
import 'package:file_manager/screens/contacts.dart';
import 'package:file_manager/widgets/file_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'folders.dart';
import 'package:file_manager/utils/filesystem_utils.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<Directory> storages = List();
  List<FileSystemEntity> recentFiles  = List();
  
  getStorageList() async {
    storages = await getExternalStorageDirectories();
    setState(() {
      
    });
  }

  getRecentFiles() async{
    recentFiles = await FileSystemUtils.getRecentFiles(showHidden: false);
 setState(() {
      
    });
    
  }

setContactPermissions() async{
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if(permission != PermissionStatus.granted){
      PermissionHandler().requestPermissions([PermissionGroup.contacts]).then((v){
      }).then((v) async{
        PermissionStatus permission1 = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
        if(permission1 == PermissionStatus.granted){
          
          
        }
      });
    }else{
      
    }
} 
setPermissions() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if(permission != PermissionStatus.granted){
      PermissionHandler().requestPermissions([PermissionGroup.storage]).then((v){
      }).then((v) async{
        PermissionStatus permission1 = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
        if(permission1 == PermissionStatus.granted){
          setContactPermissions();
          getStorageList();
          getRecentFiles();
        }
      });
    }else{
      getStorageList();
      getRecentFiles();
    }
  }


  @override
  void initState() {
     setPermissions();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context){   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
              onRefresh: ()=> setPermissions(),
              child: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 20),
          
          children: <Widget> [
            SizedBox(height: 20,),
            
            Text("Storage Devices",style: TextStyle(fontSize: 20),),
            storages==[]
            ? Center(
                child: CircularProgressIndicator(),
            )
            :ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: storages.length,
              itemBuilder: (BuildContext context,int index){
                FileSystemEntity item = storages[index];
                String path = item.path.split('Android')[0];

                return ListTile(
                  onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Folder(
                              title: index == 0
                                  ? "Internal Storage"
                                  : "SD Card",
                              path: path,
                            ),
                          ),
                        );
                      },
                  contentPadding: EdgeInsets.only(right: 20),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            index == 0
                                ? Feather.smartphone
                                : Icons.sd_storage,
                            color: index == 0
                                ? Colors.lightBlue
                                : Colors.orange,
                          ),
                        ),
                      ),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            index == 0
                                ? "Internal Storage"
                                : "SD Card",
                          ),
                        ],
                    ),
                           
                );
              },
            ),
            SizedBox(height: 30,),
            Text(
                  "Recent Files".toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 10,),
                ListView.builder(
                  padding: EdgeInsets.only(right: 20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recentFiles.length > 10?10:recentFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    FileSystemEntity file = recentFiles[index];
                    return file.existsSync()?FileItem(
                      file: file,
                    ):SizedBox();
                  },
                ),
            RaisedButton(
            onPressed: (){
              Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Contacts(),
                          ),
                        );
            } ,
            child: const Text('Contacts', style: TextStyle(fontSize: 20)),
          ),
            SizedBox(height: 10,),
            
          ]

        ),

      )
      )
    );
  }
}