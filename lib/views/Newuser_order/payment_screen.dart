// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names, unused_element, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/qrcode.dart';

import 'package:get/get.dart';

import '../../controllers/newuser_order_controller.dart';

import '../widgets/normal_text.dart';
import 'NewUser_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.OrderID}) : super(key: key);
  final OrderID;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var controller = Get.put(NewUserOrderController());

  @override
  void initState() {
    super.initState();
  }

  var PayType = "online";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: clientAppBar(),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          themeHeaderHome(context, title: "Payment"),

          25.heightBox,
          // Container(
          //     margin: EdgeInsets.only(left: 10, bottom: 10),
          //     child: GoogleText(
          //         text: "Select Payment Type ..",
          //         fsize: 18.0,
          //         fweight: FontWeight.bold)),
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
                                  text: "QR Code Scan",
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
                            size: 40,
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
                            size: 40,
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
          if (PayType == "offline")
            Container(
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                            prefixIcon:
                                Icon(Icons.money, color: Colors.blue, size: 25),
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
          }, buttonColor: Colors.green, label: "Proceed to Payment")
        ],
      ),
    );
  }
}
