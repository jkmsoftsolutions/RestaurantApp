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
import '../widgets/appbar_widget.dart';
import '../../theme/function.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrdersController());
    return Scaffold(
      appBar: appbarWidget(dashboard),
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
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => OrdersScreen());
                                      },
                                      child: dashboardButton(context,
                                          title: orders,
                                          count: countData[1].toString(),
                                          icon: icOreders),
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
                                        icon: icProfile),
                                    dashboardButton(context,
                                        title: totalSales,
                                        count: countData[3].toString(),
                                        icon: icStar),
                                  ],
                                ),
                              ],
                            );
                          }
                        }),
                    10.heightBox,
                    10.heightBox,
                    const Divider(),
                    10.heightBox,
                    boldText(
                        text: 'Recent Orders', color: darkGrey, size: 16.0),
                    20.heightBox,
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          data.length,
                          (index) => data[index]['order_code'].length == 0
                              ? const SizedBox()
                              : Container(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() =>
                                          OrderDetails(data: data[index]));
                                    },
                                    leading: Image.network(
                                        data[index]['orders'][0]['img'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    title: boldText(
                                        text:
                                            "${capitalize(data[index]['orders'][0]['title'])}",
                                        color: fontGrey),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${capitalize(data[index]['order_by_name'].toString())}",
                                          style: TextStyle(fontSize: 11.0),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₹ ${data[index]['total_amount'].toString()}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20.0),
                                            Text(
                                              "${(data[index]['order_delivered']) ? "Deliverd" : "Pending"}",
                                              style: themeTextStyle(
                                                  color: (data[index]
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
                                              .format(data[index]['order_date']
                                                  .toDate()),
                                          style: TextStyle(fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
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
