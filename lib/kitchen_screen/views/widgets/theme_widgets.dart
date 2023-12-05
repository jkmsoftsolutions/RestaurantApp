import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/kitchen_screen/views/orders_screen/order_details.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

Widget kthemeOderListRowCon(context, data, {productId: '', table_No: ''}) {
  var temp = data["order_date"];
  DateTime date = temp.toDate();
  var formattedTime = DateFormat.jm().format(date);

  return Container(
    padding: EdgeInsets.symmetric(vertical: 0),
    margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
    decoration: BoxDecoration(
        boxShadow: themeBox,
        color: (data['order_delivered'] != null && data['order_delivered'])
            ? deliverdcolor
            : pendingcolor,
        borderRadius: BorderRadius.circular(5.0)),
    child: ListTile(
      onTap: () {
        if (productId != '') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => KOrderDetails(id: productId)));
        }
      },
      leading: Image.network(data['orders'][0]['img'],
          width: 100, height: 100, fit: BoxFit.cover),
      // title: boldText(
      //  text: "${capitalize(data['order_by_name'].toString())}",
      //    color: fontGrey),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 13.0,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              children: [
                for (var k in data['orders'])
                  Container(
                    margin: EdgeInsets.only(right: 4.0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 213, 180, 251)),
                    child: Text(
                      "${capitalize(k['title'])}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(data['type'] != null) ? data['type'] : ''} ",
                style: TextStyle(
                  color: white,
                  fontSize: 10.0,
                ),
              ).color(green),
              //SizedBox(width: 10.0),
              Text(
                "Table No : ${table_No} ",
                style: TextStyle(
                  color: white,
                  fontSize: 13.0,
                ),
              ).color(red),
              1.widthBox,

              Text(formattedTime,
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),

              // Text(
              //   intl.DateFormat('EEE, d MMM  ' 'yy')
              //       .add_jm()
              //       .format(data['order_date'].toDate()),
              //   style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          4.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(data['order_by_name'].toString())}",
                //  "₹ ${data['total_amount'].toString()}",

                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20.0),
            ],
          ),
        ],
      ),
    ),
  );
}
