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
  return Container(
    margin: EdgeInsets.only(bottom: 10.0),
    decoration: BoxDecoration(
        boxShadow: themeBox,
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50.0,
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
              3.heightBox,
              Text(
                "₹${data['tprice']}",
                style: themeTextStyle(size: 16.0, fw: FontWeight.bold),
              )
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${(data['isPack'] != null && data['isPack']) ? "pakking" : "Dinning"} ",
              style: TextStyle(
                color: white,
                fontSize: 10.0,
              ),
            ).color((data['isPack'] != null && data['isPack']) ? green : red),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Icon(
          //     Icons.shopping_bag,
          //     size: 15,
          //     color:
          //         (data['isPack'] == true) ? Colors.green : Colors.transparent,
          //   ),
          // ),a
        )
      ],
    ),
  );
}
