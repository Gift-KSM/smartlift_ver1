import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:smartlift/models/status_item.dart';

import 'car3_screen.dart';
import 'car1_screen.dart';
import 'door_screen.dart';
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

            // ขยับ logo ขึ้นลง
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
                  //_______________________________________________
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Car1Screen(
                                          status: status,
                                        )));
                          },
                          icon: const Icon(
                            Icons.keyboard_double_arrow_left_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        const SizedBox(width: 180),
                        if (status!.iMaxLevel! > 24)
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Car3Screen(
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
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                        Row(
                          children: <Widget>[
                            if (status!.iMaxLevel! >= 13)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "13",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 13)
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
                                      status!.ltLevelName![12],
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
                            if (status!.iMaxLevel! >= 14)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "14",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 14)
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
                                      status!.ltLevelName![13],
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
                            if (status!.iMaxLevel! >= 15)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "15",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 15)
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
                                      status!.ltLevelName![14],
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
                            if (status!.iMaxLevel! >= 16)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "16",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 16)
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
                                      status!.ltLevelName![15],
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
                            if (status!.iMaxLevel! >= 17)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "17",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 17)
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
                                      status!.ltLevelName![16],
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
                            if (status!.iMaxLevel! >= 18)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "18",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 18)
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
                                      status!.ltLevelName![17],
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
                            if (status!.iMaxLevel! >= 19)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "19",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 19)
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
                                      status!.ltLevelName![18],
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
                            if (status!.iMaxLevel! >= 20)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "20",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 20)
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
                                      status!.ltLevelName![19],
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
                            if (status!.iMaxLevel! >= 21)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "21",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 21)
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
                                      status!.ltLevelName![20],
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
                            if (status!.iMaxLevel! >= 22)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "22",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 22)
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
                                      status!.ltLevelName![21],
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
                            if (status!.iMaxLevel! >= 23)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "23",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 23)
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
                                      status!.ltLevelName![22],
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
                            if (status!.iMaxLevel! >= 24)
                              GestureDetector(
                                onTap: () async {
                                  await StatusItem.addCall(
                                      status!.iLiftID!.toString(),
                                      "C",
                                      "24",
                                      "zxcvd");
                                },
                                child: Container(
                                  width: 73,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    color: checkLevel(status!.szCarStatus!, 24)
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
                                      status!.ltLevelName![23],
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
