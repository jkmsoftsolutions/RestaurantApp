import 'package:emart_seller/const/const.dart';

class StoreServices {
  //get profile details ===================================
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollections)
        .where('id', isEqualTo: uid)
        .get();
  }

//get orders detail =========================================
  static getOrders(uid) {
    return firestore
        .collection(ordersCollections)
        .where('vendors', arrayContains: uid)
        .orderBy('order_date', descending: true)
        .snapshots();
  }

  static getOrdersRecent(uid) {
    var r = firestore
        .collection(ordersCollections)
        .orderBy('order_date', descending: true)
        .where('vendors', arrayContains: uid)
        .limit(20)
        .snapshots();
    return r;
  }

  //get products details ====================================
  static getProducts(uid) {
    return firestore
        .collection(productsCollections)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  //get tables details
  static gettables(uid) {
    return firestore
        .collection(tablesCollections)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  //get all data list
  static getCounts(uid) async {
    var res = await Future.wait([
      firestore
          .collection(productsCollections)
          .where('vendor_id', isEqualTo: uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollections)
          .where('vendors', arrayContains: uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore.collection(usersCollections).where('user').get().then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollections)
          .where("order_delivered", isEqualTo: true)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }
}
