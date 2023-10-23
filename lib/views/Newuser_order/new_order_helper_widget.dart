// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/views/Newuser_order/qrcode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../const/colors.dart';
import '../../controllers/newuser_order_controller.dart';
import '../../services/store_services.dart';
import '../../theme/style.dart';
import '../widgets/normal_text.dart';
import 'commponents/customeinput.dart';

Widget UserInfo(BuildContext context, controller, {nextFn: ''}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              (controller.editData.isNotEmpty)
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back))
                  : Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
              SizedBox(width: 10),
              GoogleText(
                  text: "Add Customer ${controller.IDdata} ",
                  color: Colors.black,
                  fsize: 16.0,
                  fweight: FontWeight.bold),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        20.heightBox,
        formInput(context, "name *", controller.pNameController, Icons.person),
        const SizedBox(height: 20.0),
        formInput(context, "mobile *", controller.pMobileController,
            Icons.phone_android_rounded,
            isNumber: true),
        const SizedBox(height: 20.0),
        formInput(
            context, "email", controller.pEmailController, Icons.email_rounded),
        const SizedBox(height: 20.0),
        formInput(context, "Address", controller.pAddressController,
            Icons.location_on),
        20.heightBox,
        themeButton3(context, nextFn,
            label: 'Next',
            buttonColor: themeBG4,
            radius: 2.0,
            btnHeightSize: 35.0)
      ],
    ),
  );
}

///////  Booked Table Slot Widget  +++++++++++++++++++++
/// ========================================================================
/// ========================================================================
/// ========================================================================
/// ========================================================================
/// ========================================================================
Widget BookTable(BuildContext context, controller, List alltablesdata,
    {laabel: 'Select Table', backFn: '', nextFn: '', refreshFn: ''}) {
  return Column(
    children: [
      3.heightBox,
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  if (backFn != '') {
                    backFn();
                  }
                },
                icon: Icon(Icons.arrow_back)),
            SizedBox(width: 10),
            GoogleText(
                text: "$laabel",
                color: Colors.black,
                fsize: 16.0,
                fweight: FontWeight.bold,
                fstyle: FontStyle.italic),
          ],
        ),
      ),
      Divider(
        color: Colors.black,
      ),
      10.heightBox,
      Container(
        height: MediaQuery.of(context).size.height - 320,
        width: MediaQuery.of(context).size.width,
        child: GridView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            children: [
              for (var index = 0; index < alltablesdata.length; index++)
                GestureDetector(
                  onTap: () async {
                    if (alltablesdata[index]['is_active']) {
                      await controller.changeTableIndex(index);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('tableid', alltablesdata[index].id);
                      controller.TempValue["table_id"] =
                          alltablesdata[index].id;
                    } else {
                      VxToast.show(context, msg: "Already Booked");
                    }
                    if (refreshFn != '') {
                      refreshFn();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Container(
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: 50.0,
                        decoration: BoxDecoration(
                            boxShadow: themeBox,
                            borderRadius: BorderRadius.circular(15),
                            color: (controller.TempValue["table_id"] ==
                                    alltablesdata[index].id)
                                ? Color.fromARGB(255, 132, 195, 134)
                                : (alltablesdata[index]['is_active'])
                                    ? Color.fromARGB(135, 255, 255, 255)
                                    : Color.fromARGB(255, 227, 116, 100),
                            border: Border.all(
                                color: const Color.fromARGB(255, 45, 177, 115),
                                width: 1.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GoogleText(
                                // text:
                                //     ' ${alltablesdata[index]['is_active'] ? '${alltablesdata[index]['tab_no']}' : 'Booked'}',
                                text: '${alltablesdata[index]['tab_no']}',
                                color: Colors.black,
                                fsize: 14.0,
                                fweight: FontWeight.w400),
                            Text('${alltablesdata[index]['t_desc']}',
                                style: themeTextStyle(
                                    size: 9.0, color: Colors.black))
                          ],
                        )),
                  ),
                ),
            ]),
      ),

      // Obx(
      //   () => Wrap(
      //     spacing: 10.0,
      //     runSpacing: 20.0,
      //     children: List.generate(alltablesdata.length, (index) {
      //       return GestureDetector(
      //         onTap: () async {
      //           if (alltablesdata[index]['is_active']) {
      //             await controller.changeTableIndex(index);
      //             SharedPreferences prefs =
      //                 await SharedPreferences.getInstance();
      //             prefs.setString('tableid', alltablesdata[index].id);
      //             controller.TempValue["table_id"] = alltablesdata[index].id;
      //           } else {
      //             VxToast.show(context, msg: "Already Booked");
      //           }
      //         },
      //         child: Container(
      //             padding: EdgeInsets.all(4),
      //             alignment: Alignment.center,
      //             width: MediaQuery.of(context).size.width / 3.5,
      //             height: 50.0,
      //             decoration: BoxDecoration(
      //                 boxShadow: themeBox,
      //                 borderRadius: BorderRadius.circular(15),
      //                 color: (controller.TempValue["table_id"] ==
      //                         alltablesdata[index].id)
      //                     ? Color.fromARGB(255, 132, 195, 134)
      //                     : (alltablesdata[index]['is_active'])
      //                         ? Color.fromARGB(135, 255, 255, 255)
      //                         : Color.fromARGB(255, 227, 116, 100),
      //                 border: Border.all(
      //                     color: const Color.fromARGB(255, 45, 177, 115),
      //                     width: 1.0)),
      //             child: GoogleText(
      //                 text:
      //                     ' ${alltablesdata[index]['is_active'] ? '${alltablesdata[index]['tab_no']}' : 'Booked'}',
      //                 color: Colors.black,
      //                 fsize: 14.0,
      //                 fweight: FontWeight.w400)),
      //       );
      //     }),
      //   ),
      // ),
      20.heightBox,
      themeButton3(context, nextFn,
          label: 'Next',
          buttonColor: themeBG4,
          radius: 2.0,
          btnHeightSize: 35.0)
    ],
  );
}

///======================================================

///  Cart Screen Widget ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Widget CartPreview(BuildContext context, controller, Map Pdata,
    {laabel: 'Cart', backFn: '', nextFn: ''}) {
  return Column(
    children: [
      Container(
        child: Row(
          children: [
            Container(
              child: IconButton(
                  onPressed: () {
                    if (backFn != '') {
                      backFn();
                    }
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            SizedBox(width: 10),
            GoogleText(
                text: "$laabel",
                color: Colors.black,
                fsize: 16.0,
                fweight: FontWeight.bold,
                fstyle: FontStyle.italic),
          ],
        ),
      ),
      const Divider(
        color: Colors.black,
      ),
      Container(
        height: MediaQuery.of(context).size.height - 300,
        child: ListView(
          children: [
            for (var key in Pdata.keys) productListCon(context, Pdata[key])
          ],
        ),
      ),

      // Product Total Con =================================================
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
                          text: "${controller.cartData.length}",
                          fsize: 15.0,
                          fweight: FontWeight.bold,
                          color: themeBG2),
                      10.heightBox,
                      GoogleText(
                          text: "₹ ${controller.total}",
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
                        if (nextFn != '') {
                          nextFn();
                        }
                        //_fnNext();
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
      )
    ],
  );
}

Widget productListCon(context, Pdata) {
  var img = (Pdata['p_imgs'][0] != null)
      ? Pdata['p_imgs'][0]
      : "https://img.lovepik.com/original_origin_pic/19/01/15/69dc6961ffbd70039d9220fa60547a0a.png_wh860.png";
  return Container(
      padding: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.076),
          borderRadius: BorderRadius.circular(12.5)),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.076),
                image: DecorationImage(
                    image: NetworkImage("$img"),
                    // NetworkImage("${Pdata[i]["p_imgs"][0]}"),

                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.5)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowTextWd(context, "Name", "${Pdata["p_name"]}"),
                RowTextWd(context, "Price", "${Pdata["p_price"]} Rs"),
                RowTextWd(context, "Quantity", "x${Pdata["qnt"]}"),
                RowTextWd(context, "Total", "${Pdata["subTotal"]} Rs/-"),
              ],
            ),
          ),
        ],
      ));
}

Widget RowTextWd(BuildContext context, lable, Val) {
  return Row(children: [
    SizedBox(
      width: 70,
      child: GoogleText(
          text: "$lable",
          fsize: 13.0,
          fweight: FontWeight.bold,
          color: Colors.black),
    ),
    GoogleText(
        text: ": $Val",
        fsize: 13.5,
        fweight: FontWeight.bold,
        color: Colors.black),
  ]);
}

Widget clientAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: themeBG2,
    elevation: 0,
    centerTitle: false,
    titleSpacing: 0,
    title: Text("Insaaf99"),
  );
}

//????????????  MyDrawer  ++++++++++++++++++++++++++++++++++++++++++++++

Widget themeHeaderHome(
  context, {
  title = '',
}) {
  return Container(
      padding: EdgeInsets.only(top: 10),

      // decoration: BoxDecoration(
      //     color: Color.fromARGB(255, 9, 63, 190),
      //     borderRadius: BorderRadius.only(
      //         bottomRight: Radius.circular(30),
      //         bottomLeft: Radius.circular(30))),
      child: Row(
        children: [
          Container(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
          ),
          SizedBox(width: 10.0),
          Text(
            '$title',
            style: themeTextStyle(size: 14.0, fw: FontWeight.bold),
          )
        ],
      ));
}

//

Widget myFormField(BuildContext context, controller, label,
    {readOnly = false,
    onlyNumber = false,
    icon = '',
    fn = '',
    maxLine = 1,
    maxLength = 100}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoogleText(
            text: "$label",
            fweight: FontWeight.bold,
            color: Colors.black,
            fsize: 18.0),
        SizedBox(height: 8.0),
        Container(
          height: 85,
          padding: EdgeInsets.symmetric(
              vertical: (maxLine == 1) ? 0.0 : 7.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 206, 206, 206)),
              borderRadius: BorderRadius.circular(10.0)),
          child: TextFormField(
            textInputAction:
                (maxLine == 1) ? TextInputAction.go : TextInputAction.newline,

            onChanged: (value) {
              if (value.length == maxLength) {
                FocusScope.of(context).nextFocus();
              }
            },

            style: TextStyle(fontSize: 16.0),
            // onTap: () {
            //   if (fn == 'date_of_admission') {
            //     datePick('date_of_admission');
            //   } else if (fn == 'date_of_discharge') {
            //     datePick('date_of_discharge');
            //   }
            // },
            controller: controller,
            readOnly: (readOnly) ? true : false,
            maxLength: (maxLength == 100) ? 200 : maxLength,
            maxLines: (maxLine == 1) ? 1 : maxLine,
            keyboardType: (onlyNumber)
                ? TextInputType.number
                : (maxLine == 1)
                    ? TextInputType.text
                    : TextInputType.multiline,

            obscureText: (label == 'Change PIN - (Optional)') ? true : false,
            decoration: InputDecoration(
              counterText: "",
              hintText: label,
              filled: true,
              fillColor: Color.fromARGB(255, 255, 255, 255),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              suffixIcon: (icon == '')
                  ? Text("")
                  : Icon(
                      icon,
                      color: themeBG2,
                    ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    ),
  );
}

//////demo
/// ============================================================================
