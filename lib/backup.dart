import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SecurityAnalyzeApp());
}

class SecurityAnalyzeApp extends StatefulWidget {
  @override
  _SecurityAnalyzeAppState createState() => _SecurityAnalyzeAppState();
}

class _SecurityAnalyzeAppState extends State<SecurityAnalyzeApp> {
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
              primaryColor: Colors.green,
              scaffoldBackgroundColor: Colors.white,
            ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AuthGate({required this.toggleTheme, required this.isDarkMode});

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
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home, color: iconColor),
              title: Text('Home', style: TextStyle(color: textColor)),
              selected: currentPage == 'home',
              onTap: () {
                if (currentPage != 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: iconColor),
              title: Text('History', style: TextStyle(color: textColor)),
              selected: currentPage == 'history',
              onTap: () {
                if (currentPage != 'history') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: iconColor),
              title: Text('About', style: TextStyle(color: textColor)),
              selected: currentPage == 'about',
              onTap: () {
                if (currentPage != 'about') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AboutPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: iconColor),
              title: Text('Setting', style: TextStyle(color: textColor)),
              selected: currentPage == 'setting',
              onTap: () {
                if (currentPage != 'setting') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomePage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = isDarkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'home', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: isDarkMode ? Colors.teal : Colors.green,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.android, size: 100, color: iconColor),
            SizedBox(height: 20),
            Text('Only APK', style: TextStyle(color: textColor, fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text('Upload & Analyze'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white : Colors.black,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  ResultPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Info'),
    Tab(text: 'Signer'),
    Tab(text: 'Perm'),
    Tab(text: 'AMAPI'),
    Tab(text: 'Malware'),
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
        return InfoPage(isDarkMode: widget.isDarkMode);
      case 1:
        return SignerPage(isDarkMode: widget.isDarkMode);
      case 2:
        return PermissionPage(isDarkMode: widget.isDarkMode);
      case 3:
        return AmApiPage(isDarkMode: widget.isDarkMode);
      case 4:
        return MalwarePage(isDarkMode: widget.isDarkMode);
      default:
        return Center(child: Text('Tab tidak ditemukan'));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tabBarBg = widget.isDarkMode ? Colors.grey[900]! : Colors.grey[300]!;
    Color indicatorColor = widget.isDarkMode ? Colors.tealAccent : Colors.green;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'result', isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
      appBar: AppBar(
        title: Text('Analysis Results'),
        backgroundColor: widget.isDarkMode ? Colors.teal : Colors.green,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: tabBarBg,
            child: TabBar(
              controller: _tabController,
              tabs: myTabs,
              indicatorColor: indicatorColor,
              labelColor: widget.isDarkMode ? Colors.white : Colors.black,
              unselectedLabelColor: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
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

// Contoh halaman Info
class InfoPage extends StatelessWidget {
  final bool isDarkMode;
  InfoPage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      alignment: Alignment.center,
      child: Text(
        'Halaman Info\n\nDi sini tampilkan hasil analisis APK',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Contoh halaman Signer
class SignerPage extends StatelessWidget {
  final bool isDarkMode;
  SignerPage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          '''Binary is signed v1
signature: False v2
signature: True v3
signature: False v4
signature: False
X.509 Subject: O=TAGpilot, CN=Maria Feiertag
Signature Algorithm: rsassa_pkcs1v15
Valid From: 2020-02-05 19:48:53+00:00
Valid To: 2045-01-29 19:48:53+00:00
Issuer: O=TAGpilot, CN=Maria Feiertag
Serial Number: 0x2a9cd888
Hash Algorithm: sha256
md5: 0f325ac233806098c906ac2052209734
sha1: e5e8ccbc3635d710035087b544033d1ddb85711e
sha256: e567b8a23e74ba6fd3c0bda4168fa0f4e3bbbdc64d4a0055af5993d9a4465f53
sha512: 8ccd8983a9c11d08d7b22d1c1131f99400c7b886e02cd34a3a8143d160808fe4
7b18eb8000c8da6bd2aea2f3dbe9c0b8a5ab12ee0aa557bb9d0838bf188cbb
PublicKey Algorithm: rsa
Bit Size: 2048
Fingerprint: faadac280d3cfc152b683b651d48acdef43170f7b9755bae5869b1b2dec6f878
Found 1 unique certificates''',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Courier',
          ),
        ),
      ),
    );
  }
}

// Contoh halaman Permission
class PermissionPage extends StatelessWidget {
  final bool isDarkMode;
  PermissionPage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Status', style: TextStyle(color: textColor))),
            DataColumn(label: Text('Info', style: TextStyle(color: textColor))),
            DataColumn(label: Text('Deskripsi', style: TextStyle(color: textColor))),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Dangerous', style: TextStyle(color: Colors.red))),
              DataCell(Text('read/modify/delete external storage contents', style: TextStyle(color: textColor))),
              DataCell(Text('Allows app to access external storage', style: TextStyle(color: textColor))),
            ]),
            DataRow(cells: [
              DataCell(Text('Normal', style: TextStyle(color: Colors.green))),
              DataCell(Text('allow app to access the device advertising ID', style: TextStyle(color: textColor))),
              DataCell(Text('This ID is a unique, user-resettable identifier provided by Google’s advertising services.', style: TextStyle(color: textColor))),
            ]),
            DataRow(cells: [
              DataCell(Text('Unknown', style: TextStyle(color: Colors.orange))),
              DataCell(Text('', style: TextStyle(color: textColor))),
              DataCell(Text('', style: TextStyle(color: textColor))),
            ]),
            DataRow(cells: [
              DataCell(Text('Dangerous', style: TextStyle(color: Colors.red))),
              DataCell(Text('allows app to post notifications', style: TextStyle(color: textColor))),
              DataCell(Text('Allows an app to post notifications', style: TextStyle(color: textColor))),
            ]),
            DataRow(cells: [
              DataCell(Text('Normal', style: TextStyle(color: Colors.green))),
              DataCell(Text('allows use of alarm-supported biometric modalities', style: TextStyle(color: textColor))),
              DataCell(Text('', style: TextStyle(color: textColor))),
            ]),
          ],
        ),
      ),
    );
  }
}

// Contoh halaman AMAPI
class AmApiPage extends StatelessWidget {
  final bool isDarkMode;
  AmApiPage({required this.isDarkMode});

  final List<Map<String, String>> apiList = [
    {'api': 'Android Notifications'},
    {'api': 'Base64 Decode'},
    {'api': 'Dynamic Class and Dexloading'},
    {'api': 'Crypto'},
    {'api': 'Get Installed Applications'},
    {'api': 'Get Running App Processes'},
    {'api': 'Get System Service'},
    {'api': 'GPS Location'},
    {'api': 'GPS Location'},
    {'api': 'Base64 Encode'},
  ];

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('API', style: TextStyle(color: textColor))),
            DataColumn(label: Text('Files', style: TextStyle(color: textColor))),
          ],
          rows: apiList.map((apiData) {
            return DataRow(cells: [
              DataCell(Text(apiData['api']!, style: TextStyle(color: textColor))),
              DataCell(TextButton(
                child: const Text('Show Files'),
                onPressed: () {
                  // Aksi saat tombol ditekan
                },
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

// Contoh halaman Malware
class MalwarePage extends StatelessWidget {
  final bool isDarkMode;
  MalwarePage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      alignment: Alignment.center,
      child: Text(
        'Halaman Malware\n\nKonten kosong sesuai desain',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Halaman History
class HistoryPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HistoryPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'history', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: isDarkMode ? Colors.teal : Colors.green,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Text('Halaman History - Daftar analisis sebelumnya', style: TextStyle(color: textColor)),
      ),
    );
  }
}

// Halaman About
class AboutPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  AboutPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'about', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: isDarkMode ? Colors.teal : Colors.green,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Text('Tentang aplikasi Security Analyze By Drupadity', style: TextStyle(color: textColor)),
      ),
    );
  }
}

// Halaman Setting
class SettingPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  SettingPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'setting', isDarkMode: isDarkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
        title: Text('Setting'),
        backgroundColor: isDarkMode ? Colors.teal : Colors.green,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Text('Pengaturan aplikasi', style: TextStyle(color: textColor)),
      ),
    );
  }
}
