library smartlift.globals;

import 'package:flutter/material.dart';
import 'flutter-icons-door/lift_door_app_icons.dart';

bool isLoggedIn = false;
String serverIP = '';
String username = '';
int memberID = 0;
String imageUrl = '';

bool checkLevel(String statusString, int level) {
  int value;
  if (level <= 8) {
    value = int.parse("0x${statusString.substring(0, 2)}");
    int mask = 1 << (level - 1);
    if (value & mask != 0) {
      return true;
    }
  } else if (level <= 16) {
    value = int.parse("0x${statusString.substring(2, 4)}");
    int mask = 1 << (level - 9);
    if (value & mask != 0) {
      return true;
    }
  } else if (level <= 24) {
    value = int.parse("0x${statusString.substring(4, 6)}");
    int mask = 1 << (level - 17);
    if (value & mask != 0) {
      return true;
    }
  } else {
    value = int.parse("0x${statusString.substring(6, 8)}");
    int mask = 1 << (level - 25);
    if (value & mask != 0) {
      return true;
    }
  }
  return false;
}

Icon checkUpDownArrow(String statusString) {
  int value = int.parse("0x${statusString.substring(2, 4)}");
  int downArrow = value & (1 << 6);
  int upArrow = value & (1 << 7);
  if (downArrow == 0 && upArrow == 0) {
    return const Icon(
      Icons.import_export,
      size: 50.0,
      color: Colors.white,
    );
  } else if (downArrow != 0 && upArrow == 0) {
    return const Icon(
      Icons.south,
      size: 35.0,
      color: Color.fromARGB(255, 0, 255, 187),
    );
  } else   {
    return const Icon(
      Icons.north,
      size: 35.0,
      color: Color.fromARGB(255, 255, 4, 4),
    );
  }
}

int checkCurrentFloor(String statusString) {
  return int.parse("0x${statusString.substring(0, 2)}");
}

String checkWorkingStatus(String statusString) {
  int value = int.parse("0x${statusString.substring(4, 6)}");
  int workingStatus = value & 15;
  if (workingStatus == 0) {
    return "Automatic";
  } else if (workingStatus == 1) {
    return "Maintenance";
  } else if (workingStatus == 2) {
    return "Fire Fighting";
  } else if (workingStatus == 3) {
    return "Driving";
  } else if (workingStatus == 4) {
    return "Special";
  } else if (workingStatus == 5) {
    return "Hoistway Learning";
  } else if (workingStatus == 6) {
    return "Elevator Lock";
  } else if (workingStatus == 7) {
    return "Reset";
  } else if (workingStatus == 8) {
    return "UPS";
  } else if (workingStatus == 9) {
    return "Idle";
  } else if (workingStatus == 10) {
    return "Holding Break Detection";
  } else if (workingStatus == 11) {
    return "Bypass Operation";
  } else {
    return "Error";
  }
}

String checkLoad(String statusString) {
  int value = int.parse("0x${statusString.substring(4, 6)}");
  int loadFull = value & (1 << 6);
  int loadOver = value & (1 << 7);
  if (loadFull != 0) {
    return "Full Load";
  } else if (loadOver != 0) {
    return "Over Load";
  } else {
    return "Normal";
  }
}

Icon checkDoorIcon(String statusString) {
  int value = int.parse("0x${statusString.substring(2, 4)}");
  int doorStatus = value & 3;

  if (doorStatus == 0) {
    return const Icon(LiftDoorApp.open, size: 30, color: Colors.white,);
  } else if (doorStatus == 1) {
    return const Icon(LiftDoorApp.close, size: 30, color: Colors.white);
  } else if (doorStatus == 2) {
    return const Icon(LiftDoorApp.closing, size: 30, color: Colors.white);
  } else if (doorStatus == 3) {
    return const Icon(LiftDoorApp.opening);
  } else {
    return const Icon(LiftDoorApp.open, size: 30, color: Colors.white);
  }
}

String checkDoorText(String statusString) {
  int value = int.parse("0x${statusString.substring(2, 4)}");
  int doorStatus = value & 3;
  if (doorStatus == 0) {
    return "Stops";
  } else if (doorStatus == 1) {
    return "Closed";
  } else if (doorStatus == 2) {
    return "Closing";
  } else if (doorStatus == 3) {
    return "Opening";
  } else {
    return "Opened";
  }
}

String checkSpeed(String statusString) {
  int value = int.parse("0x${statusString.substring(8, 12)}");
  return ((value / 100).round() / 10).toString();
}

String checkError(String statusString) {
  int value = int.parse("0x${statusString.substring(6, 8)}");
  return value.toString();
}
