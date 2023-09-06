// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/controllers/category_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/category_screen/add_category.dart';
import 'package:emart_seller/views/category_screen/edit_category.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/subcategory_screen/add_subcategory.dart';
import 'package:emart_seller/views/subcategory_screen/edit_subcategory.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../../controllers/subsategory_controller.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/normal_text.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

gggg(data) {}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var temp_arr;
    List sublist = [];
    var data = [];

    var controller = Get.put(SubCategoryController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          Get.to(() => const AddSubcategory());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget("SubCategory"),
      body: StreamBuilder(
          stream: StoreServices.getSubCategories(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              data = snapshot.data!.docs;
              // print("${data.l}  +++++++++++++");
              for (var i = 0; i < data.length; i++) {
                temp_arr = data[i].data() as Map<dynamic, dynamic>;
                sublist = temp_arr["sub_category"];
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(sublist.length, (index) {
                      // var dataArr =
                      //     sublist[index].data() as Map<dynamic, dynamic>;

                      return (sublist.isEmpty)
                          ? LoadingIndicator()
                          : Card(
                              //
                              color: (sublist[index]['status'] != null &&
                                      sublist[index]['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'inactive')
                                  ? Color.fromARGB(255, 255, 215, 212)
                                  : Colors.white,
                              child: ListTile(
                                onTap: () {
                                  // Get.to(() => EditCategory(
                                  //     data: data[index], productId: data[index].id));
                                },
                                // leading: Image.network(data[index]['img'][0],
                                //     width: 100, height: 100, fit: BoxFit.cover),
                                title: boldText(
                                    text: "${sublist[index]['name']}",
                                    color: fontGrey),
                                subtitle: Row(
                                  children: [
                                    normalText(
                                        text: "${sublist[index]['status']}",
                                        color: (sublist[index]['status'] ==
                                                'Active')
                                            ? green
                                            : red),
                                  ],
                                ),
                                trailing: VxPopupMenu(
                                  arrowSize: 0.0,
                                  menuBuilder: () => Column(
                                    children: List.generate(
                                        catPopupMenuTitles.length,
                                        (i) => Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    catPopupMenuIcons[i],
                                                    color: darkGrey,
                                                  ),
                                                  10.widthBox,
                                                  normalText(
                                                      text:
                                                          catPopupMenuTitles[i],
                                                      color: darkGrey)
                                                ],
                                              ).onTap(() async {
                                                switch (i) {
                                                  case 0:
                                                    Get.to(() =>
                                                        EditSubCategory(
                                                            data: data[index],
                                                            productId:
                                                                data[index]
                                                                    .id));
                                                    break;
                                                  default:
                                                }
                                              }),
                                            )),
                                  ).box.white.rounded.width(200).make(),
                                  clickType: VxClickType.singleClick,
                                  child: const Icon(Icons.more_vert_rounded),
                                ),
                              ),
                            );
                    }),
                  ),
                ),
              );
            }
          }),
    );
  }
}
