import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:emart_seller/views/widgets/appbar_widget.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../widgets/normal_text.dart';
import '../../theme/function.dart';
import '../../theme/style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    //var controller = Get.put(OrdersController());

    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
          stream: StoreServices.getOrders(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var time = data[index]['order_date'].toDate();

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => OrderDetails(data: data[index]));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20.0),
                                  Text(
                                    "${(data[index]['order_delivered']) ? "Deliverd" : "Pending"}",
                                    style: themeTextStyle(
                                        color: (data[index]['order_delivered'])
                                            ? Colors.green
                                            : Color.fromARGB(255, 96, 52, 179),
                                        size: 11.0),
                                  )
                                ],
                              ),
                              Text(
                                intl.DateFormat('EEE, d MMM  ' 'yy')
                                    .add_jm()
                                    .format(data[index]['order_date'].toDate()),
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ],
                          ),
                        ),
                      );
                      // return ListTile(
                      //   onTap: () {
                      //     Get.to(() => OrderDetails(data: data[index]));
                      //   },
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12)),
                      //   tileColor: textfieldGrey,
                      //   title: boldText(
                      //       text: "${data[index]['order_code']}",
                      //       color: purpleColor),
                      //   subtitle: Column(
                      //     children: [
                      //       Row(
                      //         children: [
                      //           const Icon(Icons.calendar_month,
                      //               color: fontGrey),
                      //           10.widthBox,
                      //           boldText(
                      //               text: intl.DateFormat('EEE, MMM d, ' 'yy')
                      //                   .add_jm()
                      //                   .format(time),
                      //               color: purpleColor),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           const Icon(Icons.payment, color: fontGrey),
                      //           10.widthBox,
                      //           boldText(text: unpaid, color: red),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      //   trailing: boldText(
                      //       text: "${data[index]['total_amount']}",
                      //       color: purpleColor,
                      //       size: 16.0),
                      // ).box.margin(const EdgeInsets.only(bottom: 4)).make();
                    }),
                  ),
                ),
              );
            }
          }),
    );
  }
}
