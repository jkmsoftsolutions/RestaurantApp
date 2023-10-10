import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../../controllers/orders_controller.dart';
import '../widgets/normal_text.dart';
import '../../theme/function.dart';
import '../../theme/style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var controller = Get.put(OrdersController());

  @override
  void initState() {
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

  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Scaffold(
        appBar: AppBar(
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
                        child: Column(
                          children: [
                            // order info ===================================
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 237, 237)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Order :',
                                          style: themeTextStyle(size: 13.0)),
                                      Text('${OrderList.length}',
                                          style: themeTextStyle(
                                              size: 17.0, fw: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Amount :',
                                          style: themeTextStyle(size: 13.0)),
                                      Text('${controller.totalAmount}',
                                          style: themeTextStyle(
                                              size: 17.0, fw: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // product list start ===========================
                            Column(
                              children:
                                  List.generate(OrderList.length, (index) {
                                var time =
                                    OrderList[index]['order_date'].toDate();
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() =>
                                          OrderDetails(data: OrderList[index]));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    leading: Image.network(
                                        OrderList[index]['orders'][0]['img'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    title: boldText(
                                        text:
                                            "${capitalize(OrderList[index]['orders'][0]['title'])}",
                                        color: fontGrey),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${capitalize(OrderList[index]['order_by_name'].toString())}",
                                          style: TextStyle(fontSize: 11.0),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₹ ${OrderList[index]['total_amount'].toString()}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20.0),
                                            Text(
                                              "${(OrderList[index]['order_delivered']) ? "Deliverd" : "Pending"}",
                                              style: themeTextStyle(
                                                  color: (OrderList[index]
                                                          ['order_delivered'])
                                                      ? Colors.green
                                                      : Color.fromARGB(
                                                          255, 96, 52, 179),
                                                  size: 11.0),
                                            )
                                          ],
                                        ),
                                        Text(
                                          intl.DateFormat('EEE, d MMM  ' 'yy')
                                              .add_jm()
                                              .format(OrderList[index]
                                                      ['order_date']
                                                  .toDate()),
                                          style: TextStyle(fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        )),
                  )
            : LoadingIndicator());
  }
}
