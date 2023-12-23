import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car3_screen.dart';
import 'door_screen.dart';
import "package:smartlift/constants.dart";
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class Car4Screen extends StatefulWidget {
  final StatusItem? status;
  const Car4Screen({Key? key, this.status}) : super(key: key);

  @override
  State<Car4Screen> createState() => _Car4ScreenState();
}

class _Car4ScreenState extends State<Car4Screen> {
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
                        await StatusItem.addCall(
                            status!.iLiftID!.toString(), "C", "25", "zxcvd");
                      },
                      child: CircleAvatar(
                        backgroundColor: checkLevel(status!.szCarStatus!, 1)
                            ? Colors.green
                            : Colors.grey,
                        radius: 50,
                        child: const Text(
                          "25",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    if (status!.iMaxLevel! > 25) const SizedBox(width: 10.0),
                    if (status!.iMaxLevel! > 25)
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "26", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 2)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "26",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                  ],
                ),
                if (status!.iMaxLevel! > 26) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 26)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "27", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 3)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "27",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 27) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 27)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "28",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor: checkLevel(status!.szCarStatus!, 4)
                                ? Colors.green
                                : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "28",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 28) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 28)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "29", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 5)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "29",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 29) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 29)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "30",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor: checkLevel(status!.szCarStatus!, 6)
                                ? Colors.green
                                : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "30",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (status!.iMaxLevel! > 30) const SizedBox(height: 20.0),
                if (status!.iMaxLevel! > 30)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await StatusItem.addCall(
                              status!.iLiftID!.toString(), "C", "31", "zxcvd");
                        },
                        child: CircleAvatar(
                          backgroundColor: checkLevel(status!.szCarStatus!, 7)
                              ? Colors.green
                              : Colors.grey,
                          radius: 50,
                          child: const Text(
                            "31",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      if (status!.iMaxLevel! > 31) const SizedBox(width: 10.0),
                      if (status!.iMaxLevel! > 31)
                        GestureDetector(
                          onTap: () async {
                            await StatusItem.addCall(
                                status!.iLiftID!.toString(),
                                "C",
                                "32",
                                "zxcvd");
                          },
                          child: CircleAvatar(
                            backgroundColor: checkLevel(status!.szCarStatus!, 8)
                                ? Colors.green
                                : Colors.grey,
                            radius: 50,
                            child: const Text(
                              "32",
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
