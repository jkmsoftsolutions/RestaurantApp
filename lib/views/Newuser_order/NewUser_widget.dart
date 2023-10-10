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

var controller = Get.put(NewUserOrderController());
Widget UserInfo(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blue,
                size: 30,
              ),
              SizedBox(width: 10),
              GoogleText(
                  text: "Customer Info",
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
        20.heightBox,
        formInput(context, "name", controller.pNameController, Icons.person),
        const SizedBox(height: 20.0),
        formInput(context, "mobile", controller.pMobileController,
            Icons.phone_android_rounded),
        const SizedBox(height: 20.0),
        formInput(
            context, "email", controller.pEmailController, Icons.email_rounded),
        const SizedBox(height: 20.0),
        formInput(context, "Address", controller.pAddressController,
            Icons.location_on)
      ],
    ),
  );
}

///////  Booked Table Slot Widget  +++++++++++++++++++++
Widget BookTable(BuildContext context, List alltablesdata) {
  return Column(
    children: [
      20.heightBox,
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Icon(
              Icons.table_bar_rounded,
              color: Colors.blue,
              size: 30,
            ),
            SizedBox(width: 10),
            GoogleText(
                text: "Select & Book Table",
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
      Obx(
        () => Wrap(
          spacing: 10.0,
          runSpacing: 20.0,
          children: List.generate(alltablesdata.length, (index) {
            return GestureDetector(
              onTap: () async {
                if (alltablesdata[index]['is_active']) {
                  await controller.changeTableIndex(index);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('tableid', alltablesdata[index].id);
                  controller.TempValue["table_id"] = alltablesdata[index].id;
                  print("${controller.TempValue}   iiii===");
                } else {
                  VxToast.show(context, msg: "Already Booked");
                }
              },
              child: Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 50.0,
                  decoration: BoxDecoration(
                      boxShadow: themeBox,
                      borderRadius: BorderRadius.circular(15),
                      color: (controller.selectedtableIndex.value == index &&
                              alltablesdata[index]['is_active'])
                          ? Colors.green
                          : (alltablesdata[index]['is_active'])
                              ? Color.fromARGB(137, 138, 137, 137)
                              : Color.fromARGB(255, 159, 28, 8),
                      border: Border.all(
                          color: const Color.fromARGB(255, 45, 177, 115),
                          width: 1.0)),
                  child: GoogleText(
                      text:
                          'Table ${alltablesdata[index]['is_active'] ? '${alltablesdata[index]['tab_no']}' : 'Booked'}',
                      color: Colors.white,
                      fsize: 14.0,
                      fweight: FontWeight.w400)
                  // Text(
                  //   'Table ${alltablesdata[index]['is_active'] ? '${alltablesdata[index]['tab_no']}' : 'Booked'}'  ,

                  // ),
                  ),
            );
          }),
        ),
      ),
    ],
  );
}

///======================================================

///  Cart Screen Widget ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Widget CartPage(BuildContext context, Map Pdata) {
  return Column(
    children: [
      Container(
        child: Row(
          children: [
            Icon(
              Icons.production_quantity_limits,
              color: Colors.blue,
              size: 30,
            ),
            SizedBox(width: 10),
            GoogleText(
                text: "Add To Cart",
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
        height: 450,
        child: ListView(
          children: [
            for (var key in Pdata.keys) productListCon(context, Pdata[key])
          ],
        ),
      ),
      // Divider(color: Colors.black, thickness: 1.0),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     const Center(
      //       child: QRCode(
      //         qrSize: 100,
      //         qrData: 'https://insaaf99.com/',
      //       ),
      //     ),
      //     themeButton3(context, () {
      //       showDialog<String>(
      //         context: context,
      //         builder: (BuildContext context) => AlertDialog(
      //           title: const Text('Fill Total Amount'),
      //           content: Container(
      //             width: 200,
      //             child: TextFormField(
      //               initialValue: "${controller.total}",
      //               decoration: const InputDecoration(
      //                 border: UnderlineInputBorder(),
      //                 labelText: 'Enter your Amount',
      //               ),
      //             ),
      //           ),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () => Navigator.pop(context, 'Cancel'),
      //               child: GoogleText(
      //                   text: "Cancel",
      //                   color: Colors.red,
      //                   fweight: FontWeight.bold),
      //             ),
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context, 'Submit');
      //               },
      //               child: GoogleText(
      //                   text: "Submit",
      //                   color: Colors.green,
      //                   fweight: FontWeight.bold),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //         label: "    ${controller.total} Rs /-  ",
      //         radius: 5.0,
      //         buttonColor: Colors.green),
      //   ],
      // )
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
                RowTextWd(context, "Quantity", "X${Pdata["qnt"]}"),
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
      height: 140,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 9, 63, 190),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.white,
                    )),
                SizedBox(height: 15),
                GoogleText(
                    color: Colors.white,
                    text: "  Payment",
                    fsize: 22.0,
                    fweight: FontWeight.bold)
              ],
            ),
          ),
          Expanded(
              child: Image.asset(
            "assets/icons/payment.png",
            fit: BoxFit.cover,
          ))
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
