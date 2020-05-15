import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class Permission{
  checkPermissions() async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if(permission != PermissionStatus.granted){
      return(true);
    }
    else{
      return(false);
    }
  }

  // setPermissions() async {
  //   PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  //   if(permission != PermissionStatus.granted){
  //     PermissionHandler().requestPermissions([PermissionGroup.storage]).then((v){

  //     }).then((v) async{
  //       PermissionStatus permission1 = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  //       if(permission1 == PermissionStatus.granted){
  //         Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //             type: PageTransitionType.rightToLeft,
  //             child: Home(title: 'Files'),
  //           ),
  //         );
          
  //       }
  //     });
  //   }else{
  //     Navigator.pushReplacement(
  //       context,
  //       PageTransition(
  //         type: PageTransitionType.rightToLeft,
  //         child: Home(title: 'Files'),
  //       ),
  //     );
      
  //   }
  // }

}