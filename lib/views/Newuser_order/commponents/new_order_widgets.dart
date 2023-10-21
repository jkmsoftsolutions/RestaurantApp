import 'package:emart_seller/const/const.dart';

Widget wd_increesBtn(type, method, pdata, {height: 100.0}) {
  return GestureDetector(
    onTap: () {
      method(pdata, (type == '+') ? 'incr' : 'decr');
    },
    child: Container(
      height: height,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment:
            (type == '+') ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(106, 241, 249, 255),
                  borderRadius: BorderRadius.circular(40.0)),
              child: Icon(
                (type == '+') ? Icons.add : Icons.remove,
                size: 20.0,
                color: Color.fromARGB(106, 26, 26, 26),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
