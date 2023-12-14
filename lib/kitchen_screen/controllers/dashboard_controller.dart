// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme/function.dart';

class KDashboardController extends GetxController {
  var orders = [];
  var orderList = [];
  int totalAmount = 0;
  int totalSale = 0;
  int totayAmount = 0;
  int lastayAmount = 0;
  var orderbydate = [];
  var Todayorder = 0;
  var db = FirebaseFirestore.instance;

///////////  Calling today  Order data +++++++++++++++++++++++++++
  Map<String, dynamic> orderdata = {};
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Todaydata() async {
    var dbData;
    var searchDate = TimeStamp_for_today_query();

    // get details

    orderbydate.clear();
    orderdata = {};
    Map<int, dynamic> returnData2 = new Map();
    // Raw Query ==============================
    if (dbData == null) {
      var query = await FirebaseFirestore.instance
          .collection('orders')
          .where("date_at", isGreaterThan: searchDate)
          .get()
          .then(
        (value) {
          int k = 0;

          for (var doc in value.docs) {
            //returnData2[doc.id] = doc.data();
            Map<String, dynamic> temp = doc.data();
            temp['id'] = doc.id;
            returnData2[k] = temp;
            k++;
          }
          return returnData2;
        },
      );
    }

    return returnData2.length;
  }

//calling pending order data===================================

  var penddingpro = {};
  var temp;
  var total;
  var pendingProductList = {};
  Penddingorder_Data() async {
    penddingpro = {};
    pendingProductList.clear();
    Map<dynamic, dynamic> w = {
      'table': "orders",
    };

    var rdata = await dbFindDynamic(db, w);

    // print('${rdata}---==++');

    // Raw Query ==============================

    var query = await FirebaseFirestore.instance
        .collection('orders')
        .where("order_delivered", isEqualTo: false);
    rdata = await dbRawQuery(query);

    rdata.forEach((k, v) {
      var tempProdcut = v['orders'];
      tempProdcut.forEach((vl) {
        if (vl['isPrepared'] == false) {
          var newTotal = int.parse(vl['qty'].toString());
          var withTableNo = {'table': v['order_table'], 'qnt': newTotal};
          if (pendingProductList[vl['id']] != null) {
            var temp = pendingProductList[vl['id']];
            temp['tPending'] =
                int.parse(temp['tPending'].toString()) + newTotal;
            // total with table
            var tList = (temp['table_list'] == null) ? [] : temp['table_list'];
            tList.add(withTableNo);
            temp['table_list'] = tList;
            pendingProductList[vl['id']] = temp;
          } else {
            var temp = vl;
            temp['tPending'] = newTotal;
            // total with table
            var tList = (temp['table_list'] == null) ? [] : temp['table_list'];
            tList.add(withTableNo);
            temp['table_list'] = tList;
            pendingProductList[vl['id']] = temp;

            print('${temp}---====');
          }
        }
      });
    });

    print("================================================");
    print(pendingProductList);
  }
}
