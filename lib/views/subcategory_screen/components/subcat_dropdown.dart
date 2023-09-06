import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/category_controller.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';

import '../../../controllers/subsategory_controller.dart';

Widget subcatDropdown(
    hint, List<String> list, dropvalue, SubCategoryController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
            child: DropdownButton(
      hint: normalText(text: "$hint", color: purpleColor),
      value: dropvalue.value == '' ? null : dropvalue.value,
      isExpanded: true,
      items: list.map((e) {
        return DropdownMenuItem(
          value: e,
          child: e.toString().text.make(),
        );
      }).toList(),
      onChanged: (newValue) {
        dropvalue.value = newValue.toString();
      },
    ))
        .box
        .white
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .roundedSM
        .make(),
  );
}
