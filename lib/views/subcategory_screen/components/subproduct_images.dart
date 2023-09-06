import 'package:emart_seller/const/const.dart';

Widget subProductImages({required lable, onPress}) {
  return "$lable"
      .text
      .bold
      .color(fontGrey)
      .size(16.0)
      .makeCentered()
      .box
      .color(lightGrey)
      .size(100, 100)
      .roundedSM
      .make();
}
