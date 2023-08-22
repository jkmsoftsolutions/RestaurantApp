import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:get/get.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/normal_text.dart';
import 'components/product_dropdown.dart';
import 'components/product_images.dart';

class EditProductScreen extends StatefulWidget {
  final dynamic data;
  const EditProductScreen({super.key, this.data});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // var listimg = [];

  var controller = Get.find<ProductsController>();
  @override
  void initState() {
    if (widget.data != null) {
      controller.pnameController.text = widget.data['p_name'];
      controller.pdescController.text = widget.data['p_desc'];
      controller.ppriceController.text = widget.data['p_price'];
      controller.pquantityController.text = widget.data['p_quantity'];
      // controller.categoryvalue.value = widget.data['p_category'];
    }

    // print("${widget.data['p_imgs']}++++++++++++");
    setState(() {
      // listimg = widget.data['p_imgs'];
    });

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
              onPressed: () async {},
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

              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => controller.pImagesList[index] != null
                        ? Image.network(
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
