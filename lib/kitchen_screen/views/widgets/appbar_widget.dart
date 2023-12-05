import 'package:emart_seller/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'normal_text.dart';

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: white,
    automaticallyImplyLeading: false,
    title: boldText(text: title, color: fontGrey, size: 16.0),
    actions: [
      normalText(
          text: intl.DateFormat('EEE,MM,d, ' 'yy').format(DateTime.now()),
          color: purpleColor),
      10.widthBox,
    ],
  );
}
