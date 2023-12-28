import 'dart:convert';

import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/category_controller.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/normal_text.dart';
import 'components/cat_dropdown.dart';
import 'components/product_images.dart';

class EditCategory extends StatefulWidget {
  final dynamic data;
  final dynamic productId;
  const EditCategory({super.key, this.data, this.productId});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  // var listimg = [];
  var controller = Get.find<CategoryController>();
  bool wait = true;
  @override
  void initState() {
    if (widget.data != null) {
      controller.cNameController.text = widget.data['name'];
      controller.cDescController.text = widget.data['desc'];
      controller.statusvalue.value = widget.data['status'];

      // images
      controller.pImagesList = RxList();
      controller.pImagesLinks = [];
      widget.data['img'].forEach((v) {
        controller.pImagesList.add(v);
        controller.pImagesLinks.add(v);
      });
      wait = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: boldText(text: "Edit product", size: 16.0),
        actions: [
          TextButton(
              onPressed: () async {
                setState(() {
                  wait = true;
                });
                controller.isloading(true);
                await controller.uploadImage();
                // ignore: use_build_context_synchronously
                await controller.cat_uploadProduct(context,
                    catId: widget.productId);
                Get.back();
              },
              child: boldText(
                text: save,
              ))
        ],
      ),
      body: (wait)
          ? progress()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: (kIsWeb)
                    ? Center(
                        child: Container(
                          width: 800,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.heightBox,
                              customTextField(
                                  hint: "eg. Fast Food",
                                  lable: "Category name",
                                  controller: controller.cNameController),
                              10.heightBox,
                              customTextField(
                                  hint: "eg. nice Category is very usefull",
                                  lable: "Descripttion",
                                  isDesc: true,
                                  controller: controller.cDescController),
                              30.heightBox,
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                    1,
                                    (index) => controller.pImagesList[index] !=
                                            null
                                        ? matchString(
                                                controller.pImagesList[index]
                                                    .toString(),
                                                'https://')
                                            ? Image.network(
                                                    controller
                                                        .pImagesList[index],
                                                    width: 100)
                                                .onTap(() {
                                                controller.cat_pickImage(
                                                    index, context);
                                              })
                                            : Image.file(
                                                controller.pImagesList[index],
                                                width: 100,
                                              ).onTap(() {
                                                controller.cat_pickImage(
                                                    index, context);
                                              })
                                        : productImages(lable: "${index + 1}")
                                            .onTap(() {
                                            controller.cat_pickImage(
                                                index, context);
                                          }),
                                  ),
                                ),
                              ),

                              10.heightBox,
                              catDropdown("Status", controller.statusList,
                                  controller.statusvalue, controller),

                              // Center(child: LoadingIndicator()),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.heightBox,
                          customTextField(
                              hint: "eg. Fast Food",
                              lable: "Category name",
                              controller: controller.cNameController),
                          10.heightBox,
                          customTextField(
                              hint: "eg. nice Category is very usefull",
                              lable: "Descripttion",
                              isDesc: true,
                              controller: controller.cDescController),
                          30.heightBox,
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                1,
                                (index) => controller.pImagesList[index] != null
                                    ? matchString(
                                            controller.pImagesList[index]
                                                .toString(),
                                            'https://')
                                        ? Image.network(
                                                controller.pImagesList[index],
                                                width: 100)
                                            .onTap(() {
                                            controller.cat_pickImage(
                                                index, context);
                                          })
                                        : Image.file(
                                            controller.pImagesList[index],
                                            width: 100,
                                          ).onTap(() {
                                            controller.cat_pickImage(
                                                index, context);
                                          })
                                    : productImages(lable: "${index + 1}")
                                        .onTap(() {
                                        controller.cat_pickImage(
                                            index, context);
                                      }),
                              ),
                            ),
                          ),

                          10.heightBox,
                          catDropdown("Status", controller.statusList,
                              controller.statusvalue, controller),

                          // Center(child: LoadingIndicator()),
                        ],
                      ),
              ),
            ),
    );
  }
}
