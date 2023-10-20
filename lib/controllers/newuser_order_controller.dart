// ignore_for_file: non_constant_identifier_names, sdk_version_since, await_only_futures, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unused_element, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/category_model.dart';
import '../theme/firebase_functions.dart';
import '../views/Newuser_order/thankyouScreen.dart';

class NewUserOrderController extends GetxController {
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  var isloading = false.obs;
//text field controller
  var searchController = TextEditingController();
  var pNameController = TextEditingController();
  var pMobileController = TextEditingController();
  var pEmailController = TextEditingController();
  var pAddressController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  var payment_description = TextEditingController();
  var quantity = 1.obs;
  var totalPrice = 0.obs;
  var TempValue = {};
  var IDdata;
  Map<dynamic, dynamic> selectedProduct = {};
  Map<dynamic, dynamic> cartData = {};

  int total = 0;

  String selectProName = "";
  String selectProPrice = "";
  List SelectProList = [];
  List<Category> category = [];
  var pImagesLinks = [];
  var selectedtableIndex = 0.obs;
  var db = FirebaseFirestore.instance;
  List allproductsdata = [];
  storeUserData() async {
    DocumentReference store =
        await firestore.collection("user").doc(currentUser!.uid);
    store.set({
      'name': TempValue["name"],
      'email': TempValue["email"],
      "mobile": TempValue["phone"],
      "Address": TempValue["Address"],
      'imageUrl': '',
      'id': currentUser!.uid,
      'wishlist_count': "00",
      'cart_count': "00",
      'order_count': "00",
    });
    return "${currentUser!.uid}";
  }

  // add attribute Funciton
  List orderData = [];
  fnOrderAdd(context) async {
    // default value
    var dbArr = {
      'table': "orders",
      'order_code': generateRandomOrderNumber(),
      'order_by': TempValue["customer_id"],
      "order_by_name": TempValue["name"],
      "order_by_email": TempValue["email"],
      "order_by_address": TempValue["Address"],
      "order_by_phone": TempValue["phone"],
      'order_table': TempValue["table_id"],
      "status": "1",
      'order_date': FieldValue.serverTimestamp(),
      'shipping_method': "Resturant Delivery",
      'payment_method': "orderPaymentMethod",
      'payment_id': '',
      'type': 'Shope',
      'order_placed': true,
      'order_delivered': false,
      'order_confirmed': false,
      'order_on_delivery': false,
      'total_amount': "${total}",
      'vendors': "${currentUser!.uid}",
      'orders': orderData,
      'date_at': DateTime.timestamp(),
      'update_at': '',
    };
    var data = await dbSave(db, dbArr);
    // await themeAlert(context, "Succefully Submited !! ");
    return "$data";
  }

  //table method
  changeTableIndex(index) {
    selectedtableIndex.value = index;
  }

  // clear controllers data
  cleartext() {
    pNameController.clear();
    pMobileController.clear();
    pAddressController.clear();
    pEmailController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquantityController.clear();
    payment_description.clear();
    TempValue.clear();
    cartData.clear();
    selectedProduct.clear();
  }

  // calculate total ========================================
  calculateTotal(data, type) {
    cartData[data.id] =
        (cartData[data.id] == null) ? data.data() : cartData[data.id];
    var temp = cartData[data.id];
    if (type == 'incr') {
      temp['qnt'] =
          (temp['qnt'] == null) ? 1 : int.parse(temp['qnt'].toString()) + 1;
      cartData[data.id] = temp;
    } else {
      if (temp['qnt'] != null && temp['qnt'] == 0 || temp['qnt'] == 1) {
        cartData.remove(data.id);
      } else {
        temp['qnt'] =
            (temp['qnt'] == null) ? 0 : int.parse(temp['qnt'].toString())! - 1;
        cartData[data.id] = temp;
      }
    }

    // total calculate
    total = 0;

    cartData.forEach((id, v) {
      var subTotal =
          int.parse(v['qnt'].toString()) * int.parse(v['p_price'].toString());
      v['subTotal'] = subTotal;
      total = total + subTotal;
    });
  }

  generateRandomOrderNumber() {
    Random random = Random();
    int orderNumber =
        random.nextInt(900000) + 100000; // Generates a 6-digit random number
    return "ORD$orderNumber"; // Adding a prefix "ORD" to the random number
  }

  handlePaymentSuccess(context, paymentType, OrderId) async {
    // update order talbe
    var Ofield = {
      'table': "orders",
      'id': "$OrderId",
      'payment_id': "paymentId",
      'payment_method': '$paymentType',
      'update_at': DateTime.timestamp(),
    };
    await dbUpdate(db, Ofield);

    //FirebaseFirestore.instance.collection(paymentCollection).add({});
    // Fluttertoast.showToast(msg: " Payment Successfully");
    themeAlert(context, " Payment Successfully");
    // Get.offAll(const Home());
    nextScreenReplace(context, ThankScreen(OrderId: OrderId));
    await cleartext();
    // Get.to(const ThankScreen());
  }

  handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment failed");
  }

  handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Payment Successfully");
  }

  // clear controllers
}
