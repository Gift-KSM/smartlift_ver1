import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car2_screen.dart';
import 'door_screen.dart';
import "package:smartlift/global.dart";

// ignore: must_be_immutable
class Car1Screen extends StatefulWidget {
  final StatusItem? status;
  const Car1Screen({Key? key, this.status}) : super(key: key);

  @override
  State<Car1Screen> createState() => _Car1ScreenState();
}

class _Car1ScreenState extends State<Car1Screen> {
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
        // ignore: use_build_context_synchronously
        if (!context.mounted) return;
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      StatusItem? status1 =
          await StatusItem.getStatus(status!.iLiftID.toString());
      setState(() {
        status = status1;
      });
    });
  }

  @override
  @override
  build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.blue, Colors.black],
                  // stops: [0.1,0.3,0.7,1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(children: <Widget>[
            Container(
              height: 190,
              width: 700,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 0,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue],

                      // stops: [0.1,0.3,0.7,1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 13.0,
                    ),

                    // แถว 1
                    const SizedBox(
                      height: 7,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            'SMART LIFT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),

                    // แถว 2
                    // const Spacer(),
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                              icon: checkUpDownArrow(status!.szLiftState!),
                              onPressed: () {},
                            ),
                            Text(
                              status!.ltLevelName![
                                  checkCurrentFloor(status!.szLiftState!) - 1],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                                icon: (checkDoorIcon(status!.szLiftState!)),
                                onPressed: () {}),
                            Text(
                              checkDoorText(status!.szLiftState!),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.speed,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {}),
                            Text(
                              checkSpeed(status!.szLiftState!),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.report_problem_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 40,
                                ),
                                onPressed: () {}),
                            Text(
                              checkError(status!.szLiftState!),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ]),
            ),
            const Row(
              children: <Widget>[],
            ),

            // ขยับโลโก้ขึ้นลง
            const Row(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Expanded(
                    child: Image(
                        width: 25,
                        height: 50,
                        image: AssetImage("assets/LOGO_COMPANY.png"))),
                Expanded(
                  child: Image(
                      width: 250,
                      height: 50,
                      image: AssetImage("assets/KUSE.png")),
                ),
              ],
            ),

            // ขยับกรอบล่าง logo
            const SizedBox(
              height: 40,
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 299,
                  height: 380,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    border: Border.all(
                        color: const Color.fromARGB(255, 81, 162, 255),
                        width: 4,
                        style: BorderStyle.solid),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),

                  // __________________ Column_____________________
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 21.5,
                        ),
                        const SizedBox(width: 200),
                        if (status!.iMaxLevel! > 12)
                          IconButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              //     //push door screen
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Car2Screen(
                                            status: status,
                                          )));
                              
                            },
                            icon: const Icon(
                              Icons.keyboard_double_arrow_right_outlined,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                      ],
                    ),

                    // ความสูงของ level
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //_________ROW1________LEVEL_LIFT__1,2,3_______
                        Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                            if (status!.iMaxLevel! >= 1)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "1",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 1)
                                        ? const Color.fromARGB(255, 40, 255, 12)
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![0],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 2)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "2",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 2)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![1],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 3)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "3",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 3)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![2],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                            if (status!.iMaxLevel! >= 4)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "4",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 4)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![3],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 5)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "5",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 5)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![4],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 6)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "6",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 6)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![5],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                            if (status!.iMaxLevel! >= 7)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "7",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 7)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![6],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 8)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "8",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 8)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![7],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 9)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "9",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 9)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![8],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                            if (status!.iMaxLevel! >= 10)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "10",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 10)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![9],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 11)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "11",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 11)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![10],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 23,
                            ),
                            if (status!.iMaxLevel! >= 12)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "12",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 12)
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status!.ltLevelName![11],
                                      style: const TextStyle(
                                          fontSize: 40.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                    width: 150,
                    height: 45,
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
          ]),
        ),
      )),
      //
    );
  }
}
