import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/kitchen_screen/theme/footer.dart';
import 'package:emart_seller/kitchen_screen/views/widgets/theme_widgets.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/theme_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../../controllers/orders_controller.dart';
import '../../../theme/footer.dart';
import '../widgets/normal_text.dart';
import '../../../theme/style.dart';
// ignore: depend_on_referenced_packages

class KOrdersScreen extends StatefulWidget {
  const KOrdersScreen({super.key});
  @override
  State<KOrdersScreen> createState() => _KOrdersScreenState();
}

class _KOrdersScreenState extends State<KOrdersScreen> {
  var controller = Get.put(KOrdersController());

  @override
  void initState() {
    Comman_Cate_Data();
    get_Orderdata("all");
    super.initState();
  }

  bool wait = true;
  var OrderList = [];
  get_Orderdata(Type) async {
    OrderList = [];
    OrderList = await controller.Ordersdata(Type);

    setState(() {
      OrderList;
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
    // ignore: unused_local_variable

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: boldText(text: "Order List ", size: 16.0, color: Colors.black),
          actions: [
            PopupMenuButton(
                color: Colors.black,
                surfaceTintColor: Colors.black,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: (() async {
                          await get_Orderdata("all");
                        }),
                        child: Row(
                          children: [
                            Text('All',
                                style: TextStyle(fontSize: 14.0, color: white))
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (() async {
                          await get_Orderdata("today");
                        }),
                        child: Row(
                          children: [
                            Text('Today',
                                style: TextStyle(fontSize: 14.0, color: white))
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (() async {
                          get_Orderdata("last7");
                        }),
                        child: Row(
                          children: [
                            Text('Last 7days',
                                style: TextStyle(fontSize: 14.0, color: white))
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (() async {
                          get_Orderdata("last30");
                        }),
                        child: Row(
                          children: [
                            Text('Last 30days',
                                style: TextStyle(fontSize: 14.0, color: white))
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (() async {
                          get_Orderdata("yearly");
                        }),
                        child: Row(
                          children: [
                            Text('Yearly',
                                style: TextStyle(fontSize: 14.0, color: white))
                          ],
                        ),
                      ),
                    ])
          ],
        ),
        bottomNavigationBar: kthemeFooter(context, selected: 1),
        body: (wait == false)
            ? (OrderList.length == 0)
                ? Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty,
                              size: 50.0,
                              color: Color.fromARGB(255, 255, 217, 214)),
                          SizedBox(height: 20.0),
                          Text(
                            "No have Order !!",
                            style: themeTextStyle(
                                color: Color.fromARGB(255, 196, 196, 196)),
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: (kIsWeb)
                            ? Center(
                                child: Container(
                                  width: 800,
                                  child: Column(
                                    children: [
                                      // order info ===================================
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 237, 237)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Total Order :',
                                                    style: themeTextStyle(
                                                        size: 13.0)),
                                                Text('${OrderList.length}',
                                                    style: themeTextStyle(
                                                        size: 17.0,
                                                        fw: FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Text('Total Amount :',
                                                //     style: themeTextStyle(size: 13.0)),
                                                // Text('${controller.totalAmount}',
                                                //     style: themeTextStyle(
                                                //         size: 17.0, fw: FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // product list start ===========================
                                      Column(
                                        children: List.generate(
                                            OrderList.length, (index) {
                                          var time = (OrderList[index]
                                                      ['order_date'] ==
                                                  null)
                                              ? ''
                                              : OrderList[index]['order_date']
                                                  .toDate();

                                          return kthemeOderListRowCon(
                                              context, OrderList[index],
                                              productId: OrderList[index]['id'],
                                              table_No: tablelist[
                                                  OrderList[index]
                                                      ['order_table']]);
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  // order info ===================================
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 237, 237)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total Order :',
                                                style:
                                                    themeTextStyle(size: 13.0)),
                                            Text('${OrderList.length}',
                                                style: themeTextStyle(
                                                    size: 17.0,
                                                    fw: FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text('Total Amount :',
                                            //     style: themeTextStyle(size: 13.0)),
                                            // Text('${controller.totalAmount}',
                                            //     style: themeTextStyle(
                                            //         size: 17.0, fw: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // product list start ===========================
                                  Column(
                                    children: List.generate(OrderList.length,
                                        (index) {
                                      var time = (OrderList[index]
                                                  ['order_date'] ==
                                              null)
                                          ? ''
                                          : OrderList[index]['order_date']
                                              .toDate();

                                      return kthemeOderListRowCon(
                                          context, OrderList[index],
                                          productId: OrderList[index]['id'],
                                          table_No: tablelist[OrderList[index]
                                              ['order_table']]);
                                    }),
                                  ),
                                ],
                              )),
                  )
            : LoadingIndicator());
  }
}
