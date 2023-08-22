import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';

Widget ourButton({title, color = purpleColor, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // ignore: deprecated_member_use
        primary: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: normalText(text: title, size: 16.0));
}
