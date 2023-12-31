// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/products_screen/add_product.dart';
import 'package:emart_seller/views/products_screen/edit_productscreen.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/normal_text.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          await controller.CateData();
          //await controller.getCategory();
          // await controller.populateCategoryList();

          Get.to(() => const AddProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
          automaticallyImplyLeading: true,
          title: boldText(text: products, color: Colors.black, size: 16.0)),
      body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
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
                  child: (kIsWeb)
                      ? Center(
                          child: Container(
                            width: 800,
                            child: Column(
                              children: List.generate(data.length, (index) {
                                var dataArr =
                                    data[index].data() as Map<dynamic, dynamic>;
                                return Card(
                                  //
                                  color: (dataArr['status'] != null &&
                                          dataArr['status']
                                                  .toString()
                                                  .toLowerCase() ==
                                              'inactive')
                                      ? Color.fromARGB(255, 255, 215, 212)
                                      : Colors.white,
                                  child: ListTile(
                                      onTap: () {
                                        Get.to(() => ProductDetails(
                                              data: data[index],
                                            ));
                                      },
                                      leading: Image.network(
                                          data[index]['p_imgs'][0],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover),
                                      title: boldText(
                                          text: "${data[index]['p_name']}",
                                          color: fontGrey),
                                      subtitle: Row(
                                        children: [
                                          normalText(
                                              text:
                                                  "₹${data[index]['p_price']}",
                                              color: darkGrey),
                                          10.widthBox,
                                          boldText(
                                              text: data[index]
                                                          ['is_featured'] ==
                                                      true
                                                  ? "Featured"
                                                  : '',
                                              color: green),
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                          itemBuilder: (context) => [
                                                for (var i = 0;
                                                    i < popupMenuTitles.length;
                                                    i++)
                                                  PopupMenuItem(
                                                    onTap: (() async {
                                                      switch (i) {
                                                        case 0:
                                                          if (data[index][
                                                                  'is_featured'] ==
                                                              true) {
                                                            controller
                                                                .removeFeatured(
                                                                    data[index]
                                                                        .id);
                                                            VxToast.show(
                                                                context,
                                                                msg: "Removed");
                                                          } else {
                                                            controller
                                                                .addFeatured(
                                                                    data[index]
                                                                        .id);
                                                            VxToast.show(
                                                                context,
                                                                msg: "Added");
                                                          }
                                                          break;
                                                        case 1:
                                                          await controller
                                                              .CateData();
                                                          //  await controller.getCategory();
                                                          // controller.populateCategoryList();
                                                          Get.to(() =>
                                                              EditProductScreen(
                                                                  data: data[
                                                                      index],
                                                                  productId:
                                                                      data[index]
                                                                          .id));
                                                          break;
                                                        case 2:
                                                          controller
                                                              .removeProduct(
                                                                  data[index]
                                                                      .id);
                                                          VxToast.show(context,
                                                              msg:
                                                                  "Product removed");
                                                          break;
                                                        default:
                                                      }
                                                    }),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          popupMenuIcons[i],
                                                          color: data[index][
                                                                          'featured_id'] ==
                                                                      currentUser!
                                                                          .uid &&
                                                                  i == 0
                                                              ? green
                                                              : darkGrey,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            data[index]['featured_id'] ==
                                                                        currentUser!
                                                                            .uid &&
                                                                    i == 0
                                                                ? 'Remove feature'
                                                                : popupMenuTitles[
                                                                    i],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color:
                                                                    darkGrey))
                                                      ],
                                                    ),
                                                  ),
                                              ])),
                                );
                              }),
                            ),
                          ),
                        )
                      : Column(
                          children: List.generate(data.length, (index) {
                            var dataArr =
                                data[index].data() as Map<dynamic, dynamic>;
                            return Card(
                              //
                              color: (dataArr['status'] != null &&
                                      dataArr['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'inactive')
                                  ? Color.fromARGB(255, 255, 215, 212)
                                  : Colors.white,
                              child: ListTile(
                                  onTap: () {
                                    Get.to(() => ProductDetails(
                                          data: data[index],
                                        ));
                                  },
                                  leading: Image.network(
                                      data[index]['p_imgs'][0],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  title: boldText(
                                      text: "${data[index]['p_name']}",
                                      color: fontGrey),
                                  subtitle: Row(
                                    children: [
                                      normalText(
                                          text: "₹${data[index]['p_price']}",
                                          color: darkGrey),
                                      10.widthBox,
                                      boldText(
                                          text:
                                              data[index]['is_featured'] == true
                                                  ? "Featured"
                                                  : '',
                                          color: green),
                                    ],
                                  ),
                                  trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                            for (var i = 0;
                                                i < popupMenuTitles.length;
                                                i++)
                                              PopupMenuItem(
                                                onTap: (() async {
                                                  switch (i) {
                                                    case 0:
                                                      if (data[index]
                                                              ['is_featured'] ==
                                                          true) {
                                                        controller
                                                            .removeFeatured(
                                                                data[index].id);
                                                        VxToast.show(context,
                                                            msg: "Removed");
                                                      } else {
                                                        controller.addFeatured(
                                                            data[index].id);
                                                        VxToast.show(context,
                                                            msg: "Added");
                                                      }
                                                      break;
                                                    case 1:
                                                      await controller
                                                          .CateData();
                                                      //  await controller.getCategory();
                                                      // controller.populateCategoryList();
                                                      Get.to(() =>
                                                          EditProductScreen(
                                                              data: data[index],
                                                              productId:
                                                                  data[index]
                                                                      .id));
                                                      break;
                                                    case 2:
                                                      controller.removeProduct(
                                                          data[index].id);
                                                      VxToast.show(context,
                                                          msg:
                                                              "Product removed");
                                                      break;
                                                    default:
                                                  }
                                                }),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      popupMenuIcons[i],
                                                      color: data[index][
                                                                      'featured_id'] ==
                                                                  currentUser!
                                                                      .uid &&
                                                              i == 0
                                                          ? green
                                                          : darkGrey,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        data[index]['featured_id'] ==
                                                                    currentUser!
                                                                        .uid &&
                                                                i == 0
                                                            ? 'Remove feature'
                                                            : popupMenuTitles[
                                                                i],
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: darkGrey))
                                                  ],
                                                ),
                                              ),
                                          ])),
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
