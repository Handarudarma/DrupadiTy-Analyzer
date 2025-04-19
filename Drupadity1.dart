import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'analapk',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  HomeScreen({required this.isDarkMode, required this.onThemeToggle});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String mobsfApiKey = 'YOUR_API_KEY';
  final String mobsfUrl = 'http://YOUR_SERVER_IP:8000/api/v1/';

  List<Map<String, dynamic>> scanHistory = [];
  bool isLoading = false;

  Future<void> analyzeAPK() async {
    setState(() {
      isLoading = true;
    });

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'],
    );

    if (pickedFile == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final file = File(pickedFile.files.single.path!);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${mobsfUrl}upload'),
    );
    request.headers['Authorization'] = mobsfApiKey;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var uploadResponse = await request.send();

    if (uploadResponse.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final uploadBody = await http.Response.fromStream(uploadResponse);
    final uploadData = jsonDecode(uploadBody.body);
    final hash = uploadData['hash'];

    final scanResponse = await http.post(
      Uri.parse('${mobsfUrl}scan'),
      headers: {
        'Authorization': mobsfApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'hash': hash}),
    );

    if (scanResponse.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final scanData = jsonDecode(scanResponse.body);

    setState(() {
      scanHistory.insert(0, {
        'package': scanData['package_name'],
        'permissions': scanData['permissions'],
        'hash': hash,
      });
      isLoading = false;
    });
  }

  Future<void> downloadPdf(String hash) async {
    final response = await http.post(
      Uri.parse('${mobsfUrl}download_pdf'),
      headers: {
        'Authorization': mobsfApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'hash': hash}),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/report_$hash.pdf');
      await file.writeAsBytes(bytes);
      OpenFilex.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drupadity Analyzer'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      drawer: AppDrawer(scanHistory: scanHistory, downloadPdf: downloadPdf),
      body: Center( // Center the content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.android, size: 100, color: Colors.teal),
              SizedBox(height: 20),
              Text('Only APK'),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.upload_file),
                label: Text('Upload & Analyze'),
                onPressed: analyzeAPK,
              ),
              SizedBox(height: 20),
              if (isLoading) LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> scanHistory;
  final Future<void> Function(String) downloadPdf;

  AppDrawer({required this.scanHistory, required this.downloadPdf});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    history: scanHistory,
                    downloadPdf: downloadPdf,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final Future<void> Function(String) downloadPdf;

  HistoryPage({required this.history, required this.downloadPdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: history.isEmpty
          ? Center(child: Text('Belum ada riwayat analisis.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['package'] ?? 'Unknown'),
                    subtitle: Text(
                      'Permissions: ${(item['permissions'] as List<dynamic>).join(', ')}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () => downloadPdf(item['hash']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(child: Text('Dibuat oleh Drupadity TEAM')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Pengaturan aplikasi.')),
    );
  }
}
