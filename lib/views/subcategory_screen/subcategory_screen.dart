// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names

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
import '../../theme/firebase_functions.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/normal_text.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  void initState() {
    Comman_Cate_Data();
    super.initState();
  }

  /////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

  List sublist = [];
  bool progressWidget = true;
  var db = FirebaseFirestore.instance;
  Comman_Cate_Data() async {
    var temp2 = [];
    sublist = [];
    Map<dynamic, dynamic> w = {
      'table': "categories",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        sublist.add(v);
      });
      progressWidget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SubCategoryController());
    return (progressWidget == true)
        ? LoadingIndicator()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: purpleColor,
              onPressed: () async {
                Get.to(() => const AddSubcategory());
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              leading: const BackButton(
                color: Colors.black, // <-- SEE HERE
              ),
              automaticallyImplyLeading: true,
              title: boldText(
                  text: "Subcategory", color: Colors.black, size: 16.0),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  for (var index = 0; index < sublist.length; index++)
                    Card(
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
                        leading: Image.network(sublist[index]['img'][0],
                            width: 100, height: 100, fit: BoxFit.cover),
                        title: boldText(
                            text: "${sublist[index]['name']}", color: fontGrey),
                        subtitle: Row(
                          children: [
                            normalText(
                                text: "${sublist[index]['status']}",
                                color: (sublist[index]['status'] == 'Active')
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
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            catPopupMenuIcons[i],
                                            color: darkGrey,
                                          ),
                                          10.widthBox,
                                          normalText(
                                              text: catPopupMenuTitles[i],
                                              color: darkGrey)
                                        ],
                                      ).onTap(() async {
                                        switch (i) {
                                          // case 0:
                                          //   Get.to(() => EditSubCategory(
                                          //       data: data[index],
                                          //       productId: data[index].id));
                                          //   break;
                                          // default:
                                        }
                                      }),
                                    )),
                          ).box.white.rounded.width(200).make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    )
                ]),
              ),
            ));
  }
}
