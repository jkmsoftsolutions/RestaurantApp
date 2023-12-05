import 'package:emart_seller/const/const.dart';

// ignore: non_constant_identifier_names
Widget LoadingIndicator({circleColor = purpleColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
