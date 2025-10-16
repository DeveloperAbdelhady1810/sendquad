import 'dart:io';
import 'package:excel/excel.dart' as excell;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quadsender/adapters/template.dart';
import 'package:quadsender/classes/styles.dart';
import 'package:quadsender/classes/variables.dart';
import 'package:quadsender/screens/sendScreen.dart';
import 'package:quadsender/screens/templatesScreen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final hiveDirectory = Directory('${directory.path}/quadsender');
  if (!await hiveDirectory.exists()) {
    await hiveDirectory.create(recursive: true);
  }
  // await Hive.init(hiveDirectory.path);
  await Hive.initFlutter(hiveDirectory.path);
  Hive.registerAdapter(TemplateAdapter());
  await Hive.openBox('templates');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QUADSender',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int screenIndex = 0;
List<Widget> screens = [
  const SendScreen(),
  const TemplatesScreen(),
];

class _MyHomePageState extends State<MyHomePage> {
  getUrl() {
    File urlFile = File("settings.txt");
    setState(() {
      url = urlFile.readAsStringSync();
    });
  }

  @override
  void dispose() {
    isenabled = false;
    isenabled2 = false;
    super.dispose();
  }

  @override
  void initState() {
    getUrl();
    Variables().url = url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 7, color: Colors.green.shade900),
                right: BorderSide(width: 7, color: Colors.green.shade900),
                top: const BorderSide(width: 2, color: Colors.transparent),
                bottom: const BorderSide(width: 2, color: Colors.transparent),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.green.shade900,
                      backgroundImage: AssetImage("images/quadro.png")),
                  TextButton(
                      style: Styles()
                          .buttonStyle(Colors.green, Colors.green.shade900, 20),
                      onPressed: () {
                        setState(() {
                          screenIndex = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Send Messages",
                          style: Styles().style(25, Colors.white, true),
                        ),
                      )),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 7, color: Colors.green.shade900),
                      right: BorderSide(width: 7, color: Colors.green.shade900),
                      top:
                          const BorderSide(width: 2, color: Colors.transparent),
                      bottom:
                          const BorderSide(width: 2, color: Colors.transparent),
                    )),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            screenIndex = 1;
                          });
                        },
                        child: const Icon(
                          Icons.list,
                          size: 50,
                        )),
                  )
                ],
              ),
            ),
            screens[screenIndex]
          ],
        ),
      ),
    );
  }
}
