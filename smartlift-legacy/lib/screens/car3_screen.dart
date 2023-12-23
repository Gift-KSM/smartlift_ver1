import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car2_screen.dart';
import 'car4_screen.dart';
import 'door_screen.dart';
import "package:smartlift/constants.dart";
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class Car3Screen extends StatefulWidget {
  final StatusItem? status;
  const Car3Screen({Key? key, this.status}) : super(key: key);

  @override
  State<Car3Screen> createState() => _Car3ScreenState();
}

class _Car3ScreenState extends State<Car3Screen> {
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
                  builder: (context) => Car2Screen(
                        status: status,
                      )));
        }
        if (details.delta.direction > 0 && status!.iMaxLevel! > 24) {
          Navigator.pop(context);
          //push door screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Car4Screen(
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
                            status!.iLiftID!.toString(), "C", "17", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 9)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "17",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    if (status!.iMaxLevel! > 17) const SizedBox(width: 10.0),
                    if (status!.iMaxLevel! > 17)
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "18", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 10)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "18",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                  ],
                ),
                if (status!.iMaxLevel! > 18) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 18)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "19", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 11)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "19",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 19) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 19)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "20",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 12)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "20",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 20) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 20)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "21", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 13)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "21",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 21) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 21)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "22",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 14)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "22",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 22) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 22)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "23", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 15)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "23",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 23) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 23)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "24",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                checkLevel(status!.szCarStatus!, 16)
                                    ? Colors.green
                                    : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "24",
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
