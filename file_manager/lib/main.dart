import 'dart:io';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/home.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:file_manager/screens/lock_screen.dart';

void main() => runApp(AppLock(
    builder: (args) => MyApp(data: args),
    lockScreen: LockScreen(),
    // enabled: false,
  ));

class MyApp extends StatelessWidget {
  final String data;
  const MyApp({Key key, this.data}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Files'),
    );
  }
}
