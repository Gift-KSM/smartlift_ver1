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
    value = int.parse("0x" + statusString.substring(0, 2));
    int mask = 1 << (level - 1);
    if (value & mask != 0) {
      return true;
    }
  } else if (level <= 16) {
    value = int.parse("0x" + statusString.substring(2, 4));
    int mask = 1 << (level - 9);
    if (value & mask != 0) {
      return true;
    }
  } else if (level <= 24) {
    value = int.parse("0x" + statusString.substring(4, 6));
    int mask = 1 << (level - 17);
    if (value & mask != 0) {
      return true;
    }
  } else {
    value = int.parse("0x" + statusString.substring(6, 8));
    int mask = 1 << (level - 25);
    if (value & mask != 0) {
      return true;
    }
  }
  return false;
}

Icon checkUpDownArrow(String statusString) {
  int value = int.parse("0x" + statusString.substring(2, 4));
  int downArrow = value & (1 << 6);
  int upArrow = value & (1 << 7);
  if (downArrow == 0 && upArrow == 0) {
    return const Icon(Icons.swap_vertical_circle);
  } else if (downArrow == 1 && upArrow == 0) {
    return const Icon(Icons.south);
  } else {
    return const Icon(Icons.north);
  }
}

String checkCurrentFloor(String statusString) {
  return int.parse("0x" + statusString.substring(0, 2)).toString();
}

Icon checkDoorIcon(String statusString) {
  int value = int.parse("0x" + statusString.substring(2, 4));
  int doorStatus = value & 3;

  if (doorStatus == 0) {
    return const Icon(LiftDoorApp.open);
  } else if (doorStatus == 1) {
    return const Icon(LiftDoorApp.close);
  } else if (doorStatus == 2) {
    return const Icon(LiftDoorApp.closing);
  } else if (doorStatus == 3) {
    return const Icon(LiftDoorApp.opening);
  } else {
    return const Icon(LiftDoorApp.open);
  }
}

String checkDoorText(String statusString) {
  int value = int.parse("0x" + statusString.substring(2, 4));
  int doorStatus = value & 3;
  if (doorStatus == 0) {
    return "Stop";
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
  int value = int.parse("0x" + statusString.substring(8, 12));
  return ((value / 100).round() / 10).toString();
}

String checkError(String statusString) {
  int value = int.parse("0x" + statusString.substring(6, 8));
  return value.toString();
}
