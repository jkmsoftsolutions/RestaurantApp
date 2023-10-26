import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'normal_text.dart';

AppBar appbarWidget(title) {
  return AppBar(
    //backgroundColor: themeBG,
    //automaticallyImplyLeading: false,
    title: Row(children: [
      Icon(
        Icons.dashboard,
        color: themeBG,
      ),
      SizedBox(width: 10.0),
      boldText(text: title, color: themeBG, size: 16.0)
    ]),
    // actions: [
    //   normalText(
    //       text: intl.DateFormat('d, EEE yyyy').format(DateTime.now()),
    //       color: Colors.white),
    //   10.widthBox,
    // ],
  );
}
