import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car3_screen.dart';
import 'car_screen.dart';
import 'door_screen.dart';
import "package:smartlift/constants.dart";
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class Car2Screen extends StatefulWidget {
  final StatusItem? status;
  const Car2Screen({Key? key, this.status}) : super(key: key);

  @override
  State<Car2Screen> createState() => _Car2ScreenState();
}

class _Car2ScreenState extends State<Car2Screen> {
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
        if (details.delta.direction <= 0) {
          Navigator.pop(context);
          //push door screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CarScreen(
                        status: status,
                      )));
        }
        if (details.delta.direction > 0 && status!.iMaxLevel! > 16) {
          Navigator.pop(context);
          //push door screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Car3Screen(
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
                        StatusItem? status1 = await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "9", "zxcvd");
                        setState(() {
                          status = status1;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 9)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "9",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    if (status!.iMaxLevel! > 9) const SizedBox(width: 10.0),
                    if (status!.iMaxLevel! > 9)
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "10", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 10)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "10",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                  ],
                ),
                if (status!.iMaxLevel! > 10) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 10)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "11", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 11)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "11",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 11) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 11)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "12",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 12)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "12",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 12) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 12)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "13", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 13)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "13",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 13) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 13)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "14",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 14)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "14",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 14) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 14)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "15", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 15)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "15",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 15) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 15)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "16",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 16)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "16",
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
