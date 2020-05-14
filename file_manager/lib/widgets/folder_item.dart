import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'folder_popup.dart';

class FolderItem extends StatelessWidget{
  final FileSystemEntity folder;
  final Function tap;
  final Function popTap;

  FolderItem({
    Key key,
    @required this.folder,
    @required this.tap,
    @required this.popTap,
  }): super(key:key);

  @override
  Widget build(BuildContext context){
    return ListTile(
      onTap: tap,
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        height: 40,
        width: 40,
        child: Center(
          child: Icon(
            Feather.folder,
          ),
        ),
      ),
      title: Text(
        "${basename(folder.path)}",
        style: TextStyle(
          fontSize: 14,
        ),
        maxLines: 2,
      ),
      trailing: popTap == null
          ? null
          : FolderPopup(path: folder.path, popTap: popTap),
    );
  }

}



