// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names, unused_element, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/NewUser_widget.dart';
import 'package:emart_seller/views/Newuser_order/search_screen.dart';
import 'package:emart_seller/views/Newuser_order/select_table.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:get/get.dart';
import '../../const/style.dart';
import '../../controllers/newuser_order_controller.dart';

import '../../theme/firebase_functions.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/normal_text.dart';
import 'payment_screen.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  var controller = Get.put(NewUserOrderController());
  var db = FirebaseFirestore.instance;

  bool wait = true;

  @override
  void initState() {
    super.initState();
  }

  int step = 1;
  //Back Function
  _fnBack() {
    setState(() {
      step = step - 1;
      // value = (step_no == 1) ? 0.3 : 0.6;
    });
  }

  _fnNext() async {
    var alert = "";
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (step == 1 &&
        controller.pNameController.text.isNotEmpty &&
        controller.pMobileController.text.length >= 10 &&
        controller.pMobileController.text.isNotEmpty &&
        regex.hasMatch(controller.pEmailController.text) &&
        controller.pEmailController.text.isNotEmpty &&
        controller.pAddressController.text.isNotEmpty) {
      var Cust_ID = await controller.storeUserData();
      setState(() {
        controller.TempValue["name"] = "${controller.pNameController.text}";
        controller.TempValue["email"] = "${controller.pEmailController.text}";
        controller.TempValue["phone"] = "${controller.pMobileController.text}";
        controller.TempValue["Address"] =
            "${controller.pAddressController.text}";
        controller.TempValue["customer_id"] = "$Cust_ID";
        step = step + 1;
      });
    } else if (step == 2 && controller.TempValue["table_id"] != null) {
      setState(() {
        step = step + 1;
      });
    } else if (step == 3 && controller.TempValue["items_data"] != null) {
      setState(() {
        step = step + 1;
        Map Odata = controller.TempValue["items_data"];
        for (var key in Odata.keys) {
          //
          Map tempMap = {
            ////
            "img": "${Odata[key]['p_imgs'][0]}",
            "vendor_id": "${currentUser!.uid}",
            "qty": "${"${Odata[key]['qnt']}"}",
            "title": "${"${Odata[key]['p_name']}"}",
            "tprice": "${"${Odata[key]['subTotal']}"}",
          };
          controller.orderData.add(tempMap);
        }
      });

      controller.IDdata = await controller.fnOrderAdd(
        context,
      );
    } else {
      if (step == 1 && controller.pMobileController.text.length < 10) {
        themeAlert(context, "Mobile Number must be of 10 digit !!",
            type: "error");
        // themeAlert(context, "Please Enter Required Value !!", type: "error");
      }
      if (step == 1 && controller.pEmailController.text.isEmpty) {
        themeAlert(context, "Please Enter Valid Email !!", type: "error");
      }
      if (step == 2) {
        themeAlert(context, "Please Select Table !!", type: "error");
      }
      if (step == 3) {
        themeAlert(context, "Please Add Items !!", type: "error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.black12,
      //   title: GoogleText(
      //       text: "New User Info",
      //       color: Colors.black,
      //       fsize: 18.0,
      //       fweight: FontWeight.bold),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            20.heightBox,
            (step == 1) ? UserInfo(context) : SizedBox(),
            (step == 2) ? BookTablePage(context) : SizedBox(),
            (step == 3) ? ProductsScreen(context) : SizedBox(),
            (step == 4)
                ? CartPage(context, controller.TempValue["items_data"])
                : SizedBox(),
            20.heightBox,
            const Divider(
              color: Colors.black,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                (step == 1)
                    ? SizedBox()
                    : themeButton3(context, () {
                        _fnBack();
                      },
                        btnHeightSize: 40.0,
                        btnWidthSize: 100.0,
                        fontSize: 15.0,
                        label: "<< Previous",
                        buttonColor: Colors.black),
                SizedBox(width: 20.0),
                (step == 4)
                    ? themeButton3(context, () {
                        Get.to(PaymentScreen(OrderID: "${controller.IDdata}"));
                      },
                        label: " Pay ${controller.total} Rs/-  ",
                        radius: 5.0,
                        buttonColor: Colors.green)
                    : themeButton3(context, () {
                        _fnNext();
                        // Get.to(() => const SelectableScreen());
                      },
                        btnWidthSize: 100.0,
                        buttonColor: themeBG4,
                        btnHeightSize: 40.0,
                        fontSize: 15.0,
                        label: "Next >>"),
              ]),
            ),
          ],
        ),
      ),
    );
  }

///////////  Book Table Screen  +++++++++++++++++++++++++++++++++++++++++++++++++
  Widget BookTablePage(BuildContext context) {
    return StreamBuilder(
        stream: StoreServices.allTables(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingIndicator();
          } else {
            var alltablesdata = snapshot.data!.docs;
            return BookTable(context, alltablesdata);
          }
        });
  }

  /// =============================================================================

/////////  Widget for Product select ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Widget ProductsScreen(BuildContext context) {
    // for (var i = 0; i < controller.allproductsdata.length; i++) {
    //    print("${controller.allproductsdata[i]}   +++++++");
    //   }
    return StreamBuilder(
        stream: StoreServices.allproducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingIndicator();
          } else {
            var allproductsdatavv = snapshot.data!.docs;

            return

                // (controller.allproductsdata.isEmpty)
                //     ? LoadingIndicator()
                //     :
                Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    color: lightGrey,
                    child: TextFormField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.search).onTap(() {
                          if (controller
                              .searchController.text.isNotEmptyAndNotNull) {
                            Get.to(() => SearchScreen(
                                  title: controller.searchController.text,
                                ));
                          }
                        }),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: searchanything,
                        hintStyle: const TextStyle(
                          color: textfieldGrey,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 450,
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: [
                          for (var index = 0;
                              index < allproductsdatavv.length;
                              index++)
                            // Text("data")
                            ProductCon(context, allproductsdatavv[index])
                        ]),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GoogleText(
                                text: "Items",
                                fsize: 16.0,
                                fweight: FontWeight.bold,
                                color: Colors.black),
                            10.heightBox,
                            GoogleText(
                                text: "Total Price",
                                fsize: 16.0,
                                fweight: FontWeight.bold,
                                color: Colors.black),
                          ],
                        ),
                        Column(
                          children: [
                            GoogleText(
                                text: "${controller.cartData.length}",
                                fsize: 15.0,
                                fweight: FontWeight.bold,
                                color: Colors.green),
                            10.heightBox,
                            GoogleText(
                                text: "₹ ${controller.total} /-",
                                fsize: 15.0,
                                fweight: FontWeight.bold,
                                color: Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget ProductCon(BuildContext context, pdata) {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (controller.SelectProList.isEmpty) {
              controller.selectProName = "${pdata['p_name']}";
              controller.selectProPrice = "${pdata['p_price']}";

              controller.SelectProList.add({
                "product_name": "${controller.selectProName}",
                "product_price": "${controller.selectProPrice}"
              });
            } else {
              controller.selectProName = "${pdata['p_name']}";
              controller.selectProPrice = "${pdata['p_price']}";
              controller.SelectProList.add({
                "product_name": "${controller.selectProName}",
                "product_price": "${controller.selectProPrice}"
              });
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: themeBox,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: IncrDecre(context, pdata),
                height: MediaQuery.of(context).size.height / 8.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        pdata['p_imgs'][0],
                      ),
                      fit: BoxFit.fill),
                ),
              ),
              10.heightBox,
              GoogleText(
                  text: "${pdata['p_name']}",
                  color: darkFontGrey,
                  fsize: 12.0,
                  fweight: FontWeight.bold),
              10.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GoogleText(
                      text: "₹ ${pdata['p_price']}",
                      color: redColor,
                      fsize: 15.0,
                      fweight: FontWeight.normal),
                  Text(
                      '${(controller.cartData[pdata.id] != null) ? controller.cartData[pdata.id]['qnt'] : 0}'),
                  //IncrDecre(context, pdata),
                ],
              ),
            ],
          ),
        ));
  }

  Widget IncrDecre(BuildContext context, pdata) {
    var quantity = 1.obs;
    //print(controller.cartData);
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  await fnAddProductInCart(pdata, 'decr');
                  controller.TempValue["items_data"] =
                      await controller.cartData;
                },
                icon: const Icon(
                  Icons.remove,
                  color: Color.fromARGB(255, 228, 77, 67),
                  size: 30,
                )
                    .box
                    .roundedFull
                    .color(const Color.fromARGB(255, 28, 28, 28))
                    .make()),
            IconButton(
                onPressed: () async {
                  await fnAddProductInCart(pdata, 'incr');
                  controller.TempValue["items_data"] =
                      await controller.cartData;
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 30,
                )
                    .box
                    .roundedFull
                    .color(const Color.fromARGB(255, 28, 28, 28))
                    .make()),
          ],
        )
            .box
            .transparent
            .margin(const EdgeInsets.symmetric(horizontal: 0))
            .make(),
      ),
    );
  }

  // add product in cart
  fnAddProductInCart(data, type) async {
    await controller.calculateTotal(data, type);

    setState(() {});
  }
}
