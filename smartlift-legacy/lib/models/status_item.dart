import 'package:smartlift/services/networking.dart';

class StatusItem {
  final int? iLiftID;
  final String? szLiftName;
  final int? iMaxLevel;
  final String? szLiftState;
  final String? szUpStatus;
  final String? szDownStatus;
  final String? szCarStatus;
  StatusItem({
    this.iLiftID,
    this.szLiftName,
    this.iMaxLevel,
    this.szLiftState,
    this.szUpStatus,
    this.szDownStatus,
    this.szCarStatus,
  });

  static Future<StatusItem?> getStatus(String liftId) async {
    NetworkHelper networkHelper = NetworkHelper('get_status.php', {
      'lift_id': liftId,
    });
    var json = await networkHelper.getData();
    if (json != null) {
      StatusItem status = StatusItem(
        iLiftID: int.parse(liftId),
        szLiftName: json["lift_name"],
        iMaxLevel: int.parse(json["max_level"]),
        szLiftState: json["lift_state"],
        szUpStatus: json["up_status"],
        szDownStatus: json["down_status"],
        szCarStatus: json["car_status"],
      );
      return status;
    } else {
      return null;
    }
  }

  static Future<StatusItem?> addCall(
      String liftId, String direction, String floorNo, String clientId) async {
    NetworkHelper networkHelper = NetworkHelper('add_call.php', {
      'lift_id': liftId,
      'direction': direction,
      'floor_no': floorNo,
      'client_id': clientId,
    });
    var json = await networkHelper.getData();
    if (json != null) {
      StatusItem status = StatusItem(
        iLiftID: int.parse(liftId),
        szLiftName: json["lift_name"],
        iMaxLevel: int.parse(json["max_level"]),
        szLiftState: json["lift_state"],
        szUpStatus: json["up_status"],
        szDownStatus: json["down_status"],
        szCarStatus: json["car_status"],
      );
      return status;
    } else {
      return null;
    }
  }
}
