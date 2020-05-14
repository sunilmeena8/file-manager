import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'folders.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<Directory> storages;
  
  getStorageList() async {
    storages = await getExternalStorageDirectories();
    setState(() {
      
    });
    
  }

  @override
  void initState() {
        
    super.initState();
    getStorageList();
  }

  @override
  Widget build(BuildContext context){    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 20),
          
          children: <Widget> [
            SizedBox(height: 20,),
            
            Text("Storage Devices",style: TextStyle(fontSize: 20),),
            storages==null
            ? Center(
                child: CircularProgressIndicator(),
            )
            :ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
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
            )
            
          ]

        ),

      )
    );
  }
}