import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../theme/firebase_functions.dart';
import '../theme/function.dart';

class DashboardController extends GetxController {
  var orders = [];
  var orderList = [];
  int totalAmount = 0;
  int totayAmount = 0;

  var orderbydate = [];
  var db = FirebaseFirestore.instance;

///////////  Calling Order data +++++++++++++++++++++++++++
  Map<String, dynamic> orderdata = {};

  Ordersdata() async {
    totalAmount = 0;

    orderbydate.clear();
    orderdata = {};
    var dbData;
    // get details

    // Raw Query ==============================
    if (dbData == null) {
      var query = await FirebaseFirestore.instance
          .collection('orders')
          .where("order_delivered", isEqualTo: true);
      dbData = await dbRawQuery(query);
    }
    // set data in map & calculate ==============================
    dbData.forEach((k, v) {
      totalAmount += int.parse(v['total_amount'].toString());
      orderbydate.add(v);
    });
    return orderbydate;
  }

  Todaydata() async {
    totayAmount = 0;

    var searchDate = TimeStamp_for_today_query();
    orderbydate.clear();
    orderdata = {};

    var dbData;
    // get details

    // Raw Query ==============================
    if (dbData == null) {
      var query = await FirebaseFirestore.instance
          .collection('orders')
          .where("date_at", isGreaterThan: searchDate);
      dbData = await dbRawQuery(query);
    }

    // set data in map & calculate ==============================
    dbData.forEach((k, v) {
      totayAmount += int.parse(v['total_amount'].toString());
    });
    return totayAmount;
  }
}
