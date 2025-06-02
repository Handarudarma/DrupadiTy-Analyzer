import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/firebase_options.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'dart:async'; // Timer
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:xml/xml.dart';
import 'models/permission_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' if (dart.library.io) 'dart:io' as html;
import 'package:open_filex/open_filex.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SecurityAnalyzeApp());
}

class SecurityAnalyzeApp extends StatefulWidget {
  const SecurityAnalyzeApp({super.key});
  
  @override
  SecurityAnalyzeAppState createState() => SecurityAnalyzeAppState();
}

class SecurityAnalyzeAppState extends State<SecurityAnalyzeApp> {
  static final SecurityAnalyzeAppState _instance = SecurityAnalyzeAppState._internal();
  
  factory SecurityAnalyzeAppState() {
    return _instance;
  }
  
  SecurityAnalyzeAppState._internal();
  
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Analyze By Drupadity',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.teal,
              scaffoldBackgroundColor: Colors.black,
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.teal,
              scaffoldBackgroundColor: Colors.white,
            ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/profile': (context) => ProfilePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/setting': (context) => SettingPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/about': (context) => AboutPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      },
    );
  }
}

// Splash Screen Class
class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SplashScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150),
          ],
        ),
      ),
    );
  }
}

// AuthGate dan AppDrawer
class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AuthGate({
  super.key,  
  required this.toggleTheme,
  required this.isDarkMode,
});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String currentPage;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.currentPage,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return Drawer(
      child: Container(
        color: bgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'Guest User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (FirebaseAuth.instance.currentUser?.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: iconColor),
              title: Text('Home', style: TextStyle(color: textColor)),
              selected: currentPage == 'home',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: iconColor),
              title: Text('About', style: TextStyle(color: textColor)),
              selected: currentPage == 'about',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: iconColor),
              title: Text('Setting', style: TextStyle(color: textColor)),
              selected: currentPage == 'setting',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/setting');
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: iconColor),
              title: Text('Profil', style: TextStyle(color: textColor)),
              selected: currentPage == 'profile',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: iconColor),
              title: Text('Logout', style: TextStyle(color: textColor)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

//profil 
class ProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ProfilePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  String _selectedNegara = 'Indonesia';

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: user?.displayName ?? 'Nama tidak tersedia');
    _emailController =
        TextEditingController(text: user?.email ?? 'Email tidak tersedia');
    _noHpController = TextEditingController(text: '+62 812-3456-7890');
    _selectedNegara = 'Indonesia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      drawer: AppDrawer(
        currentPage: 'profile',
        toggleTheme: widget.toggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noHpController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedNegara,
              items: ['Indonesia', 'Malaysia', 'Singapura']
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: null,
              decoration: const InputDecoration(labelText: 'Negara'),
              disabledHint: Text(_selectedNegara),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      toggleTheme: widget.toggleTheme,
                      isDarkMode: widget.isDarkMode,
                      initialName: _nameController.text,
                      initialEmail: _emailController.text,
                      initialNoHp: _noHpController.text,
                      initialNegara: _selectedNegara,
                    ),
                  ),
                );

                if (result != null && mounted) {
                  setState(() {
                    _nameController.text = result['name'];
                    _emailController.text = result['email'];
                    _noHpController.text = result['noHp'];
                    _selectedNegara = result['negara'];
                  });
                }
              },
              child: const Text('Edit Profil'),
            ),
            const SizedBox(height: 16),
            const Text('@Security Analyze By Drupadity',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

//edit profil
class EditProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String initialName;
  final String initialEmail;
  final String initialNoHp;
  final String initialNegara;

  const EditProfilePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.initialName,
    required this.initialEmail,
    required this.initialNoHp,
    required this.initialNegara,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  String _selectedNegara = 'Indonesia';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _noHpController = TextEditingController(text: widget.initialNoHp);
    _selectedNegara = widget.initialNegara;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      drawer: AppDrawer(currentPage: 'edit_profile', toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noHpController,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedNegara,
              items: ['Indonesia', 'Malaysia', 'Singapura']
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedNegara = val!),
              decoration: const InputDecoration(labelText: 'Negara'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'noHp': _noHpController.text,
                  'negara': _selectedNegara,
                });
              },
              child: const Text('Simpan'),
            ),
            const SizedBox(height: 16),
            const Text('@Security Analyze By Drupadity', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

Future<Uint8List?> extractAppIcon(Uint8List apkBytes, String fileName) async {
  try {
    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final apkFile = File('${tempDir.path}/$fileName');
    final extractDir = Directory('${tempDir.path}/extracted_$fileName');
    
    // Write APK bytes to temporary file
    await apkFile.writeAsBytes(apkBytes);
    
    // Create extraction directory
    if (!await extractDir.exists()) {
      await extractDir.create(recursive: true);
    }
    
    // Extract APK
    await ZipFile.extractToDirectory(
      zipFile: apkFile,
      destinationDir: extractDir,
    );
    
    // Read AndroidManifest.xml to get icon name
    final manifestFile = File('${extractDir.path}/AndroidManifest.xml');
    if (!await manifestFile.exists()) {
      throw Exception('AndroidManifest.xml not found');
    }
    
    final manifestContent = await manifestFile.readAsString();
    final manifest = XmlDocument.parse(manifestContent);
    
    // Find application icon attribute
    final application = manifest.findAllElements('application').first;
    final iconAttribute = application.getAttribute('android:icon');
    
    if (iconAttribute == null) {
      throw Exception('Icon attribute not found in manifest');
    }
    
    // Get icon path
    String iconPath = iconAttribute.replaceAll('@', '');
    if (iconPath.startsWith('drawable/')) {
      iconPath = 'res/${iconPath}';
    } else if (iconPath.startsWith('mipmap/')) {
      iconPath = 'res/${iconPath}';
    }
    
    // Try to find the icon file
    final iconFile = File('${extractDir.path}/$iconPath.png');
    if (await iconFile.exists()) {
      final iconBytes = await iconFile.readAsBytes();
      
      // Cleanup
      await apkFile.delete();
      await extractDir.delete(recursive: true);
      
      return iconBytes;
    }
    
    // Cleanup
    await apkFile.delete();
    await extractDir.delete(recursive: true);
    
    return null;
  } catch (e) {
    print('Error extracting app icon: $e');
    return null;
  }
}

Future<void> uploadAndAnalyzeApk(BuildContext context) async {
  final state = SecurityAnalyzeAppState();
  const apiKey = '55ab018480512272a0ef9eb7d471fde09422e956c4e646bdc456ccc25c9f86d2';
  const baseUrl = 'http://145.79.12.167:8000';

  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'],
      withData: true,
    );

    if (result == null || result.files.first.bytes == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file dipilih'))
      );
      return;
    }

    final fileBytes = result.files.first.bytes!;
    final fileName = result.files.first.name;

    // Extract app icon from APK
    final iconBytes = await extractAppIcon(fileBytes, fileName);

    if (!context.mounted) return;
    final progress = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengupload APK...'))
    );

    // Upload APK
    final uri = Uri.parse('$baseUrl/api/v1/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = apiKey
      ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));

    final response = await request.send();
    if (!context.mounted) return;
    progress.close();

    if (response.statusCode != 200) {
      throw Exception('Upload gagal: ${response.statusCode}');
    }

    final respStr = await response.stream.bytesToString();
    final uploadData = jsonDecode(respStr);

    if (uploadData['hash'] == null) {
      throw Exception(uploadData['error'] ?? 'Gagal upload APK');
    }

    final apkHash = uploadData['hash'];

    // Scan APK
    final scanResp = await http.post(
      Uri.parse('$baseUrl/api/v1/scan'),
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'hash=$apkHash',
    );

    // Get detailed JSON report
    final jsonResp = await http.post(
      Uri.parse('$baseUrl/api/v1/report_json'),
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'hash=$apkHash',
    );

    final scanData = jsonDecode(scanResp.body);
    final jsonData = jsonDecode(jsonResp.body);

    // Combine data from scan and detailed JSON report
    final Map<String, dynamic> analysisData = {
      ...Map<String, dynamic>.from(scanData),
      ...Map<String, dynamic>.from(jsonData),
      'file_name': fileName,
      'security_score': jsonData['average_cvss'] ?? 50,
      'tracker_count': jsonData['trackers']?.length ?? 0,
      'total_trackers': 432,
      'app_name': jsonData['app_name'] ?? fileName.split('.').first,
      'permissions': jsonData['permissions'] ?? [],
      'certificate_analysis': jsonData['certificate_analysis'] ?? {},
      'api_analysis': jsonData['android_api'] ?? {},
      'malware_analysis': {
        'result': jsonData['malware_analysis']?['result'] ?? 'unknown',
        'score': jsonData['average_cvss'] ?? 0,
        'detections': jsonData['malware_analysis']?['findings'] ?? [],
      },
      'app_icon': iconBytes,
      'hash': apkHash,
    };

    if (!context.mounted) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          toggleTheme: state.toggleTheme,
          isDarkMode: state.isDarkMode,
          analysisData: analysisData,
        ),
      ),
    );

  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal analisis APK: $e')),
    );
  }
}


//homepage
class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = Colors.teal;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'home', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.android, size: 100, color: iconColor),
                  const SizedBox(height: 20),
                  Text('Only APK', style: TextStyle(color: textColor, fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload & Analyze'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => uploadAndAnalyzeApk(context),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              '@Security Analyze By Drupadity',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}


class ResultPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final Map<String, dynamic> analysisData;

  const ResultPage({
    super.key, 
    required this.toggleTheme, 
    required this.isDarkMode,
    required this.analysisData,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final state = SecurityAnalyzeAppState();

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Info'),
    Tab(text: 'Signer'),
    Tab(text: 'Perm'),
    Tab(text: 'AMAPI'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return InfoPage(isDarkMode: state.isDarkMode, analysisData: widget.analysisData);
      case 1:
        return SignerPage(isDarkMode: state.isDarkMode, analysisData: widget.analysisData);
      case 2:
        return PermissionPage(isDarkMode: state.isDarkMode, analysisData: widget.analysisData);
      case 3:
        return AmApiPage(isDarkMode: state.isDarkMode, analysisData: widget.analysisData);
      default:
        return const Center(child: Text('Tab tidak ditemukan'));
    }
  }

  Future<void> _downloadPdfReport(BuildContext context) async {
    const apiKey = '55ab018480512272a0ef9eb7d471fde09422e956c4e646bdc456ccc25c9f86d2';
    const baseUrl = 'http://145.79.12.167:8000';
    
    try {
      final apkHash = widget.analysisData['hash'];
      if (apkHash == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hash APK tidak ditemukan')),
        );
        return;
      }

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengunduh laporan PDF...')),
      );

      // Get PDF report
      final pdfResp = await http.post(
        Uri.parse('$baseUrl/api/v1/download_pdf'),
        headers: {
          'Authorization': apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'hash=$apkHash',
      );

      if (pdfResp.statusCode != 200) {
        throw Exception('Gagal mengunduh PDF: ${pdfResp.statusCode}');
      }

      // Convert response to Uint8List
      final bytes = pdfResp.bodyBytes;
      
      if (kIsWeb) {
        // Web platform download implementation
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', '${widget.analysisData['file_name']}_report.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Mobile platform download implementation
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${widget.analysisData['file_name']}_report.pdf');
        await file.writeAsBytes(bytes);
        await OpenFilex.open(file.path);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan PDF berhasil diunduh')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh laporan PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tabBarBg = state.isDarkMode ? Colors.grey[900]! : Colors.grey[300]!;
    Color indicatorColor = state.isDarkMode ? Colors.tealAccent : Colors.teal;
    Color textColor = state.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: state.isDarkMode ? Colors.black : Colors.white,
      drawer: AppDrawer(currentPage: 'result', isDarkMode: state.isDarkMode, toggleTheme: state.toggleTheme),
      appBar: AppBar(
        title: const Text('Analysis Results'),
        backgroundColor: Colors.teal,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: tabBarBg,
            child: TabBar(
              controller: _tabController,
              tabs: myTabs,
              indicatorColor: indicatorColor,
              labelColor: textColor,
              unselectedLabelColor: state.isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPdfReport(context),
          ),
          IconButton(
            icon: Icon(state.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: state.toggleTheme,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(myTabs.length, (index) => buildTabContent(index)),
      ),
    );
  }
}

// halaman Info
class InfoPage extends StatelessWidget {
  final bool isDarkMode;
  final Map<String, dynamic> analysisData;

  const InfoPage({super.key, required this.isDarkMode, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardColor,
            elevation: isDarkMode ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (analysisData['app_icon'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            analysisData['app_icon'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.android,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              analysisData['app_name'] ?? 'Unknown App',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Security Score ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  '${analysisData['security_score']}/100',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Trackers Detection ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  '${analysisData['tracker_count']}/${analysisData['total_trackers']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // FILE INFORMATION
          Card(
            color: cardColor,
            elevation: isDarkMode ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FILE INFORMATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('File Name', analysisData['file_name'] ?? 'Unknown'),
                  _buildInfoRow('Size', analysisData['size'] ?? '2.61MB'),
                  _buildInfoRow('MD5', analysisData['md5'] ?? ''),
                  _buildInfoRow('SHA1', analysisData['sha1'] ?? ''),
                  _buildInfoRow('SHA256', analysisData['sha256'] ?? ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // APP INFORMATION
          Card(
            color: cardColor,
            elevation: isDarkMode ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'APP INFORMATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('App Name', analysisData['app_name'] ?? ''),
                  _buildInfoRow('Package Name', analysisData['package_name'] ?? ''),
                  _buildInfoRow('Main Activity', analysisData['main_activity'] ?? ''),
                  _buildInfoRow('Target SDK', analysisData['target_sdk'] ?? ''),
                  _buildInfoRow('Min SDK', analysisData['min_sdk'] ?? ''),
                  _buildInfoRow('Android Version Name', analysisData['version_name'] ?? ''),
                  _buildInfoRow('Android Version Code', analysisData['version_code']?.toString() ?? ''),
                ],
              ),
            ),
          ),

          // PLAYSTORE INFORMATION
          if (analysisData['playstore_details'] != null) ...[
            const SizedBox(height: 16),
            Card(
              color: cardColor,
              elevation: isDarkMode ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PLAYSTORE INFORMATION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Title', analysisData['playstore_details']['title'] ?? ''),
                    _buildInfoRow('Score', analysisData['playstore_details']['score']?.toString() ?? ''),
                    _buildInfoRow('Installs', analysisData['playstore_details']['installs'] ?? ''),
                    _buildInfoRow('Price', analysisData['playstore_details']['price']?.toString() ?? 'Free'),
                    _buildInfoRow('Developer', analysisData['playstore_details']['developer'] ?? ''),
                    if (analysisData['playstore_details']['developer_address'] != null)
                      _buildInfoRow('Developer Address', analysisData['playstore_details']['developer_address']),
                    if (analysisData['playstore_details']['developer_email'] != null)
                      _buildInfoRow('Developer Email', analysisData['playstore_details']['developer_email']),
                    if (analysisData['playstore_details']['developer_website'] != null)
                      _buildInfoRow('Developer Website', analysisData['playstore_details']['developer_website']),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
            height: 1.5,
          ),
        children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

// halaman Signer
class SignerPage extends StatelessWidget {
  final bool isDarkMode;
  final Map<String, dynamic> analysisData;

  const SignerPage({super.key, required this.isDarkMode, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    print('=== CERTIFICATE DATA ===');
    print(analysisData['certificate_analysis']);
    print('========================');
    var certData = analysisData['certificate_analysis'] ?? {};
    if (certData is List && certData.isNotEmpty) {
      certData = certData.first;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: cardColor,
        elevation: isDarkMode ? 0 : 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    'SIGNER CERTIFICATE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(certData['certificate_info'] ?? 'No certificate info', style: TextStyle(color: textColor)),
              const SizedBox(height: 16),
              if (certData['certificate_findings'] != null) ...[
                Text('Findings:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                ...List.generate((certData['certificate_findings'] as List).length, (i) {
                  final finding = certData['certificate_findings'][i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('- ${finding.join(' | ')}', style: TextStyle(color: textColor, fontSize: 13)),
                  );
                }),
                const SizedBox(height: 8),
              ],
              if (certData['certificate_summary'] != null) ...[
                Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                ...((certData['certificate_summary'] as Map).entries.map((e) => Text('${e.key}: ${e.value}', style: TextStyle(color: textColor, fontSize: 13)))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// halaman Permission
class PermissionPage extends StatelessWidget {
  final bool isDarkMode;
  final Map<String, dynamic> analysisData;

  const PermissionPage({super.key, required this.isDarkMode, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color headerBgColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    
    // Debug print untuk memeriksa data yang diterima
    print('=== Permission Data ===');
    print(analysisData['permissions']);
    print('=====================');

    // Konversi data permissions ke format yang sesuai
    List<Map<String, dynamic>> permissionsData = [];
    
    if (analysisData['permissions'] != null) {
      if (analysisData['permissions'] is Map) {
        // Jika permissions adalah Map, konversi ke List
        (analysisData['permissions'] as Map).forEach((key, value) {
          if (value is Map) {
            permissionsData.add({
              'name': key.toString(),
              'status': value['status'] ?? value['risk_level'] ?? 'normal',
              'info': value['info'] ?? value['short_description'] ?? '',
              'description': value['description'] ?? '',
            });
          }
        });
      } else if (analysisData['permissions'] is List) {
        // Jika permissions sudah berupa List
        permissionsData = (analysisData['permissions'] as List).map((item) {
          if (item is Map<String, dynamic>) {
            return {
              'name': item['name'] ?? '',
              'status': item['status'] ?? item['risk_level'] ?? 'normal',
              'info': item['info'] ?? item['short_description'] ?? '',
              'description': item['description'] ?? '',
            };
          }
          return <String, dynamic>{};
        }).toList();
      }
    }

    final List<Permission> permissions = Permission.fromJsonList(permissionsData);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_outlined, color: textColor),
              const SizedBox(width: 8),
              Text(
                'APPLICATION PERMISSIONS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'PERMISSION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'INFO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (permissions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No permissions found',
                style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                final permission = permissions[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          permission.name,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      Expanded(
                        child: _buildStatusBadge(permission.status),
                      ),
                      Expanded(
                        child: Text(
                          permission.info,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          permission.description,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Showing ${permissions.length} entries',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch (status.toLowerCase()) {
      case 'dangerous':
        backgroundColor = Colors.red;
        break;
      case 'normal':
        backgroundColor = Colors.blue;
        break;
      case 'signature':
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

// halaman AMAPI
class AmApiPage extends StatelessWidget {
  final bool isDarkMode;
  final Map<String, dynamic> analysisData;

  const AmApiPage({super.key, required this.isDarkMode, required this.analysisData});

  List<String> getApiNames() {
    final apiAnalysis = analysisData['api_analysis'];
    final List<String> apiNames = [];
    if (apiAnalysis != null && apiAnalysis is Map) {
      apiAnalysis.forEach((category, apis) {
        if (apis is Map) {
          apis.forEach((apiName, details) {
            apiNames.add('$category - $apiName');
          });
        }
      });
    }
    return apiNames;
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color rowColor = isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final apiNames = getApiNames();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: cardColor,
        elevation: isDarkMode ? 0 : 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ANDROID API',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              if (apiNames.isEmpty)
                Text(
                  'No API calls found',
                  style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: apiNames.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: index.isEven ? rowColor : null,
                        border: Border(
                          bottom: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                      ),
                      child: Text(
                        apiNames[index],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// About Page
class AboutPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AboutPage({
    super.key,
    required this.toggleTheme, 
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'about', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Analyzer by Drupadity',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This application is designed to help users easily analyze other apps. '
                    'Its main purpose is to allow users to detect whether an application contains any harmful viruses or malware.',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Main Feature:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Text('- Malware scanning and analysis for applications', style: TextStyle(color: textColor)),
                  const SizedBox(height: 20),
                  Text(
                    'Developers:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Text('Drupadity Team - Universitas Jenderal Achmad Yani Yogyakarta', style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Text('1. Handaru Darma Putra (222104004)', style: TextStyle(color: textColor)),
                  Text('2. Muhammad Nasikh Afifuddin (222104009)', style: TextStyle(color: textColor)),
                  Text('3. Ahmad Fazal (222104010)', style: TextStyle(color: textColor)),
                  Text('4. Yerly Ania Saputri (222104002)', style: TextStyle(color: textColor)),
                  Text('5. Ahmad Ansori (222104001)', style: TextStyle(color: textColor)),
                  Text('6. Osok Rianto Hay (222104006)', style: TextStyle(color: textColor)),
                  const SizedBox(height: 20),
                  Text(
                    'Application Version:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text('Version 1.0.0', style: TextStyle(color: textColor)),
                  const SizedBox(height: 20),
                  Text(
                    'Contact / Feedback:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text('Email: Drupadity@gmail.com', style: TextStyle(color: textColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '@Security Analyze By Drupadity',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman Setting
class SettingPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SettingPage({
    super.key,
    required this.toggleTheme, 
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'setting', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('application settings', style: TextStyle(color: textColor)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '@Security Analyze By Drupadity',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
