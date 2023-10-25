// ignore_for_file: non_constant_identifier_names, sdk_version_since, await_only_futures, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unused_element, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/category_model.dart';
import '../theme/firebase_functions.dart';
import '../views/Newuser_order/thankyouScreen.dart';

class NewUserOrderController {
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  var isloading = false;
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
  var quantity = 1;
  var totalPrice = 0;
  var TempValue = {};
  var IDdata;
  Map<dynamic, dynamic> selectedProduct = {};
  Map<dynamic, dynamic> cartData = {};
  Map<dynamic, dynamic> productAllList = {};
  Map<dynamic, dynamic> productList = {};
  String orderId = '';
  var editData = {};

  List orderData = [];

  int total = 0;

  String selectProName = "";
  String selectProPrice = "";
  List SelectProList = [];
  List<Category> category = [];
  var pImagesLinks = [];
  var selectedtableIndex = 0;
  var db = FirebaseFirestore.instance;
  List allproductsdata = [];

  initController({docId: ''}) async {
    await getProductList();
    if (docId != '') {
      await getOrderDetails(docId);

      var isloading = false;
      //text field controller

      orderId = IDdata = docId;

      searchController = TextEditingController();
      pNameController.text = editData['order_by_name'];
      pEmailController.text = editData['order_by_email'];
      pMobileController.text = editData['order_by_phone'];
      pAddressController.text = editData['order_by_address'];

      for (var tempOrder in editData['orders']) {
        var productArr = productAllList[tempOrder['id']];

        await calculateTotal(productArr, 'incr', editQnt: tempOrder['qty']);
      }

      // print(cartData);

      TempValue["table_id"] = editData['order_table'];

      // pdescController = TextEditingController();
      // ppriceController = TextEditingController();
      // pquantityController = TextEditingController();
      // payment_description = TextEditingController();

      // quantity = 1;
      // totalPrice = 0;
      // selectedProduct = {};
      // orderData = [];

      // int total = 0;

      // selectProName = "";
      // selectProPrice = "";
      // SelectProList = [];
      // category = [];
      // pImagesLinks = [];
      // selectedtableIndex = 0;
      // allproductsdata = [];
    }
  }

  // get oder details
  getOrderDetails(docId) async {
    editData = await dbFind({'table': 'orders', 'id': docId});
    return editData;
  }

  // new user store
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

  // get active product list ============================
  getProductList() async {
    productList = {};
    var dbData =
        await dbFindDynamic(db, {'table': 'products', 'status': 'Active'});

    dbData.forEach((k, v) {
      productList[v['id']] = v;
    });

    productAllList = productList;
  }

  // ====================================================
  SearchFn(query, {filter: ''}) {
    List<String> searchField = ['p_name'];
    if (filter != '') {
      searchField = ['type'];
      query = (query == 'All') ? '' : query;
    }

    productList = {};

    productAllList.forEach((k, e) {
      bool isFind = false;
      searchField.forEach((key) {
        var val = '${e['$key']}';
        if (!isFind &&
            e['$key'] != null &&
            val.toLowerCase().contains(query.toLowerCase())) {
          productList[k] = e;
          isFind = true;
        }
      });
    });

    // productAllList.forEach((k, e) {
    //   print("----$k");
    //   bool isFind = false;
    //   k.forEach((key) {
    //     if (!isFind &&
    //         k['$key'] != null &&
    //         val.toLowerCase().contains(query.toLowerCase())) {
    //       //OrderList.add(e);
    //       //productList[k] = val;
    //       print("sdfdf");

    //       isFind = true;
    //     }
    //   });
    // });
  }

  // add attribute Funciton

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
      'shipping_method': "Resturant Delivery",
      'payment_method': "",
      'payment_status': "",
      'payment_id': '',
      'type': 'Shop',
      'order_placed': true,
      'order_delivered': false,
      'order_confirmed': true,
      'order_on_delivery': false,
      'total_amount': "${total}",
      'vendors': "${currentUser!.uid}",
      'orders': orderData,
      'date_at': DateTime.timestamp(),
      'order_date': DateTime.timestamp(),
      'update_at': '',
    };

    // print(dbArr);
    // return false;

    if (orderId == '') {
      orderId = await dbSave(db, dbArr);
    } else {
      // update
      dbArr.remove('payment_id');
      dbArr.remove('date_at');
      dbArr.remove('order_date');
      dbArr.remove('type');
      dbArr.remove('status');
      dbArr.remove('payment_method');
      dbArr.remove('payment_status');
      dbArr.remove('order_placed');
      dbArr.remove('order_delivered');
      dbArr.remove('order_on_delivery');
      dbArr['update_at'] = DateTime.timestamp();
      dbArr['updated_by'] = "Admin";
      dbArr['id'] = orderId;

      //print(dbArr);
      await dbUpdate(db, dbArr);
    }

    //themeAlert(context, "Succefully Submited !! ");
    return "$orderId";
  }

  //table method
  changeTableIndex(index) {
    selectedtableIndex = index;
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
  calculateTotal(data, type, {editQnt: ''}) async {
    cartData[data['id']] =
        (cartData[data['id']] == null) ? data : cartData[data['id']];
    var temp = cartData[data['id']];

    if (editQnt == '') {
      if (type == 'incr') {
        temp['qnt'] =
            (temp['qnt'] == null) ? 1 : int.parse(temp['qnt'].toString()) + 1;
        cartData[data['id']] = temp;
      } else {
        if (temp['qnt'] != null && temp['qnt'] == 0 || temp['qnt'] == 1) {
          cartData.remove(data['id']);
        } else {
          temp['qnt'] = (temp['qnt'] == null)
              ? 0
              : int.parse(temp['qnt'].toString())! - 1;
          cartData[data['id']] = temp;
        }
      }
    } else {
      // set edit data
      temp['qnt'] =
          (temp['qnt'] == null) ? 1 : int.parse(temp['qnt'].toString()) + 1;
      cartData[data['id']] = temp;
    }

    // total calculate
    total = 0;

    cartData.forEach((id, v) {
      var subTotal =
          int.parse(v['qnt'].toString()) * int.parse(v['p_price'].toString());
      v['subTotal'] = subTotal;
      total = total + subTotal;
    });

    TempValue["items_data"] = cartData;
    return cartData;
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
      'payment_id': "-",
      "pay_notes": payment_description.text,
      'payment_status': '1',
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

  // add new customer
  addNewCustomer(context) async {
    var alert = '';
    if (pNameController.text.length < 3) {
      alert = 'Customer Name Requred!!';
    } else if (pMobileController.text.length < 10) {
      alert = 'Valid Mobile Number Requred!!';
    }

    if (alert != '') {
      themeAlert(context, alert, type: 'error');
      return false;
    }

    var Cust_ID = await storeUserData();

    TempValue["name"] = "${pNameController.text}";
    TempValue["email"] = "${pEmailController.text}";
    TempValue["phone"] = "${pMobileController.text}";
    TempValue["Address"] = "${pAddressController.text}";
    TempValue["customer_id"] = "$Cust_ID";

    return Cust_ID;
  }

  // clear controllers
}
