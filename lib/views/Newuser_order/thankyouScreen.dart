// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/Newuser_order/createInvoice.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';
import '../home_screen/home.dart';
import 'invoice_serv.dart';

class ThankScreen extends StatefulWidget {
  ThankScreen({Key? key}) : super(key: key);

  @override
  State<ThankScreen> createState() => _ThankScreenState();
}

class _ThankScreenState extends State<ThankScreen> {
  var homeController = Get.put(HomeController());

  //creating method to change screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: wd_thanks(context));
  }

  Widget wd_thanks(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.check_circle,
          //   color: Colors.green,
          //   size: 100,
          // ),
          Image.asset(
            "assets/icons/thank2.gif",
            height: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Thank You !!",
              style: GoogleFonts.alike(
                  fontSize: 30.0,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Text(
            "Your Order Successfully Completed !!1",
            style: GoogleFonts.alike(
                fontSize: 18.0,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 30.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              themeButton3(context, () {
                setState(() {
                  homeController.navIndex = 0.obs;
                });
                nextScreenReplace(context, Home());
              }, radius: 5.0, label: "<< Go Home ", buttonColor: themeBG),
              20.widthBox,
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Background color
                    ),
                    onPressed: () async {
                      final data = await InvoiceService(
                        PriceDetail: edata,
                      ).createInvoice();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Invoice_pdf(
                              BytesCode: byteList, PriceDetail: PriceDetail),
                        ),
                      );
                      themeAlert(context, "Successfully Download !!!");
                    },
                    child: Icon(Icons.download)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
