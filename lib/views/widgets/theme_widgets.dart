import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:intl/intl.dart' as intl;

Widget themeOderListRowCon(context, data, {productId: ''}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 0),
    margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
    decoration: BoxDecoration(
        boxShadow: themeBox,
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(5.0)),
    child: ListTile(
      onTap: () {
        if (productId != '') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => OrderDetails(id: productId)));
        }
      },
      leading: Image.network(data['orders'][0]['img'],
          width: 100, height: 100, fit: BoxFit.cover),
      title: boldText(
          text: "${capitalize(data['order_by_name'].toString())}",
          color: fontGrey),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.heightBox,
          Text(
            "${(data['type'] != null) ? data['type'] : ''} ",
            style: TextStyle(
              color: white,
              fontSize: 10.0,
            ),
          ).color(green),
          4.heightBox,
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
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromARGB(255, 209, 170, 255)),
                    child: Text(
                      "${capitalize(k['title'])}",
                      style: TextStyle(fontSize: 10.0, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${data['total_amount'].toString()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20.0),
            ],
          ),
          Text(
            intl.DateFormat('EEE, d MMM  ' 'yy')
                .add_jm()
                .format(data['order_date'].toDate()),
            style: TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    ),
  );
}
