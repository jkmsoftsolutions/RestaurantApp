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

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
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
              var data = snapshot.data!.docs;
              // var dataArr;
              // List sublist = [];
              // for (var i = 0; i < data.length; i++) {
              //   //setState(() {
              //   dataArr = data[i].data() as Map<dynamic, dynamic>;
              //   sublist = dataArr["sub_category"];
              //   //});
              // }
              return //(sublist.isNotEmpty)
                  //     ? Column(
                  //         children: [
                  //           for (var i = 0; i < sublist.length; i++)
                  //             Text("djhfjdshfdsh")
                  //         ],
                  //       )
                  //     : SizedBox();
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var dataArr = data[index].data() as Map<dynamic, dynamic>;

                      return Card(
                        //
                        color: (dataArr['status'] != null &&
                                dataArr['status'].toString().toLowerCase() ==
                                    'inactive')
                            ? Color.fromARGB(255, 255, 215, 212)
                            : Colors.white,
                        child: ListTile(
                          onTap: () {
                            Get.to(() => EditCategory(
                                data: data[index], productId: data[index].id));
                          },
                          leading: Image.network(data[index]['img'][0],
                              width: 100, height: 100, fit: BoxFit.cover),
                          title: boldText(
                              text: "${data[index]['name']}", color: fontGrey),
                          subtitle: Row(
                            children: [
                              normalText(
                                  text: "${data[index]['status']}",
                                  color: (data[index]['status'] == 'Active')
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
                                            case 0:
                                              Get.to(() => EditSubCategory(
                                                  data: data[index],
                                                  productId: data[index].id));
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
