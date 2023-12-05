import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/firebase_consts.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theme/firebase_functions.dart';

class KOrdersController extends GetxController {
  var orders = [];
  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
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

      var p = {
        'table': 'orders',
        // 'order_by_phone': '4455443322',
        'order_delivered': false,
      };

      dbData = await dbFindDynamic(db, {
        'table': 'orders',
        // 'order_by_phone': '4455443322',
        'order_delivered': false,
      });

      // var hh = FirebaseFirestore.instance;
      // dbData = hh
      //     .collection("orders")
      //     .where("order_delivered", isEqualTo: false)
      //     .get()
      //     .then((value) {
      //   print("${value.docs.asMap()}   ====8888888");
      // });
      //searchDate = TimeStamp_for_last7_query();
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
      if (v['total_amount'] != null) {
        totalAmount += int.parse(v['total_amount'].toString());
        orderbydate.add(v);
      }
    });

    return orderbydate;
  }

//get data orders fillter
  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      orders.add(item);
    }
  }

  //get mathed change orders status
  changeStatus({title, status, docID}) async {
    //var store = firestore.collection(ordersCollections).doc(docID);
    //await store.set({title: status}, SetOptions(merge: true));
    await dbUpdate(db, {'table': 'orders', 'id': docID, '$title': status});
  }
}
