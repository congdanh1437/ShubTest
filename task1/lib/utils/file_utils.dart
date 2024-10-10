// lib/utils/file_utils.dart
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';

Future<List<Map<String, dynamic>>> readExcelFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Map<String, dynamic>> extractedData = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!.rows;
      for (var row in sheet) {
        Map<String, dynamic> rowData = {};
        for (var cell in row) {
          rowData[cell.toString()] = cell?.value;
        }
        extractedData.add(rowData);
      }
    }
    return extractedData;
  } else {
    throw Exception("File not selected");
  }
}
