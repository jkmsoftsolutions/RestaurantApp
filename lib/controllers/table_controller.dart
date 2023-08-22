import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get.dart';

class TablesController extends GetxController {
  var isloading = false.obs;

//text field controller

  var tnameController = TextEditingController();
  var tdescController = TextEditingController();
  var tadminController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var currentSelectedValue;

  cleartext() {
    tnameController.clear();
    tdescController.clear();
    tadminController.clear();
  }

// upload products method

  uploadProduct(context) async {
    var store = firestore.collection(tablesCollections).doc();
    await store.set({
      'is_active': false,
      't_desc': tdescController.text,
      't_floor': currentSelectedValue,
      't_admin': tadminController.text,
      'tab_no': tnameController.text,
      'vendor_id': currentUser!.uid,
      'active_id': '',
    });
    isloading(false);
    VxToast.show(context, msg: "Table Add Successfully");
    cleartext();
  }

//filter featured product

  addFeatured(docId) async {
    await firestore.collection(tablesCollections).doc(docId).set({
      'active_id': currentUser!.uid,
      'is_active': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(tablesCollections).doc(docId).set({
      'active_id': '',
      'is_active': false,
    }, SetOptions(merge: true));
  }

  //Delete product method
  removeProduct(docId) async {
    await firestore.collection(tablesCollections).doc(docId).delete();
  }
}
