import 'package:emart_seller/kitchen_screen/theme/footer.dart';
import 'package:emart_seller/kitchen_screen/views/orders_screen/orders_screen.dart';
import 'package:emart_seller/kitchen_screen/views/widgets/theme_widgets.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/footer.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/widgets/theme_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
// import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/const.dart';
import '../../controllers/dashboard_controller.dart';
import '../widgets/appbar_widget.dart';

class KHomeScreen extends StatefulWidget {
  const KHomeScreen({super.key});
  @override
  State<KHomeScreen> createState() => _KHomeScreenState();
}

class _KHomeScreenState extends State<KHomeScreen> {
  var controller = Get.put(KDashboardController());
  @override
  void initState() {
    get_odaydata();
    Comman_Cate_Data();
    get_pendding();
    super.initState();
  }

  bool wait = true;

  var TodayList = [];
  var Todayorder = 0;
  get_odaydata() async {
    Todayorder = await controller.Todaydata();
    setState(() {
      print(TodayList);
      wait = false;
    });
  }

  var penndingdata = [];
  get_pendding() async {
    await controller.Penddingorder_Data();
    setState(() {
      print(penndingdata);
      wait = false;
    });
  }

  /////////////  table data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

  var tablelist = {};
  var db = FirebaseFirestore.instance;
  Comman_Cate_Data() async {
    tablelist = {};
    Map<dynamic, dynamic> w = {
      'table': "tables",
    };
    var temp = await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        tablelist[v['id']] = v['tab_no'];
      });
    });
  }

  Widget build(BuildContext context) {
    Get.put(OrdersController());
    return Scaffold(
      appBar: appbarWidget(dashboard),
      bottomNavigationBar: kthemeFooter(context, selected: 0),
      body: StreamBuilder(
          stream: StoreServices.getOrdersRecent(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              var data = snapshot.data!.docs;

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
                                (kIsWeb)
                                    ? Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(5),
                                              //height: 120,
                                              width: 260,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //  SizedBox(height: 10,),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Today Order',
                                                              style: GoogleFonts.alike(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      247,
                                                                      245,
                                                                      244)),
                                                            )),
                                                      ]),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            countData[0]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15.5,
                                                                fontFamily:
                                                                    'ms',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .article_rounded,
                                                            color: Colors.white,
                                                            size: 35,
                                                          )
                                                        ],
                                                      )),

                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.lightGreen,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          )),
                                                      width: double.infinity,
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "More Info",
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontFamily:
                                                                    'ms',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  OrdersScreen());
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_circle_right_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.all(5),
                                              //height: 120,
                                              width: 260,
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 66, 108, 223),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // SizedBox(height: 10,),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Pending Order',
                                                              style: GoogleFonts.alike(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                            )),
                                                      ]),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            countData[1]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15.5,
                                                                fontFamily:
                                                                    'ms',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .article_rounded,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    249,
                                                                    248,
                                                                    248),
                                                            size: 35,
                                                          )
                                                        ],
                                                      )),

                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5.0),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              97,
                                                              163,
                                                              239),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          )),
                                                      width: double.infinity,
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "More Info",
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontFamily:
                                                                    'ms',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  KOrdersScreen());
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_circle_right_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              )),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            // onTap: () {
                                            //   Get.to(() => ProductsScreen());
                                            // },
                                            child: Container(
                                              child: dashboardButton(
                                                context,
                                                title: "Today Order",
                                                count: '$Todayorder',
                                                icon: icProducts,
                                              )
                                                  .box
                                                  .shadowLg
                                                  .rounded
                                                  .color(purpleColor)
                                                  .make(),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => KOrdersScreen());
                                            },
                                            child: dashboardButton(context,
                                                    title: "Pending Order",
                                                    count:
                                                        countData[1].toString(),
                                                    icon: icOreders)
                                                .box
                                                .shadowLg
                                                .rounded
                                                .color(Color.fromARGB(
                                                    255, 70, 104, 255))
                                                .make(),
                                          ),
                                        ],
                                      ),
                                10.heightBox,
                              ],
                            );
                          }
                        }),

                    10.heightBox,
                    const Divider(),
                    boldText(
                        text: 'All Pending Recipe',
                        color: darkGrey,
                        size: 16.0),
                    10.heightBox,
                    Container(
                      height: 100.0,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        children: [
                          for (var k in controller.pendingProductList.keys)
                            Container(
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                  boxShadow: themeBox,
                                  border: Border.all(
                                      width: 1.0, color: Colors.red)),
                              child: Row(
                                children: [
                                  Image.network(
                                      '${controller.pendingProductList[k]['img']}'),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      '${controller.pendingProductList[k]['tPending']}',
                                      style: themeTextStyle(
                                          size: 20.0,
                                          color: Colors.red,
                                          fw: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    //10.heightBox,
                    const Divider(),
                    10.heightBox,
                    boldText(
                        text: 'Recent Orders', color: darkGrey, size: 16.0),
                    20.heightBox,
                    Expanded(
                      child: (kIsWeb)
                          ? Row(
                              children: [
                                Container(
                                  width: 700,
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(
                                        data.length,
                                        (index) => data[index]['order_code']
                                                    .length ==
                                                0
                                            ? const SizedBox()
                                            : kthemeOderListRowCon(
                                                context, data[index],
                                                productId: data[index].id,
                                                table_No: tablelist[data[index]
                                                    ['order_table']])),
                                  ),
                                ),
                                50.widthBox,
                                Container(
                                    margin: EdgeInsets.all(5),
                                    width: 600,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Image.network(
                                        'https://img.freepik.com/free-vector/hand-drawn-india-lifestyle-illustration_23-2149642053.jpg?t=st=1700474412~exp=1700475012~hmac=bac151701243f1f9a7682e75e9245b3edb5131e1aa3b3855f1629417fbdc2304',
                                        fit: BoxFit.fill)),
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                  data.length,
                                  (index) =>
                                      data[index]['order_code'].length == 0
                                          ? const SizedBox()
                                          : kthemeOderListRowCon(
                                              context, data[index],
                                              productId: data[index].id,
                                              table_No: tablelist[data[index]
                                                  ['order_table']])),
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
