import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/category_controller.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/category_screen/components/cat_dropdown.dart';

import 'package:emart_seller/views/products_screen/components/product_dropdown.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CategoryController());

    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: boldText(text: "Add product", size: 16.0),
          actions: [
            controller.isloading.value
                ? LoadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (controller.cNameController.text.length > 6) {
                        controller.isloading(true);
                        await controller.uploadImage();
                        // ignore: use_build_context_synchronously
                        await controller.cat_uploadProduct(context);
                        Get.back();
                      } else {
                        controller.isloading(false);
                        themeAlert(context, "Required Category Name",
                            type: 'error');
                      }
                    },
                    child: boldText(
                      text: save,
                    ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.heightBox,
                customTextField(
                    hint: "eg. Food Name",
                    lable: "Category name",
                    controller: controller.cNameController),
                10.heightBox,
                customTextField(
                    hint: "eg. nice product is very usefull",
                    lable: "Descripttion",
                    isDesc: true,
                    controller: controller.cDescController),
                10.heightBox,
                10.heightBox,
                const Divider(
                  color: white,
                ),
                boldText(text: "Choose Category images"),
                10.heightBox,
                Obx(
                  () => Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      1,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index],
                              width: 100,
                            ).onTap(() {
                              controller.cat_pickImage(index, context);
                            })
                          : productImages(lable: "${index + 1}").onTap(() {
                              controller.cat_pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(text: "First image will be your display image"),
                const Divider(
                  color: white,
                ),
                10.heightBox,
                catDropdown("Status", controller.statusList,
                    controller.statusvalue, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
