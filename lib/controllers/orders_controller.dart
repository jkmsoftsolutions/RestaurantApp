import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/firebase_consts.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  var orders = [];
  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
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
