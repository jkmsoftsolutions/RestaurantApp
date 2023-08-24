import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import '../../../theme/style.dart';

Widget orderPlaceDetails({title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText(text: "$title1", color: purpleColor, size: 10.0),
            boldText(text: "$d1", color: red),
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: "$title2", color: purpleColor, size: 10.0),
              boldText(text: "$d2", color: fontGrey),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget orderItems({data}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 70.0,
        child: Image.network(
          data['img'],
          //width: MediaQuery.of(context).size.width / 5,
          //height: 60.0,
        ),
      ),
      SizedBox(width: 20.0),
      Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data['title']}",
              style: themeTextStyle(size: 14.0, fw: FontWeight.bold),
            ),
            3.heightBox,
            Text(
              "Quntity : ${data['qty']}",
              style: themeTextStyle(size: 12.0),
            ),
            20.heightBox,
            Text(
              "₹${data['tprice']}",
              style: themeTextStyle(size: 20.0, fw: FontWeight.bold),
            )
          ],
        ),
      ),
    ],
  );
}
