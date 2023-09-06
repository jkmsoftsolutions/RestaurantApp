import 'dart:convert';

import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:get/get.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/normal_text.dart';
import 'components/product_dropdown.dart';
import 'components/product_images.dart';

class EditProductScreen extends StatefulWidget {
  final dynamic data;
  final dynamic productId;
  const EditProductScreen({super.key, this.data, this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // var listimg = [];
  var controller = Get.find<ProductsController>();
  bool wait = true;
  @override
  void initState() {
    if (widget.data != null) {
      controller.pnameController.text = widget.data['p_name'];
      controller.pdescController.text = widget.data['p_desc'];
      controller.ppriceController.text = widget.data['p_price'];
      controller.pquantityController.text = widget.data['p_quantity'];
      controller.categoryvalue.value = widget.data['p_category'];
      controller.subcategoryvalue.value = widget.data['p_subcategory'];
      controller.statusvalue.value = widget.data['status'];
      //print(controller.subcategoryvalue.value);
      controller.populateSubcategory(widget.data['p_category']);
      // images
      controller.pImagesList = RxList();
      controller.pImagesLinks = [];
      widget.data['p_imgs'].forEach((v) {
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
                await controller.update_product(context, widget.productId);
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

                    Row(children: [
                      Expanded(
                          child: customTextField(
                              hint: "eg. Rs:-200",
                              lable: "Price",
                              controller: controller.ppriceController)),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: customTextField(
                            hint: "eg. 1",
                            lable: "Quntitiy",
                            controller: controller.pquantityController),
                      )
                    ]),

                    10.heightBox,
                    productDropdown("Status", controller.statusList,
                        controller.statusvalue, controller),

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

                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          3,
                          (index) => controller.pImagesList[index] != null
                              ? matchString(
                                      controller.pImagesList[index].toString(),
                                      'https://')
                                  ? Image.network(controller.pImagesList[index],
                                          width: 100)
                                      .onTap(() {
                                      controller.pickImage(index, context);
                                    })
                                  : Image.file(
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

                    // (listimg.isEmpty && listimg != null)
                    //     ?
                    // Row(
                    //   children: [
                    //     for (var img = 0; img < listimg.length; img++)
                    //       Image(
                    //         image: NetworkImage("${listimg[img]}"),
                    //       ),
                    //   ],
                    // ),

                    // :

                    // Center(child: LoadingIndicator()),

                    const Divider(
                      color: white,
                    ),
                    boldText(text: "Choose product images"),
                    10.heightBox,
                    5.heightBox,
                    normalText(text: "First image will be your display image"),
                    const Divider(
                      color: white,
                    ),
                    10.heightBox,
                    boldText(text: "Choose product Color"),
                    10.heightBox,
                  ],
                ),
              ),
            ),
    );
  }
}
