import 'dart:io';

import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvUtil {
  static Future<String> get _localPath async {
    Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    return downloadsDirectory.absolute.path;
  }

  static Future<File> localFile({String filename}) async {
    final path = await _localPath;
    return File('$path/$filename.csv').create();
  }

  static saveCsv({List<List<dynamic>> rows, String filename}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    File f = await localFile(filename: filename);
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Fluttertoast.showToast(msg: "Downloaded Successfully.");
  }
}
