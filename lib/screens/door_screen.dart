// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smartlift/models/status_item.dart';
import 'package:smartlift/screens/car1_screen.dart';
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
        if (!context.mounted) return;
        Navigator.pop(context);
        //push car screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Car1Screen(status: status1)));
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
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
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.blue, Colors.black],
                  // stops: [0.1,0.3,0.7,1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            children: <Widget>[
              //_______________________ _COLUMN SMARTLIFT AND STATUS _ ______________________
              //_____________________________________________________________________________
              Container(
                // Container with status
                // color: Colors.blue,
                height: 190,
                width: 700,

                decoration: BoxDecoration(
                    //color and bodercolos
                    color: const Color.fromARGB(255, 0, 0, 0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                padding: const EdgeInsets.all(
                    20.0), // padding all SmartLiFT and Status
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
                      const SizedBox(
                        height: 1,
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
                                    checkCurrentFloor(status!.szLiftState!) -
                                        1],
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
                      const SizedBox(
                        height: 1,
                      ),
                    ]),
              ),

              //Check level
              const SizedBox(height: 15.0),

              Row(
                //_________________ _ Row 3 Level show and Button Up And Down _ ___________________
                //_________________________________________________________________________________
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 2),
                      const Row(
                        children: <Widget>[
                          Image(
                              width: 250,
                              height: 60,
                              image: AssetImage("assets/LOGO_COMPANY.png"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          //________________________ _ Container LEVEL CHECK_ _______________________________
                          Container(
                            // color: Colors.blue,
                            height: 280,
                            width: 170,
                            padding: const EdgeInsets.only(top: 1, left: 30),
                            child: Column(children: <Widget>[
                              const SizedBox(
                                height: 1,
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10.0),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              status!.ltLevelName![iLevel! - 1],
                                              style: const TextStyle(
                                                  fontSize: 80,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ]),
                                      const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              ("LEVEL"),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ]),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: const TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                // fontStyle: FontStyle.italic
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Text(status!.szLiftName!),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ]),
                          ),

                          // UP AND DOW
                          const SizedBox(width: 33),

                          //_______________________ _ Container UP AND DOWN _ _______________________________
                          Container(
                            // color: Colors.blue,
                            height: 280,
                            width: 130,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              border: Border.all(
                                  color: Colors.lightBlue.shade400,
                                  width: 5,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),

                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 18.0),

                                //___________________________COLUMN UP AND DOWN_______________________________
                                Column(
                                  children: <Widget>[
                                    const SizedBox(height: 20.0),

                                    //________________________________ _ ROW UP _ _____________________________________
                                    const SizedBox(
                                      height: 12,
                                    ),

                                    if (iLevel != status!.iMaxLevel)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          TextButton(
                                            //_______________________________ _ COLUMN UP _ ___________________________________
                                            //_________________________________________________________________________________
                                            onPressed: () async {
                                              await StatusItem.addCall(
                                                  status!.iLiftID!.toString(),
                                                  "U",
                                                  iLevel.toString(),
                                                  "zxcvd");
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90),
                                                        side: BorderSide(
                                                            color: Colors
                                                                .lightBlue
                                                                .shade400)))),

                                            //_______________________________ _ COLUMN UP _ ___________________________________
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                    backgroundColor: checkLevel(
                                                            status!.szUpStatus!,
                                                            iLevel!)
                                                        ? Colors.green
                                                        : const Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    radius: 30,
                                                    child: const Icon(
                                                      Icons.arrow_drop_up_sharp,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    const SizedBox(height: 10.0),
                                    if (iLevel != 1)

                                      //_______________________________ _ ROW DOWN _ ____________________________________
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          //_______________________________ _ COLUMN DOWN _ _________________________________
                                          TextButton(
                                            onPressed: () async {
                                              //call down
                                              await StatusItem.addCall(
                                                  status!.iLiftID!.toString(),
                                                  "D",
                                                  iLevel.toString(),
                                                  "zxcvd");
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90),
                                                        side: BorderSide(
                                                            color: Colors
                                                                .lightBlue
                                                                .shade400)))),
                                            child: Column(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundColor: checkLevel(
                                                          status!.szDownStatus!,
                                                          iLevel!)
                                                      ? Colors.green
                                                      : const Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  radius: 30,
                                                  child: const Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    size: 50.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("DESIGN BY",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic))
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/KUSE.png'),
                    width: 146,
                    height: 45,
                  )
                ],
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
