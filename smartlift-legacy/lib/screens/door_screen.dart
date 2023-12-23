import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smartlift/constants.dart';
import 'package:smartlift/models/status_item.dart';
import 'package:smartlift/screens/car_screen.dart';
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class DoorScreen extends StatefulWidget {
  final StatusItem? status;
  final int? iLevel;

  const DoorScreen({
    Key? key,
    this.status,
    this.iLevel,
  }) : super(key: key);

  @override
  State<DoorScreen> createState() => _DoorScreenState();
}

class _DoorScreenState extends State<DoorScreen> {
  StatusItem? status;
  int? iLevel;
  Timer? timer;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes.substring(5, 6) == "C") {
        StatusItem? status1 = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        //pop this screen
        Navigator.pop(context);
        //push car screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarScreen(status: status1)));
      } else if (barcodeScanRes.substring(5, 6) == "U") {
        StatusItem? status1 = await StatusItem.getStatus(
            int.parse(barcodeScanRes.substring(1, 5)).toString());
        setState(() {
          status = status1;
          iLevel = int.parse(barcodeScanRes.substring(6, 8));
        });
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
      iLevel = widget.iLevel!;
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
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                icon: checkUpDownArrow(status!.szLiftState!), onPressed: () {}),
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
                    child: Text(status!.szLiftName! + "@" + iLevel.toString()),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              if (iLevel != status!.iMaxLevel)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_circle_up,
                            size: 100.0,
                            color: checkLevel(status!.szUpStatus!, iLevel!)
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const Text(
                            'Up',
                            style: kMenuTextStyle,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        StatusItem? status1 = await StatusItem.addCall(
                            status!.iLiftID!.toString(),
                            //temporary change
                            "D",
                            iLevel.toString(),
                            "zxcvd");
                        //pop this screen
                        Navigator.pop(context);
                        //push door screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoorScreen(
                                      status: status1!,
                                      iLevel: iLevel,
                                    )));
                      },
                    ),
                  ],
                ),
              if (iLevel != 1) const SizedBox(height: 30.0),
              if (iLevel != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_circle_down,
                            size: 100.0,
                            color: checkLevel(status!.szDownStatus!, iLevel!)
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const Text(
                            'Down',
                            style: kMenuTextStyle,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        //call down
                        StatusItem? status1 = await StatusItem.addCall(
                            status!.iLiftID!.toString(),
                            //temporary change
                            "U",
                            iLevel.toString(),
                            "zxcvd");
                        //pop this screen
                        Navigator.pop(context);
                        //push door screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoorScreen(
                                      status: status1!,
                                      iLevel: iLevel,
                                    )));
                      },
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
