
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemUtils {

  static Future<List<Directory>> getStorageList() async {
    List<Directory> paths = await getExternalStorageDirectories();
    List<Directory> filteredPaths = List<Directory>();
    for (Directory dir in paths) {
      filteredPaths
          .add(removeDataDirectory(dir.path));
    }
    return filteredPaths;
  }

  static Directory removeDataDirectory(String path){
    return Directory(path.split("Android")[0]);
  }

  static Future<List<FileSystemEntity>> getAllFiles({bool showHidden}) async{
    List<Directory> storages = await getStorageList();
    List<FileSystemEntity> files = List<FileSystemEntity>();
    for (Directory dir in storages) {
      files.addAll(await getAllFilesInPath(dir.path, showHidden: showHidden));
    }
    return files;
  }

  static Future<List<FileSystemEntity>> getFilesInPath(String path) async{
    Directory dir = Directory(path);
    return dir.listSync();
  }

  static Future<List<FileSystemEntity>> getRecentFiles({bool showHidden}) async{
    List<FileSystemEntity> files = await getAllFiles(showHidden: showHidden);
    files.sort((a, b) => File(a.path).lastAccessedSync().compareTo(File(b.path).lastAccessedSync()));
    return files.reversed.toList();
  }

  /// Get all files
  static Future<List<FileSystemEntity>> getAllFilesInPath(String path,{bool showHidden}) async{
    List<FileSystemEntity> files = List<FileSystemEntity>();
    Directory d = Directory(path);
    List<FileSystemEntity> l = d.listSync();
    for (FileSystemEntity file in l) {
      if(FileSystemEntity.isFileSync(file.path)){
        if(!showHidden){
          if(!basename(file.path).startsWith(".")){
            files.add(file);
          }
        }else{
          files.add(file);
        }
      }else{
        if(!file.path.contains("/storage/emulated/0/Android")){
//          print(file.path);
          if(!showHidden){
            if(!basename(file.path).startsWith(".")){
              files.addAll(await getAllFilesInPath(file.path, showHidden: showHidden));
            }
          }else{
            files.addAll(await getAllFilesInPath(file.path, showHidden: showHidden));
          }
        }
      }
    }
//    print(files);
    return files;
  }

  static List<FileSystemEntity> sortList(List<FileSystemEntity> list, int sort){
    switch (sort){
      case 0:
        if(list.toString().contains("Directory")){
          list
            ..sort((f1, f2) => basename(f1.path).toLowerCase().compareTo(basename(f2.path).toLowerCase()));
          return list..sort((f1, f2) => f1.toString().split(":")[0].toLowerCase().compareTo(f2.toString().split(":")[0].toLowerCase()));
        }else{
          return list
            ..sort((f1, f2) => basename(f1.path).toLowerCase().compareTo(basename(f2.path).toLowerCase()));
        }
        break;

      case 1:
        list.sort((f1, f2) => basename(f1.path).toLowerCase().compareTo(basename(f2.path).toLowerCase()));
        if(list.toString().contains("Directory")){
          list..sort((f1, f2) => f1.toString().split(":")[0].toLowerCase().compareTo(f2.toString().split(":")[0].toLowerCase()));
        }
        return list.reversed.toList();
        break;

      case 2:
        return list
          ..sort((f1, f2)=>FileSystemEntity.isFileSync(f1.path) && FileSystemEntity.isFileSync(f2.path)
              ? File(f1.path).lastModifiedSync().compareTo(File(f2.path).lastModifiedSync())
              : 1);
        break;

      case 3:
        list
          ..sort((f1, f2)=>FileSystemEntity.isFileSync(f1.path) && FileSystemEntity.isFileSync(f2.path)
              ? File(f1.path).lastModifiedSync().compareTo(File(f2.path).lastModifiedSync())
              : 1);
        return list.reversed.toList();
        break;

      case 4:
        list
          ..sort((f1, f2) => FileSystemEntity.isFileSync(f1.path) && FileSystemEntity.isFileSync(f2.path)
              ?File(f1.path).lengthSync().compareTo(File(f2.path).lengthSync())
              :0);
        return list.reversed.toList();
        break;

      case 5:
        return list
          ..sort((f1, f2) => FileSystemEntity.isFileSync(f1.path) && FileSystemEntity.isFileSync(f2.path)
              ?File(f1.path).lengthSync().compareTo(File(f2.path).lengthSync())
              :0);
        break;

      default:
        return list
          ..sort();
    }
  }

}