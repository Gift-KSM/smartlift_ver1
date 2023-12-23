// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smartlift/constants.dart';
import 'package:smartlift/screens/car1_screen.dart';

import 'package:smartlift/models/status_item.dart';
import 'door_screen.dart';

Color c1 = const Color.fromRGBO(179, 179, 179, 0); //
Color c2 = const Color.fromRGBO(0, 136, 255, 0); //
Color c3 = const Color.fromRGBO(39, 155, 255, 0); //
Color c4 = const Color.fromARGB(0, 0, 0, 0); //

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var buttonText = 'Level:';
  String szLevel = "";
  String ip = '';
  String barcodeScanRes = "";
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
      
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
        setState((){
         this.barcodeScanRes = barcodeScanRes;
      });
      if (barcodeScanRes.substring(5, 6) == "C") {
        StatusItem? status = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
            
        //pop this screen
        //Navigator.pop(context);
        //push car screen
        if (!context.mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Car1Screen(status: status)));
      } else if (barcodeScanRes.substring(5, 6) == "U") {
        StatusItem? status = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());      

        //pop this screen
        //Navigator.pop(context);
        //push door screen
        if (!context.mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoorScreen(
                      status: status!,
                      iLevel: int.parse(barcodeScanRes.substring(6, 8)),
                    )));
      }
    }
     on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.blue, Colors.black],
                // stops: [0.1,0.3,0.7,1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'SMART LIFT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11.0),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'VERSION $version',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/LOGO_COMPANY.png'),
                  width: 231,
                  height: 70,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/LIFT_1.png'),
                  width: 320,
                  height: 370,
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("DESIGN BY",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic))
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/KUSE.png'),
                  width: 150,
                  height: 40,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 161,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(10.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () => scanBarcodeNormal(),
                      child: const Text('SCAN'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
