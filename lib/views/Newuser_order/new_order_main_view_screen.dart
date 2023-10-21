// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names, unused_element, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/theme/footer.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/new_order_helper_widget.dart';
import 'package:emart_seller/views/Newuser_order/commponents/new_order_widgets.dart';

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
  final orderId;
  const NewUserScreen({super.key, this.orderId});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  //var controller = Get.put(NewUserOrderController());
  var controller = new NewUserOrderController();
  var db = FirebaseFirestore.instance;
  var docId = '';
  bool wait = true;

  initFun() async {
    docId = (widget.orderId == null) ? '' : widget.orderId;
    await controller.initController(docId: docId);
    setState(() {
      wait = false;
    });
  }

  @override
  void initState() {
    initFun();
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

  //Back Function
  RoutePayPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentScreen(
                controller: controller, OrderID: "${controller.IDdata}")));
  }

  refreshFn() {
    setState(() {});
  }

  _fnNext() async {
    if (step == 1) {
      var alert = "";
      var r = await controller.addNewCustomer(context);
      if (r != false) {
        setState(() {
          step = step + 1;
        });
      }
    } else if (step == 2 && controller.TempValue["table_id"] != null) {
      setState(() {
        step = step + 1;
      });
    } else if (step == 3 && controller.TempValue["items_data"] != null) {
      setState(() {
        step = step + 1;
        Map Odata = controller.TempValue["items_data"];
        controller.orderData = [];
        for (var key in Odata.keys) {
          //
          Map tempMap = {
            ////
            "img": "${Odata[key]['p_imgs'][0]}",
            "vendor_id": "${currentUser!.uid}",
            "id": "${Odata[key]['id']}",
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
      bottomNavigationBar:
          (controller.editData != null && controller.editData.isNotEmpty)
              ? SizedBox()
              : themeFooter(context, selected: 1),
      // appBar: AppBar(
      //   backgroundColor: Colors.black12,
      //   title: GoogleText(
      //       text: "New User Info",
      //       color: Colors.black,
      //       fsize: 18.0,
      //       fweight: FontWeight.bold),
      // ),
      body: (wait)
          ? progress()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  3.heightBox,
                  (step == 1)
                      ? UserInfo(context, controller, nextFn: _fnNext)
                      : SizedBox(),
                  (step == 2) ? BookTablePage(context) : SizedBox(),
                  (step == 3) ? ProductsScreen(context) : SizedBox(),
                  (step == 4)
                      ? CartPreview(context, controller,
                          controller.TempValue["items_data"],
                          laabel: 'Cart Preview',
                          backFn: _fnBack,
                          nextFn: RoutePayPage)
                      : SizedBox(),
                  20.heightBox,
                  const Divider(
                    color: Colors.black,
                  ),
                  (step == 1 || step == 2 || step == 3 || step == 4)
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                // (step == 4)
                                //     ? themeButton3(context, () {
                                //         Get.to(PaymentScreen(
                                //             OrderID: "${controller.IDdata}"));
                                //       },
                                //         label: " Pay ${controller.total} Rs/-  ",
                                //         radius: 5.0,
                                //         buttonColor: Colors.green)
                                //     : themeButton3(context, () {
                                //         _fnNext();
                                //         // Get.to(() => const SelectableScreen());
                                //       },
                                //         btnWidthSize: 100.0,
                                //         buttonColor: themeBG4,
                                //         btnHeightSize: 40.0,
                                //         fontSize: 15.0,
                                //         label: "Next >>"),
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

            return BookTable(context, controller, alltablesdata,
                nextFn: _fnNext, backFn: _fnBack, refreshFn: refreshFn);
          }
        });
  }

  /// =============================================================================

/////////  Widget for Product select ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Widget ProductsScreen(BuildContext context) {
    // return StreamBuilder(
    //     stream: StoreServices.allproducts(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (!snapshot.hasData) {
    //         return LoadingIndicator();
    //       } else {
    //         var allproductsdatavv = snapshot.data!.docs;

    return (controller.productList.isEmpty)
        ? progress()
        : Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: IconButton(
                          onPressed: () {
                            _fnBack();
                          },
                          icon: Icon(Icons.arrow_back)),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: MediaQuery.of(context).size.width - 130.0,
                      color: lightGrey,
                      child: TextFormField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: whiteColor,
                          hintText: searchanything,
                          hintStyle: const TextStyle(
                            color: textfieldGrey,
                          ),
                        ),
                        onChanged: (value) {
                          controller.SearchFn(value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                // product gradient listing =================================
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                  child: GridView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: [
                        for (var k in controller.productList.keys)
                          ProductCon(context, controller.productList[k])
                      ]),
                ),
                // bottom button & total ============================
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 238, 238),
                      boxShadow: themeBox,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            //width: MediaQuery.of(context).size.width / 2 + 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GoogleText(
                                    text: "Items",
                                    fsize: 12.0,
                                    fweight: FontWeight.bold,
                                    color: Colors.black),
                                10.heightBox,
                                GoogleText(
                                    text: "Total Price",
                                    fsize: 12.0,
                                    fweight: FontWeight.bold,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                          SizedBox(width: 50.0),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GoogleText(
                                    text: ": ${controller.cartData.length}",
                                    fsize: 15.0,
                                    fweight: FontWeight.bold,
                                    color: themeBG2),
                                10.heightBox,
                                GoogleText(
                                    text: ": ₹${controller.total}",
                                    fsize: 15.0,
                                    fweight: FontWeight.bold,
                                    color: themeBG2),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _fnNext();
                                },
                                icon: Icon(
                                  Icons.send,
                                  size: 40.0,
                                  color: themeBG4,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
    //   }
    // );
  }

  // product widgets =====================================================
  Widget ProductCon(BuildContext context, pdata) {
    var pImgSize = MediaQuery.of(context).size.height / 8.5;

    return Container(
      decoration: BoxDecoration(
        color: (controller.cartData[pdata['id']] != null)
            ? Color.fromARGB(255, 255, 219, 237)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: themeBox,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: IncrDecre(context, pdata, pImgSize),
            height: pImgSize,
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
                  '${(controller.cartData[pdata['id']] != null) ? controller.cartData[pdata['id']]['qnt'] : 0}'),
              //IncrDecre(context, pdata),
            ],
          ),
        ],
      ),
    );
  }

  Widget IncrDecre(BuildContext context, pdata, pImgSize) {
    var quantity = 1.obs;
    //print(controller.cartData);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: wd_increesBtn('-', fnAddProductInCart, pdata,
                  height: pImgSize)),
          Expanded(
              child: wd_increesBtn('+', fnAddProductInCart, pdata,
                  height: pImgSize)),
        ],
      )
          .box
          .transparent
          .margin(const EdgeInsets.symmetric(horizontal: 0))
          .make(),
    );
  }

  // add product in cart
  fnAddProductInCart(data, type) async {
    await controller.calculateTotal(data, type);

    setState(() {});
  }
}
