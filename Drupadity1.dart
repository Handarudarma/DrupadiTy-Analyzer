import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(APKAnalyzerApp());
}

class APKAnalyzerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: APKAnalyzerScreen(),
    );
  }
}

class APKAnalyzerScreen extends StatefulWidget {
  @override
  _APKAnalyzerScreenState createState() => _APKAnalyzerScreenState();
}

class _APKAnalyzerScreenState extends State<APKAnalyzerScreen> {
  Map<String, dynamic>? _analysisResult;
  String? _selectedFilePath;

  Future<void> _pickAPK() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['apk']);
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  Future<void> _uploadAPK() async {
    if (_selectedFilePath == null) return;
    File apkFile = File(_selectedFilePath!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://your-mobsf-ip:8000/api/v1/upload'),
    );
    request.headers['Authorization'] = 'your_api_key';
    request.files.add(await http.MultipartFile.fromPath('file', apkFile.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      setState(() {
        _analysisResult = jsonDecode(responseData);
      });
    } else {
      setState(() {
        _analysisResult = null;
      });
    }
  }

  Future<void> _generatePDF() async {
    if (_analysisResult == null) return;
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("APK Analysis Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text("App Name: ${_analysisResult!['app_name'] ?? 'Unknown'}"),
                pw.Text("Package: ${_analysisResult!['package_name'] ?? 'Unknown'}"),
                pw.Text("Security Score: ${_analysisResult!['security_score'] ?? 'Unknown'}"),
                pw.Text("Risk Level: ${_analysisResult!['risk_level'] ?? 'Unknown'}"),
                pw.SizedBox(height: 10),
                pw.Text("Permissions:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: (_analysisResult!['permissions'] as List<dynamic>?)?.join(", ") ?? "None"),
                pw.SizedBox(height: 10),
                pw.Text("Trackers Detected:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: (_analysisResult!['trackers'] as List<dynamic>?)?.join(", ") ?? "None"),
                pw.SizedBox(height: 10),
                pw.Text("Malware Analysis:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(_analysisResult!['malware_analysis'] ?? "No Issues Detected"),
              ],
            ),
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/APK_Analysis_Report.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF Saved: ${file.path}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( 'DrupadiTy Analyzer'), backgroundColor: Colors.green,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickAPK,
              child: Text('Pick APK'),
            ),
            SizedBox(height: 10),
            _selectedFilePath != null
                ? Text('Selected: $_selectedFilePath')
                : Text('No APK selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadAPK,
              child: Text('Analyze APK'),
            ),
            SizedBox(height: 20),
            _analysisResult != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("App Name: ${_analysisResult!['app_name'] ?? 'Unknown'}"),
                          Text("Package: ${_analysisResult!['package_name'] ?? 'Unknown'}"),
                          Text("Security Score: ${_analysisResult!['security_score'] ?? 'Unknown'}"),
                          Text("Risk Level: ${_analysisResult!['risk_level'] ?? 'Unknown'}"),
                          SizedBox(height: 10),
                          Text("Permissions:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text((_analysisResult!['permissions'] as List<dynamic>?)?.join(", ") ?? "None"),
                          SizedBox(height: 10),
                          Text("Trackers Detected:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text((_analysisResult!['trackers'] as List<dynamic>?)?.join(", ") ?? "None"),
                          SizedBox(height: 10),
                          Text("Malware Analysis:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_analysisResult!['malware_analysis'] ?? "No Issues Detected"),
                        ],
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            _analysisResult != null
                ? ElevatedButton(
                    onPressed: _generatePDF,
                    child: Text('Save as PDF'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
