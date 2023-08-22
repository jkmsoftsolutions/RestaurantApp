import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/views/products_screen/components/product_dropdown.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    void cleartext() {
      controller.pnameController.clear();
      controller.pdescController.clear();
      controller.ppriceController.clear();
      controller.pquantityController.clear();
    }

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
                      controller.isloading(true);
                      await controller.uploadImage();
                      // ignore: use_build_context_synchronously
                      await controller.uploadProduct(context);
                      Get.back();
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
                    hint: "eg. Momose",
                    lable: "Product name",
                    controller: controller.pnameController),
                10.heightBox,
                customTextField(
                    hint: "eg. nice product is very usefull",
                    lable: "Descripttion",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextField(
                    hint: "eg. Rs:-200",
                    lable: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                customTextField(
                    hint: "eg. 21",
                    lable: "Quntitiy",
                    controller: controller.pquantityController),
                10.heightBox,
                productDropdown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropdown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(
                  color: white,
                ),
                boldText(text: "Choose product images"),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index],
                              width: 100,
                            ).onTap(() {
                              controller.pickImage(index, context);
                            })
                          : productImages(lable: "${index + 1}").onTap(() {
                              controller.pickImage(index, context);
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
                boldText(text: "Choose product Color"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                        9,
                        (index) => Stack(
                              alignment: Alignment.center,
                              children: [
                                VxBox()
                                    .color(Vx.randomPrimaryColor)
                                    .roundedFull
                                    .size(30, 30)
                                    .make()
                                    .onTap(() {
                                  controller.selectColoIndex.value = index;
                                }),
                                controller.selectColoIndex.value == index
                                    ? const Icon(
                                        Icons.done,
                                        color: white,
                                      )
                                    : const SizedBox(),
                              ],
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
