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
    fn_comon_init();
    super.initState();
  }

  // comon insit funciton
  fn_comon_init() async {
    await get_odaydata();
    await Comman_Cate_Data();
    await get_pendding();
    setState(() {});
  }

  bool wait = true;

  var TodayList = [];
  var Todayorder = 0;
  get_odaydata() async {
    Todayorder = await controller.Todaydata();
    setState(() {
      wait = false;
    });
  }

  var penndingdata = [];
  get_pendding() async {
    await controller.Penddingorder_Data();
    setState(() {
      wait = false;
    });
  }

  /////////////  table data fetch From Firebase  +++++++++++++++++++++++++++++++++++++++++++++

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
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
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
                                                            '$Todayorder',
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
                    (controller.pendingProductList.isEmpty)
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Divider(),
                                boldText(
                                    text: 'All Pending Recipes',
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
                                      for (var k
                                          in controller.pendingProductList.keys)
                                        InkWell(
                                          onTap: () {
                                            if (tablelist != null ||
                                                controller.pendingProductList[k]
                                                        ['title'] !=
                                                    null)
                                              modal_pendingTable(context,
                                                  title:
                                                      "${controller.pendingProductList[k]['title']}",
                                                  data: controller
                                                      .pendingProductList[k],
                                                  tablelist: tablelist);
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 8.0),
                                              decoration: BoxDecoration(
                                                  boxShadow: themeBox,
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Colors.red)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Stack(children: [
                                                    Image.network(
                                                      '${controller.pendingProductList[k]['img']}',
                                                      width: 100,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      top: 3.0,
                                                      right: 3.0,
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          width: 30.0,
                                                          height: 30.0,
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          child: Center(
                                                              child: Text(
                                                            "${controller.pendingProductList[k]['tPending']}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                themeTextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ))),
                                                    ),
                                                  ]),
                                                  10.heightBox,
                                                  "${controller.pendingProductList[k]['title']}"
                                                      .text
                                                      .size(10)
                                                      .color(darkFontGrey)
                                                      .make(),
                                                ],
                                              )),
                                        ),
                                    ],
                                  ),
                                ),
                              ]),
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
                                                rloadPage: fn_comon_init,
                                                table_No: tablelist[data[index]
                                                    ['order_table']])),
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                  data.length,
                                  (index) =>
                                      data[index]['order_code'].length == null
                                          ? const SizedBox()
                                          : kthemeOderListRowCon(
                                              context, data[index],
                                              productId: data[index].id,
                                              rloadPage: fn_comon_init,
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

  // Modal =================================================================

  modal_pendingTable(context, {title: 'Title', data: '', tablelist: ''}) async {
    var tableList = data['table_list'];
    //var tableNo = tablelist
    print(tableList);
    {
      showModalBottomSheet(
          //isScrollControlled: true, // for full screen
          context: context,
          backgroundColor: Color.fromARGB(0, 232, 232, 232),
          builder: (BuildContext context) {
            return ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                child: Container(
                    //height: MediaQuery.of(context).size.height - 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 238, 248, 255),
                        ),
                        child: ListTile(
                            leading: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ) // the arrow back icon
                                  ),
                            ),
                            title: Center(
                                child: Text(
                              "$title",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ) // Your desired title
                                )),
                      ),

                      // Price Field
                      SizedBox(height: 10.0),

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: GridView.builder(
                          //controller: _hScrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  //childAspectRatio: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15),
                          itemBuilder: (BuildContext context, index) {
                            if (index == tableList.length) {
                              //return CupertinoActivityIndicator();
                            }
                            var data = tableList[index];
                            var tablNo = tablelist[data['table']];
                            return (tablNo == null)
                                ? SizedBox()
                                : Container(
                                    decoration: BoxDecoration(
                                        color: themeBG4,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Column(
                                      children: [
                                        Text("${tablNo}",
                                            style: themeTextStyle(
                                                size: 50.0,
                                                fw: FontWeight.bold,
                                                color: Colors.white)),
                                        SizedBox(height: 6.0),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        7.0))),
                                                    child: Center(
                                                        child: Text(
                                                            "Qnt: ${data['qnt']}")))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                          },
                          itemCount: tableList.length,
                        ),
                      )
                    ])));
          });
    }
  }
}
