import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var size = MediaQuery.of(context).size;
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            boldText(text: title, size: 16.0),
            boldText(text: count, size: 20.0),
          ],
        ),
      ),
      Image.asset(icon, width: 40, color: white),
    ],
  )
      .box
      .rounded
      .size(size.width * 0.45, 90)
      .padding(const EdgeInsets.all(8.0))
      .make();
}

void nextScreen(context, page) async {
  await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
