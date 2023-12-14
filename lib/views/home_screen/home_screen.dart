import 'package:emart_seller/responsive/responsive.dart';
import 'package:emart_seller/theme/footer.dart';
import 'package:emart_seller/views/widgets/theme_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
// import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/products_screen/products_screen.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../../controllers/dashboard_controller.dart';
import '../widgets/appbar_widget.dart';
import '../../theme/function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(DashboardController());
  @override
  void initState() {
    get_Orderdata();
    get_odaydata();
    get_last3aydata();
    super.initState();
  }

  bool wait = true;
  var OrderList = [];
  get_Orderdata() async {
    OrderList = [];
    OrderList = await controller.totalSaleFn();
    setState(() {
      OrderList;
      wait = false;
    });
  }

  var TodayList = [];
  get_odaydata() async {
    await controller.Todaydata();
    setState(() {
      wait = false;
    });
  }

  var last30dayList = [];
  get_last3aydata() async {
    await controller.lastdaydata();
    setState(() {
      wait = false;
    });
  }

  Widget build(BuildContext context) {
    Get.put(OrdersController());
    return Scaffold(
      backgroundColor: themeBG8,
      appBar: appbarWidget(dashboard),
      bottomNavigationBar: themeFooter(context, selected: 0),
      body: StreamBuilder(
          stream: StoreServices.getOrdersRecent(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              // print("-----");
              // print(data[0].data());

              // data = data.sortedBy(
              //     (a, b) => b['order_date'].compareTo(a['order_date']));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: StoreServices.getCounts(currentUser!.uid),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return LoadingIndicator();
                          } else {
                            var countData = snapshot.data;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProductsScreen());
                                      },
                                      child: Container(
                                        child: dashboardButton(
                                          context,
                                          title: products,
                                          count: countData[0].toString(),
                                          icon: icProducts,
                                        )
                                            .box
                                            .shadowLg
                                            .rounded
                                            .color(themeBG)
                                            .make(),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => OrdersScreen());
                                      },
                                      child: dashboardButton(context,
                                              title: orders,
                                              count: countData[1].toString(),
                                              icon: icOreders)
                                          .box
                                          .shadowLg
                                          .rounded
                                          .color(themeBG)
                                          .make(),
                                    ),
                                  ],
                                ),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    dashboardButton(context,
                                            title: listUser,
                                            count: countData[2].toString(),
                                            icon: icProfile)
                                        .box
                                        .shadowLg
                                        .rounded
                                        .color(themeBG)
                                        .make(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => OrdersScreen());
                                      },
                                      child: dashboardButton(context,
                                              title: "Total Sale",
                                              count: '₹${controller.totalSale}',
                                              icon: trend)
                                          .box
                                          .shadowLg
                                          .rounded
                                          .color(themeBG)
                                          .make(),
                                    ),
                                  ],
                                ),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => OrdersScreen());
                                      },
                                      child: dashboardButton(context,
                                              title: 'Today Sales',
                                              count:
                                                  '₹${controller.totayAmount}',
                                              icon: sale_icon)
                                          .box
                                          .shadowLg
                                          .rounded
                                          .color(themeBG)
                                          .make(),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => OrdersScreen());
                                      },
                                      child: dashboardButton(context,
                                              title: 'Sales 30 Days',
                                              count:
                                                  '₹${controller.lastayAmount}',
                                              icon: sale_icon)
                                          .box
                                          .shadowLg
                                          .rounded
                                          .color(themeBG)
                                          .make(),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        }),
                    10.heightBox,
                    const Divider(),
                    5.heightBox,
                    boldText(
                        text: 'Recent Orders', color: darkGrey, size: 16.0),
                    4.heightBox,
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            data.length,
                            (index) => data[index]['order_code'].length == 0
                                ? const SizedBox()
                                : themeOderListRowCon(context, data[index],
                                    productId: data[index].id,
                                    reloadFun: get_Orderdata)),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
