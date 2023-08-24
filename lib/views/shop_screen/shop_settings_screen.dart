import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/shop_screen/table_edit.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../../controllers/table_controller.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/normal_text.dart';
import 'add_table.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablesController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          Get.to(() => const AddTable());
        },
        child: const Icon(Icons.add),
      ),
      //appBar: appbarWidget(addtable),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
        ),
        title: boldText(text: addtable, color: fontGrey, size: 16.0),
      ),
      body: StreamBuilder(
          stream: StoreServices.gettables(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      data.length,
                      (index) => Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(() => TableEdit(
                                  data: data[index],
                                  tableId: data[index].id,
                                ));
                          },
                          leading: "${index + 1}".text.make(),
                          title: boldText(
                              text: "Table ${data[index]['tab_no']}",
                              color: fontGrey),
                          subtitle: Row(
                            children: [
                              normalText(
                                  text: "${data[index]['status']}",
                                  color: darkGrey),
                              10.widthBox,
                              boldText(
                                  text: data[index]['is_active'] == true
                                      ? "Active"
                                      : '',
                                  color: green),
                            ],
                          ),
                          trailing: VxPopupMenu(
                            arrowSize: 0.0,
                            menuBuilder: () => Column(
                              children: List.generate(
                                  tablePopMenuTitles.length,
                                  (i) => Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              tableMenuIcons[i],
                                              color: darkGrey,
                                            ),
                                            10.widthBox,
                                            normalText(
                                                text: tablePopMenuTitles[i],
                                                color: darkGrey)
                                          ],
                                        ).onTap(() {
                                          switch (i) {
                                            case 0:
                                              Get.to(() => TableEdit(
                                                  data: data[index],
                                                  tableId: data[index].id));
                                              break;
                                            case 1:
                                              controller.removeProduct(
                                                  data[index].id);
                                              VxToast.show(context,
                                                  msg: "Table removed");
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
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
