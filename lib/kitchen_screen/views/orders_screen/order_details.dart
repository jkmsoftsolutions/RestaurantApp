// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:async';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/kitchen_screen/controllers/dashboard_controller.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import '../../controllers/orders_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KOrderDetails extends StatefulWidget {
  final dynamic id;

  const KOrderDetails({super.key, this.id});

  @override
  State<KOrderDetails> createState() => _KOrderDetailsState();
}

class _KOrderDetailsState extends State<KOrderDetails> {
  var controller = Get.put(KOrdersController());
  var kcontroller = Get.put(KDashboardController());

  bool _hasBeenPressed = false;
  Map<dynamic, dynamic> productData = new Map();
  var db = FirebaseFirestore.instance;

  fnGetOrderDetails() async {
    var dbData = await dbFind({'table': 'orders', 'id': widget.id});
    setState(() {
      productData = dbData;
      productData['id'] = widget.id;
      controller.getOrders(productData);
      controller.confirmed.value = (productData['order_confirmed'] != null)
          ? productData['order_confirmed']
          : false;
      controller.ondelivery.value = (productData['order_on_delivery'] != null)
          ? productData['order_on_delivery']
          : false;
      controller.delivered.value = (productData['order_delivered'] != null)
          ? productData['order_delivered']
          : false;
    });
  }

  //timer start function

  late Timer _timer;
  var _secondCount = 0;

  //end timer function

  @override
  void initState() {
    super.initState();

    fnGetOrderDetails();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        this._secondCount += 1;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var min;
  var sec;

  @override
  Widget build(BuildContext context) {
    if (productData.isNotEmpty && productData != null) {
      var temp = productData["order_date"];
      DateTime date = temp.toDate();
      var currentTime = DateTime.now();
      var diff = currentTime.difference(date).inSeconds;
      setState(() {
        sec = diff % 60;

        min = (diff / 60).floor();
      });

      print("$temp ++++++++++");
    } else {
      print("object");
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              //Get.back();
              Navigator.pop(context, 'updated');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            ),
          ),
          title: boldText(text: "Order details", color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
              height: 60,
              width: context.screenWidth,
              child: ourButton(
                  color: green,
                  onPress: () {
                    controller.confirmed(true);
                    controller.changeStatus(
                        title: "order_confirmed",
                        status: true,
                        docID: productData['id']);
                  },
                  title: "Confirm Order")),
        ),
        body: (productData.isEmpty)
            ? progress()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      //order delvery status section
                      Visibility(
                        visible: controller.confirmed.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                boldText(
                                    text: "ORDER STATUS:",
                                    color: purpleColor,
                                    size: 16.0),
                                Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: black,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$min:$sec :min',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                            255, 252, 251, 251),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            20.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Container(
                                      child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Placed'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 12, 177, 45)
                                        // This is what you need!
                                        ),
                                  )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.changeStatus(
                                        title: "Confirmed",
                                        status: controller.confirmed.value,
                                        docID: productData['id']);
                                  },
                                  child: Container(
                                      child: ElevatedButton(
                                    onPressed: () => setState(() => controller
                                        .confirmed
                                        .value = !controller.confirmed.value),
                                    child: Text(controller.confirmed.value
                                        ? 'Confirmed'
                                        : 'Confirmed'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                              .confirmed.value
                                          ? Color.fromARGB(255, 12, 177, 45)
                                          : const Color.fromARGB(255, 163, 162,
                                              162), // This is what you need!
                                    ),
                                  )),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.ondelivery.value =
                                            !controller.ondelivery.value;
                                      });
                                      controller.changeStatus(
                                          title: "order_on_delivery",
                                          status: controller.ondelivery.value,
                                          docID: productData['id']);
                                    },
                                    child: Text(controller.ondelivery.value
                                        ? 'preparing'
                                        : 'preparing'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                              .ondelivery.value
                                          ? Color.fromARGB(255, 12, 177, 45)
                                          : const Color.fromARGB(255, 163, 162,
                                              162), // This is what you need!
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.delivered.value =
                                            !controller.delivered.value;
                                      });
                                      controller.changeStatus(
                                          title: "order_delivered",
                                          status: controller.delivered.value,
                                          docID: productData['id']);
                                    },
                                    child: Text(controller.delivered.value
                                        ? 'Deliverd'
                                        : 'Deliverd'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                              .delivered.value
                                          ? Color.fromARGB(255, 12, 177, 45)
                                          : const Color.fromARGB(255, 163, 162,
                                              162), // This is what you need!
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.all(8.0))
                            .margin(const EdgeInsets.only(bottom: 10.0))
                            .outerShadowMd
                            .white
                            .border(color: lightGrey)
                            .roundedSM
                            .make(),
                      ),

                      //order details section
                      10.heightBox,
                      boldText(
                          text: "ORDERED PRODUCTS",
                          color: fontGrey,
                          size: 16.0),
                      10.heightBox,
                      Column(
                        children: [
                          GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.orders.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 200),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hasBeenPressed = !_hasBeenPressed;
                                    });
                                  },
                                  child: Container(
                                    color: _hasBeenPressed
                                        ? Color.fromARGB(255, 16, 176, 72)
                                        : const Color.fromARGB(
                                            255, 238, 234, 234),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          controller.orders[index]['img'],
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        //  const Spacer(),
                                        10.heightBox,
                                        "${controller.orders[index]['title']}"
                                            .text
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "Quntity : ${controller.orders[index]['qty']}"
                                            .text
                                            .color(redColor)
                                            .size(16)
                                            .make(),
                                      ],
                                    )
                                        .box
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .roundedSM
                                        .padding(const EdgeInsets.all(12))
                                        .make()
                                        .onTap(() {
                                      setState(() {
                                        _hasBeenPressed = !_hasBeenPressed;
                                      });
                                    }),
                                  ),
                                );
                              }),
                        ],
                      ),
                      10.heightBox,
                      //order details section
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
