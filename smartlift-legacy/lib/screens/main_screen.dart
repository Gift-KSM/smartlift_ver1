import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smartlift/constants.dart';
import 'package:smartlift/screens/car_screen.dart';
import 'package:smartlift/global.dart' as globals;

import 'package:smartlift/models/status_item.dart';
import 'package:smartlift/services/config_system.dart';
import 'door_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var buttonText = 'Level:';
  String szLevel = "";
  String ip = '';
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes.substring(5, 6) == "C") {
        StatusItem? status = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        //pop this screen
        //Navigator.pop(context);
        //push car screen
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CarScreen(status: status)));
      } else if (barcodeScanRes.substring(5, 6) == "U") {
        StatusItem? status = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        //pop this screen
        //Navigator.pop(context);
        //push door screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoorScreen(
                      status: status!,
                      iLevel: int.parse(barcodeScanRes.substring(6, 8)),
                    )));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lift v' + version),
        backgroundColor: const Color.fromRGBO(228, 61, 28, 1),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                if (globals.serverIP == '') {
                  globals.serverIP = await ConfigSystem.getServer();
                }
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Config server ip'),
                          content: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.important_devices,
                                color: Colors.orangeAccent,
                                size: 50.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: globals.serverIP,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    //Do something with the user input.
                                    ip = value;
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Enter Server IP'),
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Save'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: () {
                                globals.serverIP = ip;
                                ConfigSystem.setServer(globals.serverIP);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: const Text('Close'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcodeNormal(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.document_scanner),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {},
                    child: const Text("Please scan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
