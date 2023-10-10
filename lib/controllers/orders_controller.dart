import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/firebase_consts.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../theme/firebase_functions.dart';

class OrdersController extends GetxController {
  var orders = [];
  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
  var orderList = [];
  int totalAmount = 0;

  var orderbydate = [];
  var db = FirebaseFirestore.instance;

///////////  Calling Order data +++++++++++++++++++++++++++
  Map<String, dynamic> orderdata = {};
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Ordersdata(Type) async {
    totalAmount = 0;
    var dbData;
    var searchDate = TimeStamp_for_today_query();
    if (Type == "all") {
      Map<dynamic, dynamic> w = {
        'table': 'orders',
      };
      dbData = await dbFindDynamic(db, w);
    } else if (Type == "last7") {
      // last 7 days
      searchDate = TimeStamp_for_last7_query();
    } else if (Type == "yearly") {
      searchDate = yearStamp_for_query();
    } else if (Type == "last30") {
      searchDate = TimeStamp_for_last30_query();
    }

    // get details

    orderbydate.clear();
    orderdata = {};

    // Raw Query ==============================
    if (dbData == null) {
      var query = await FirebaseFirestore.instance
          .collection('orders')
          .where("date_at", isGreaterThan: searchDate);
      dbData = await dbRawQuery(query);
    }

    // set data in map & calculate ==============================
    dbData.forEach((k, v) {
      totalAmount += int.parse(v['total_amount'].toString());
      orderbydate.add(v);
    });
    return orderbydate;
  }

//get data orders fillter
  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  //get mathed change orders status
  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollections).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }
}
