import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:intl/intl.dart';  // For date formatting

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> _extractedData = [];
  String? startTime;
  String? endTime;
  double totalAmount = 0.0;
  String uploadStatusMessage = ''; // For showing upload status message

  // Function to pick and read the Excel file
  Future<void> pickAndReadExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        // Process each row and store data
        List<Map<String, dynamic>> extractedData = [];
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table]!.rows;
          for (var row in sheet) {
            if (row.isNotEmpty) {
              Map<String, dynamic> rowData = {};
              for (int i = 0; i < row.length; i++) {
                rowData['col$i'] = row[i]?.value;
              }
              extractedData.add(rowData);
            }
          }
        }

        setState(() {
          _extractedData = extractedData;
          uploadStatusMessage = 'Upload Successful!'; // Set upload success message
        });

        // Show a success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File uploaded successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        setState(() {
          uploadStatusMessage = 'File not selected.';
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File not selected!'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      setState(() {
        uploadStatusMessage = 'Error during file upload.';
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error during file upload!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Function to filter data and calculate the total "Thành tiền"
  void filterAndCalculateTotal(String start, String end) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime startTime = dateFormat.parse(start);
    DateTime endTime = dateFormat.parse(end);
    double sum = 0.0;

    for (var row in _extractedData) {
      try {
        // Assuming 'col1' contains date, 'col2' contains time, and 'col8' contains "Thành tiền"
        String datetimeStr = '${row['col1']} ${row['col2']}';

        // Handle empty or null values for date and time
        if (row['col1'] == null || row['col2'] == null) continue; // Skip if date or time is missing

        DateTime transactionTime = dateFormat.parse(datetimeStr);

        // Adjusted condition to include start and end times
        if ((transactionTime.isAfter(startTime) || transactionTime.isAtSameMomentAs(startTime)) &&
            (transactionTime.isBefore(endTime) || transactionTime.isAtSameMomentAs(endTime))) {

          // Remove all commas and convert to a double
          String? amountStr = row['col8']?.toString().replaceAll(',', ''); // Remove all commas
          double? amount = double.tryParse(amountStr ?? '0'); // Convert to double
          if (amount != null) {
            sum += amount;
          }
        }
      } catch (e) {
        print("Error processing row: $e");
      }
    }

    setState(() {
      totalAmount = sum;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndReadExcelFile,
              child: Text('Upload .xlsx File'),
            ),
            Text(uploadStatusMessage),  // Display upload status message
            TextField(
              decoration: InputDecoration(labelText: 'Start Time (dd/MM/yyyy HH:mm:ss)'),
              onChanged: (value) {
                startTime = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'End Time (dd/MM/yyyy HH:mm:ss)'),
              onChanged: (value) {
                endTime = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (startTime != null && endTime != null) {
                  filterAndCalculateTotal(startTime!, endTime!);
                }
              },
              child: Text('Calculate Total "Thành tiền"'),
            ),
            SizedBox(height: 20),
            Text('Total "Thành tiền": $totalAmount VND'),
          ],
        ),
      ),
    );
  }
}
