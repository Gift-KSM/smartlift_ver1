import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car2_screen.dart';
import 'door_screen.dart';

import 'package:smartlift/constants.dart';
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class CarScreen extends StatefulWidget {
  final StatusItem? status;
  const CarScreen({Key? key, this.status}) : super(key: key);

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  StatusItem? status;
  Timer? timer;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes.substring(5, 6) == "C") {
        StatusItem? status1 = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        setState(() {
          status = status1;
        });
      } else if (barcodeScanRes.substring(5, 6) == "U") {
        StatusItem? status1 = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        //pop this screen
        Navigator.pop(context);
        //push door screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoorScreen(
                      status: status1,
                      iLevel: int.parse(barcodeScanRes.substring(6, 8)),
                    )));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  void deactivate() {
    timer!.cancel();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.status!;
    });
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      StatusItem? status1 =
          await StatusItem.getStatus(status!.iLiftID.toString());
      setState(() {
        status = status1;
      });
    });
  }

  @override
  build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.direction > 0 && status!.iMaxLevel! > 8) {
          Navigator.pop(context);
          //push door screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Car2Screen(
                        status: status,
                      )));
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                  icon: checkUpDownArrow(status!.szLiftState!),
                  onPressed: () {}),
              Text(checkCurrentFloor(status!.szLiftState!)),
              const Spacer(),
              IconButton(
                  icon: checkDoorIcon(status!.szLiftState!), onPressed: () {}),
              Text(checkDoorText(status!.szLiftState!)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.bolt), onPressed: () {}),
              Text(checkSpeed(status!.szLiftState!)),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.report_problem), onPressed: () {}),
              Text(checkError(status!.szLiftState!)),
              const Spacer(),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Smart Lift v' + version),
          backgroundColor: const Color.fromRGBO(228, 61, 28, 1),
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
                      child: Text(status!.szLiftName!),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "1", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 1)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "1",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () async {
                        await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "2", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 2)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "2",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "3", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 3)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "3",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () async {
                        await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "4", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 4)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "4",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                if (status!.iMaxLevel! > 4) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "5", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 5)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "5",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 5) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 5)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(), "C", "6", "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor: checkLevel(status!.szCarStatus!, 6)
                                ? Colors.green
                                : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "6",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 6) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 6)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "7", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 7)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "7",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 7) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 7)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(), "C", "8", "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor: checkLevel(status!.szCarStatus!, 8)
                                ? Colors.green
                                : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "8",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
