import 'dart:convert';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:get/get.dart';
import '../../controllers/subsategory_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/normal_text.dart';
import 'components/subcat_dropdown.dart';
import 'components/subproduct_images.dart';

class EditSubCategory extends StatefulWidget {
  final dynamic data;
  final dynamic productId;
  const EditSubCategory({super.key, this.data, this.productId});

  @override
  State<EditSubCategory> createState() => _EditSubCategoryState();
}

class _EditSubCategoryState extends State<EditSubCategory> {
  // var listimg = [];
  var controller = Get.find<SubCategoryController>();
  bool wait = true;
  @override
  void initState() {
    if (widget.data != null) {
      controller.cNameController.text = widget.data['name'];
      controller.cDescController.text = widget.data['desc'];
      controller.statusvalue.value = widget.data['status'];

      print("${widget.data['sub_category']}  +++++++ydfdfhdfdhdfdh+++++");

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.heightBox,
                    //  subcatDropdown(
                    // "Category", cate_list, controller.catsvalue, controller),
                    10.heightBox,
                    customTextField(
                        hint: "eg. Food Name",
                        lable: "Subcategory name",
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
                                      controller.pImagesList[index].toString(),
                                      'https://')
                                  ? Image.network(controller.pImagesList[index],
                                          width: 100)
                                      .onTap(() {
                                      controller.sub_cat_pickImage(
                                          index, context);
                                    })
                                  : Image.file(
                                      controller.pImagesList[index],
                                      width: 100,
                                    ).onTap(() {
                                      controller.sub_cat_pickImage(
                                          index, context);
                                    })
                              : subProductImages(lable: "${index + 1}")
                                  .onTap(() {
                                  controller.sub_cat_pickImage(index, context);
                                }),
                        ),
                      ),
                    ),

                    10.heightBox,
                    subcatDropdown("Status", controller.statusList,
                        controller.statusvalue, controller),
                    // Center(child: LoadingIndicator()),
                  ],
                ),
              ),
            ),
    );
  }
}
