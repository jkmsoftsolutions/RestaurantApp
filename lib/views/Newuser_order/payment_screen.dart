// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names, unused_element, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/qrcode.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import '../../controllers/newuser_order_controller.dart';
import '../widgets/normal_text.dart';
import 'new_order_helper_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/razorpay_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.OrderID, this.controller})
      : super(key: key);
  final OrderID;
  final controller;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var controller;
  var db = FirebaseFirestore.instance;
  Razorpay? _razorpay;

  bool _clicked = false;

  @override
  void initState() {
    controller = widget.controller;
    _razorpay = Razorpay();
    _razorpay?.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, controller.handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, controller.handlePaymentError);
    _razorpay?.on(
        Razorpay.EVENT_EXTERNAL_WALLET, controller.handleExternalWallet);

    super.initState();
  }
  //Create method Razorpay intrigation

  Future<dynamic> createOrder() async {
    var amount = "${controller.total}";
    var mapHeader = <String, String>{};
    mapHeader['Authorization'] =
        "Basic cnpwX3Rlc3RfU2RHQmFoV3RsS1dNd2I6Mlh2WElOSDlMcG9xTHdyU3F5cDFzam5y";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = <String, String>{};
    setState(() {
      map['amount'] = "${(num.parse(amount) * 100)}";
    });
    map['currency'] = "INR";
    map['receipt'] = "receipt1";
    print("map $map");
    var response = await http.post(Uri.https("api.razorpay.com", "/v1/orders"),
        headers: mapHeader, body: map);
    print("...." + response.body);
    if (response.statusCode == 200) {
      RazorpayOrderResponse data =
          RazorpayOrderResponse.fromJson(json.decode(response.body));

      openCheckout(data);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    var amount = "${controller.total}";
    var options = {
      'key': RazorpayApiKey,
      'amount': "${(num.parse(amount) * 100)}",
      'name': 'Restaurants ',
      'description': '',
      'order_id': '${data.id}',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  //stop method Razorpay intrigation

  var PayType = "online";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: clientAppBar(),
      ),
      body: (controller == null)
          ? progress()
          : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                themeHeaderHome(context, title: "Payment"),
                25.heightBox,
                Container(
                  child: Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            PayType = "online";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(10),
                            height: 85,
                            decoration: BoxDecoration(
                                color: (PayType == "online")
                                    ? Color.fromARGB(160, 241, 227, 159)
                                    : Colors.black12,
                                boxShadow: themeBox,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GoogleText(
                                        text: "QR Code",
                                        fsize: 15.0,
                                        color: Colors.black,
                                        fweight: FontWeight.bold),
                                    10.heightBox,
                                    GoogleText(
                                        text: "${controller.total} Rs/-",
                                        fsize: 13.0,
                                        color: Colors.green,
                                        fstyle: FontStyle.italic,
                                        fweight: FontWeight.bold),
                                  ],
                                ),
                                Icon(
                                  Icons.qr_code,
                                  size: 10,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            PayType = "offline";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(10),
                            height: 85,
                            decoration: BoxDecoration(
                                boxShadow: themeBox,
                                color: (PayType == "offline")
                                    ? Color.fromARGB(160, 241, 227, 159)
                                    : Colors.black12,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GoogleText(
                                        text: "Cash Pay",
                                        fsize: 15.0,
                                        color: Colors.black,
                                        fweight: FontWeight.bold),
                                    10.heightBox,
                                    GoogleText(
                                        text: "${controller.total} Rs/-",
                                        fsize: 13.0,
                                        color: Colors.green,
                                        fstyle: FontStyle.italic,
                                        fweight: FontWeight.bold),
                                  ],
                                ),
                                Icon(
                                  Icons.money,
                                  size: 10,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            PayType = "Razorpay";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(10),
                            height: 85,
                            decoration: BoxDecoration(
                                boxShadow: themeBox,
                                color: (PayType == "Razorpay")
                                    ? Color.fromARGB(160, 241, 227, 159)
                                    : Colors.black12,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GoogleText(
                                        text: "Razorpay",
                                        fsize: 15.0,
                                        color: Colors.black,
                                        fweight: FontWeight.bold),
                                    10.heightBox,
                                    GoogleText(
                                        text: "${controller.total} Rs/-",
                                        fsize: 10.0,
                                        color: Colors.green,
                                        fstyle: FontStyle.italic,
                                        fweight: FontWeight.bold),
                                  ],
                                ),
                                Icon(
                                  Icons.money,
                                  size: 10,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ]),
                ),
                10.heightBox,
                if (PayType == "online")
                  Container(
                      height: 250,
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          boxShadow: themeBox,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GoogleText(
                              text: "Scan QR Code",
                              fsize: 16.0,
                              color: Colors.black,
                              fweight: FontWeight.bold),
                          10.heightBox,
                          SizedBox(
                            height: 200,
                            child: QRCode(
                              qrData: "Saurabh",
                            ),
                          ),
                        ],
                      )),
                if (PayType == "Razorpay")
                  Container(
                      height: 250,
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          boxShadow: themeBox,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          20.heightBox,
                          Container(
                            width: 200,
                            child: (_clicked)
                                ? progress()
                                : ElevatedButton.icon(
                                    onPressed: _clicked
                                        ? null
                                        : () {
                                            createOrder();
                                            setState(
                                              () => _clicked = true,
                                            );
                                          },
                                    icon: const Icon(Icons.arrow_forward_sharp),
                                    label: const Center(
                                        child: Text("PROCEED TO  PAY"))),
                          ),
                        ],
                      )),
                if (PayType == "offline")
                  Container(
                      height: 250,
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          boxShadow: themeBox,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GoogleText(
                              text: 'Fill Total Amount',
                              fsize: 18.0,
                              color: Colors.black,
                              fweight: FontWeight.bold),
                          20.heightBox,
                          Container(
                            width: 200,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.money,
                                      color: Colors.blue, size: 25),
                                  fillColor: Colors.grey,
                                  labelText: 'Total Amount',
                                  focusColor: Colors.grey),
                              initialValue: "${controller.total}",
                            ),
                          ),
                        ],
                      )),
                Divider(color: Colors.black12),
                myFormField(context, controller.payment_description, 'Comment',
                    maxLine: 4),
                themeButton3(context, () {
                  controller.handlePaymentSuccess(
                    context,
                    PayType,
                    widget.OrderID,
                  );
                }, buttonColor: Colors.green, label: "Proceed to  Invoice")
              ],
            ),
    );
  }
}
