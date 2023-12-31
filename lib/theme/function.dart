// ignore_for_file: non_constant_identifier_names, unnecessary_new, prefer_equal_for_default_values, unused_local_variable, avoid_function_literals_in_foreach_calls, prefer_collection_literals, deprecated_member_use, deprecated_colon_for_default_value

import 'package:intl/intl.dart';

//exmaple calling DB  function
// Map<dynamic, dynamic> where = {
//   'table': "users",
//   'phone': '11199119911',
//   'gender': 'transgender',
//   'orderBy': 'phone',
//   'limit': 1,
// };
//dbSave(db, where);
//dbDelete(db, 'users', 'LQJbIfdB15SHDCf51p03');
//print(dbFindDynamic(db, where));

// ===========================================
// timestampToDate(Timestamp timestamp) {
//   var format = new DateFormat('y-MM-d'); // <- use skeleton here
//   return format.format(timestamp.toDate());
// }

// My all functions for 99 ====================================================
var base_url = "https://insaaf99.com/";
int currentVersion = 20;

// meetingStatus
Map<dynamic, dynamic> meetStatus = {
  '0': 'Pending',
  '1': 'Started',
  '2': 'Success'
};

// docs certificate status
Map<dynamic, dynamic> certificateStatus = {
  '0': 'Pending',
  '1': 'Under Review',
  '2': 'Processing',
  '3': 'Certificate Issued',
};

bool matchString(str, search) {
  bool returnData = str.contains(new RegExp('$search', caseSensitive: false));
  return returnData;
}

// shcedule time
sechduleTimmingList() {
  Map<dynamic, dynamic> scheduleList = {};
  List<dynamic> weekList = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
  weekList.forEach((days) {
    var m = 10;
    List<dynamic> tempList = [];
    while (m <= 18) {
      var tempG = (m < 12) ? 'AM' : 'PM';
      var t = (m <= 12) ? m : m - 12;

      tempList.add("$t:00 $tempG");
      // for half time
      tempList.add("$t:30 $tempG");
      m++;
    }
    scheduleList[days] = tempList;
  });
  return scheduleList;
}

// schedule Date LIST
scheduleDateList() {
  Map<int, dynamic> seduleDate = new Map();
  DateTime today = DateTime.now();
  int i = 0;
  int m = 0;
  while (i < 30) {
    String dayes = DateFormat.E().format(today.add(Duration(days: i)));
    String dateIs = DateFormat.d().format(today.add(Duration(days: i)));
    String monthIs = DateFormat.MMM().format(today.add(Duration(days: i)));
    String yMd = DateFormat.yMd().format(today.add(Duration(days: i)));

    seduleDate[m] = {
      "month": monthIs,
      "date": dateIs,
      "day": dayes,
      "yMd": yMd,
    };
    m++;
    i++;
  }
  return seduleDate;
}

// url lanch  web view

GetMeegintStatus(slot_status, meeting_time, MeetingStatus) {
  if ((date_diff_min(meeting_time) > -30 &&
          date_diff_min(meeting_time) < 2) && //(MeetingStatus == '0') &&
      (slot_status == '1' || MeetingStatus == '2')) {
    return 'Join Meeting';
  }
  if (MeetingStatus == '2') {
    return "Success";
  } else if ((date_diff_min(meeting_time) > 1) &&
      (MeetingStatus == '0') &&
      slot_status == '1') {
    return 'Upcoming';
  } else if ((date_diff_min(meeting_time) < -30) &&
      slot_status == '1' &&
      MeetingStatus == '0') {
    return 'Meeting Time Expire';
  } else if (slot_status == '9') {
    return 'Re-schedule Requested';
  } else if (slot_status == '0') {
    return 'Approval Pending';
  } else {
    return meetStatus[MeetingStatus];
  }
}

changedate_dym(timestamp) {
  if (timestamp is int) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var format = new DateFormat("dd/MM/yyyy");
    var dateString = format.format(date);
    return dateString;
  } else {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    var format = new DateFormat("dd/MM/yyyy");
    var dateString = format.format(date);
    return dateString;
  }
}

currentDate() {
  DateTime now = DateTime.now();
  String formattedDate =
      DateFormat('yyyy-MM-dd hh:mm:s').format(now); //Y-m-d H:i:s

  return formattedDate;
}

currentRegistrationDate() {
  DateTime now = DateTime.now();
  String formattedDate =
      DateFormat("yyyy-MM-dd HH:mm:ss").format(now); //Y-m-d H:i:s
  return formattedDate;
}

currentDateOnly() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}

// change timestamp to time
changedate_time(timestamp) {
  if (timestamp is int) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var format = new DateFormat("hh:mm a");
    var dateString = format.format(date);
    return dateString;
  } else {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    var format = new DateFormat("hh:mm a");
    var dateString = format.format(date);
    return dateString;
  }
}

// Date Formate Function
String change_date_time(dateIs) {
  if (dateIs == '' || dateIs == null) {
    return '-';
  }
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var date1 = inputFormat.parse(dateIs);

  var outputFormat = DateFormat('MMM dd, yyyy hh:mm a');
  return outputFormat.format(date1);
}

// Date Formate Function
String change_date_only(dateIs) {
  if (dateIs == '' || dateIs == null) {
    return '-';
  }
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var date1 = inputFormat.parse(dateIs);

  var outputFormat = DateFormat('MMM dd, yyyy');
  return outputFormat.format(date1);
}

// Date Formate Function
String change_time_only(dateIs) {
  if (dateIs == '' || dateIs == null) {
    return '-';
  }
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var date1 = inputFormat.parse(dateIs);

  var outputFormat = DateFormat('hh:mm a');
  return outputFormat.format(date1);
}

//  Formate date change
String date_in_dmy(date) {
  var tempDate = date.split("-");
  var dateIs = "${tempDate[2]}/${tempDate[1]}/${tempDate[0]}";
  return dateIs;
}

// Date Formate Function
String date_in_DMY(dateIs) {
  if (dateIs == '' || dateIs == null) {
    return '-';
  }
  var inputFormat = DateFormat('yyyy-MM-dd');
  var date1 = inputFormat.parse(dateIs);

  var outputFormat = DateFormat('MMM dd, yyyy');
  return outputFormat.format(date1);
}

// PHP Formate date change
String date_in_php(date) {
  var tempDate = date.split("/");
  var dateIs = "${tempDate[2]}-${tempDate[0]}-${tempDate[1]}";
  return dateIs;
}

// PHP Formate date change
String datuu(dateIsrr) {
  DateTime nnvv = DateTime.parse(dateIsrr);
  String dateIsdd = DateFormat('yyyy-MM-dd').format(nnvv);
  return dateIsdd;
}

// PHP Formate date change
String time_in_php(time) {
  var temp = time.split(" ");
  var tempTime = temp[0].split(":");
  var finalTime = (temp[1].toLowerCase() == 'am')
      ? tempTime[0]
      : (int.parse(tempTime[0].toString()) + 12).toString();
  finalTime = "$finalTime:${tempTime[1]}:00";
  return finalTime;
}

// PHP dateTIme to min only
date_diff_min(dateIs, {isHours: false}) {
  var temp = dateIs.split(" ");
  var tempDate = temp[0].split("-");
  var tempTime = temp[1].split(":");
  var y = int.parse(tempDate[0].toString());
  var m = int.parse(tempDate[1].toString());
  var d = int.parse(tempDate[2].toString());

  var h = int.parse(tempTime[0].toString());
  var min = int.parse(tempTime[1].toString());

  DateTime b = DateTime(y, m, d, h, min);
  DateTime a = DateTime.now();

  Duration difference = b.difference(a);

  int days = difference.inDays;
  int hours = difference.inHours;
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds;

  if (isHours == true) {
    var TempHours = difference.inHours % 24;
    var TempMinutes = difference.inMinutes % 60;

    return (minutes > 60 * 24)
        ? "${days.toString()} Days"
        : (TempHours == 0)
            ? "${TempMinutes.toString()} Min"
            : "${TempHours.toString()} : ${TempMinutes.toString()} Min";
  } else {
    return minutes;
  }
}

// Capitalization ===========================
String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

// key to text
key_to_text(String str) {
  var temp = str.replaceAll("_", " ");
  return capitalize(temp);
}

///// Int Value  in  Time Formate Convertor MM:SS++++++
String formatTime(int seconds) {
  int minutes = seconds ~/ 60; // Get the minutes by integer division
  int remainingSeconds = seconds % 60; // Get the remaining seconds

  // Format the time as "mm:ss"
  String formattedTime =
      '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

  return formattedTime;
}

///
TimeStamp_for_today_query() {
  final date = DateTime.now();
  var newDate = DateTime(date.year, date.month, date.day - 1, 24);
  return newDate;
}

TimeStamp_for_last7_query() {
  final date = DateTime.now();
  var newDate = DateTime(date.year, date.month, date.day - 7, 00);
  return newDate;
}

TimeStamp_for_last30_query() {
  final date = DateTime.now();
  var newDate = DateTime(date.year, date.month, date.day - 30, 00);
  return newDate;
}

yearStamp_for_query() {
  final date = DateTime.now();
  var newDate = DateTime(date.year, 01, 00, 24);
  return newDate;
}
