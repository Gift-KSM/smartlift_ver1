import 'package:flutter/material.dart';
import 'package:smartlift/screens/main_screen.dart';
import 'package:smartlift/services/config_system.dart';
import 'global.dart' as globals;

void main() async {
  runApp(const MyApp());
  globals.serverIP = await ConfigSystem.getServer();
  //print(globals.serverIP);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
