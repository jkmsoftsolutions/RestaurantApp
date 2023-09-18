// ignore_for_file: non_constant_identifier_names, unused_element, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';

import '../../controllers/subsategory_controller.dart';
import '../../theme/firebase_functions.dart';
import 'components/subcat_dropdown.dart';
import 'components/subproduct_images.dart';

class AddSubcategory extends StatefulWidget {
  const AddSubcategory({super.key});

  @override
  State<AddSubcategory> createState() => _AddSubcategoryState();
}

class _AddSubcategoryState extends State<AddSubcategory> {
  var db = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    _CateData();
    super.initState();
  }

///////////  Calling Category data +++++++++++++++++++++++++++
  // Map<int, String> v_status = {0: "Select", 1: 'Active', 2: 'Inactive'};
  // Map<String, String> Cate_Name_list = {'Select': ''};
  var cate_id;
  var cate_list = [""];

  var cate_sub;
  _CateData() async {
    cate_list = [];
    Map<dynamic, dynamic> w = {
      'table': 'cart',
      //'status':'1',
    };

    // var dbData = await dbFindDynamic(db, w);
    var dbData = await dbFindDynamic(db, w);
    dbData.forEach((k, v) {
      setState(() {
        cate_list.add(v["name"]);
        cate_id = v['id'];
        cate_sub = v["sub_category"];
      });
    });
    print("$cate_sub  ++++++++++cte===+++++++++++");
  }

  ///////============================================================
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SubCategoryController());
    // controller._CateData();
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
          title: boldText(text: "Add Subcategory", size: 16.0),
          actions: [
            controller.isloading.value
                ? LoadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (controller.cNameController.text.length > 6) {
                        controller.isloading(true);
                        await controller.uploadImage();
                        // ignore: use_build_context_synchronously
                        await controller.Sub_cat_uploadProduct(
                            context, cate_sub,
                            catId: cate_id);
                        Get.back();
                      } else {
                        controller.isloading(false);
                        themeAlert(context, "Required SubCategory Name",
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
                subcatDropdown(
                    "Category", cate_list, controller.catsvalue, controller),
                10.heightBox,
                customTextField(
                    hint: "eg. Food Name",
                    lable: "Subcategory name",
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
                boldText(text: "Choose SubCategory images"),
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
                              controller.sub_cat_pickImage(index, context);
                            })
                          : subProductImages(lable: "${index + 1}").onTap(() {
                              controller.sub_cat_pickImage(index, context);
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
                subcatDropdown("Status", controller.statusList,
                    controller.statusvalue, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
