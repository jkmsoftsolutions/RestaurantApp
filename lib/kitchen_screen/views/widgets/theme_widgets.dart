import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/kitchen_screen/views/orders_screen/order_details.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

Widget kthemeOderListRowCon(context, data,
    {productId: '', table_No: '', controller: '', rloadPage: ''}) {
  var temp = data["order_date"];
  DateTime date = temp.toDate();
  var formattedTime = DateFormat.jm().format(date);

  return Container(
    padding: EdgeInsets.symmetric(vertical: 0),
    margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
    decoration: BoxDecoration(
      boxShadow: themeBox,
      border: Border(
          left: BorderSide(
              color:
                  (data['order_delivered'] != null && data['order_delivered'])
                      ? Colors.green
                      : const Color.fromARGB(255, 244, 155, 54),
              width: 10.0)),
    ),
    child: ListTile(
      onTap: () async {
        if (productId != '') {
          var rNavigation = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => KOrderDetails(id: productId)));
          if (rloadPage != '') {
            rloadPage();
          }
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
                        color: (k['isPrepared'] == null)
                            ? Color.fromARGB(255, 117, 224, 214)
                            : Color.fromARGB(255, 255, 189, 113)),
                    child: Text(
                      "${capitalize(k['title'].toLowerCase())}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 34, 12, 134),
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
                "${(capitalize(data['order_by_name']))}",
                //  "₹ ${data['total_amount'].toString()}",

                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20.0),
            ],
          ),
          5.heightBox,
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                  width: 35.0,
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 37, 98, 148)),
                  child: Center(
                    child: Text(
                      "${(data['type'] != null) ? data['type'] : ''} ",
                      style: TextStyle(
                        color: white,
                        fontSize: 10.0,
                      ),
                    ),
                  )),
              SizedBox(width: 10.0),
              Container(
                width: 25.0,
                //height: 25.0,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 255, 163, 59)),
                child: Center(
                  child: Text(
                    "${(table_No == null) ? '' : table_No} ",
                    style: TextStyle(
                      color: white,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
              10.0.widthBox,
              Text(formattedTime,
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    ),
  );
}
