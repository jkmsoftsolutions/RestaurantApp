import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/new_order_main_view_screen.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import '../../controllers/orders_controller.dart';
import 'components/orders_place_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetails extends StatefulWidget {
  final dynamic id;
  const OrderDetails({super.key, this.id});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();
  Map<dynamic, dynamic> productData = new Map();
  var db = FirebaseFirestore.instance;

  fnGetOrderDetails() async {
    var dbData = await dbFind({'table': 'orders', 'id': widget.id});
    setState(() {
      productData = dbData;
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

  @override
  void initState() {
    super.initState();
    fnGetOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
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
                                (productData['type'].toLowerCase() == 'shop')
                                    ? IconButton(
                                        tooltip: 'Edit Order',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => NewUserScreen(
                                                      orderId: widget.id)));
                                        },
                                        icon: Icon(Icons.edit, color: themeBG4))
                                    : SizedBox()
                              ],
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: true,
                              onChanged: (value) {},
                              title: boldText(text: "Placed", color: fontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.confirmed.value,
                              onChanged: (value) {
                                controller.confirmed.value = value;
                              },
                              title:
                                  boldText(text: "Confirmed", color: fontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.ondelivery.value,
                              onChanged: (value) {
                                controller.ondelivery.value = value;

                                controller.changeStatus(
                                    title: "order_on_delivery",
                                    status: value,
                                    docID: productData['id']);
                              },
                              title: boldText(
                                  text: "on Delivery", color: fontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.delivered.value,
                              onChanged: (value) {
                                controller.delivered.value = value;

                                controller.changeStatus(
                                    title: "order_delivered",
                                    status: value,
                                    docID: productData['id']);
                              },
                              title:
                                  boldText(text: "Delivered", color: fontGrey),
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
                      Column(
                        children: [
                          orderPlaceDetails(
                            d1: "${productData['order_code']}",
                            d2: "${productData['shipping_method']}",
                            title1: "ORDER CODE",
                            title2: "SHIPPING METHOD",
                          ),
                          orderPlaceDetails(
                            // d1:DateTime.now(),
                            d1: intl.DateFormat("h:mma")
                                .add_yMd()
                                .format((productData['order_date'].toDate())),
                            d2: "${productData['payment_method']}",
                            title1: "ORDER DATE",
                            title2: "PAYMENT METHOD",
                          ),
                          orderPlaceDetails(
                            d1: "${(productData['payment_status'] != null && productData['payment_status'] == '1') ? "Paid" : "Unpaid"}",
                            d2: "Order Placed",
                            title1: "PAYMENT STATUS",
                            title2: "DELIVERY STATUS",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "Shipping Address".text.fontFamily(semibold).make(),
                                    boldText(
                                        text: "SHIPPING ADDRESS",
                                        color: purpleColor,
                                        size: 10.0),
                                    "Name : ${productData['order_by_name']}"
                                        .text
                                        .make(),
                                    "Mo: ${productData['order_by_phone']}"
                                        .text
                                        .make(),
                                    (productData['order_by_email'] == null)
                                        ? SizedBox()
                                        : "Email : ${productData['order_by_email']}"
                                            .text
                                            .make(),
                                    (productData['order_by_address'] == null)
                                        ? SizedBox()
                                        : "Address : ${productData['order_by_address']}"
                                            .text
                                            .make(),
                                    (productData['order_by_city'] == null)
                                        ? SizedBox()
                                        : "City: ${productData['order_by_city']}"
                                            .text
                                            .make(),
                                  ],
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      boldText(
                                          text: "Total Amount",
                                          color: purpleColor,
                                          size: 10.0),
                                      boldText(
                                          text:
                                              "₹${productData['total_amount']}",
                                          color: red,
                                          size: 16.0),
                                      (productData['pay_notes'] != null &&
                                              productData['pay_notes'] != '')
                                          ? Text(
                                              "Pay Note :\n(${(productData['pay_notes'] == null) ? '-' : productData['pay_notes']})",
                                              style: themeTextStyle(size: 10.0))
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          .box
                          .outerShadowMd
                          .border(color: lightGrey)
                          .roundedSM
                          .white
                          .make(),
                      const Divider(),
                      10.heightBox,
                      boldText(
                          text: "ORDERED PRODUCTS",
                          color: fontGrey,
                          size: 16.0),
                      10.heightBox,
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            List.generate(controller.orders.length, (index) {
                          return orderItems(data: controller.orders[index]);
                        }).toList(),
                      )
                          .box
                          .outerShadowMd
                          .margin(const EdgeInsets.only(bottom: 10))
                          .white
                          .make(),
                      10.heightBox,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
