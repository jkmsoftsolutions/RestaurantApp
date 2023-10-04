import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';

Widget custominputField(
    {String? lable, String? hint, controller, isDesc = false}) {
  return TextFormField(
    style: const TextStyle(color: Color.fromARGB(255, 246, 245, 245)),
    controller: controller,
    enabled: false,
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 140, 136, 151),
        isDense: true,
        label: normalText(text: lable),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Vx.black,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: white,
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 75, 75, 75))),
  );
}
