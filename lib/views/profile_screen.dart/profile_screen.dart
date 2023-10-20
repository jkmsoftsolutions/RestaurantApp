import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/controllers/auth_controller.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:emart_seller/views/category_screen/category_screen.dart';
import 'package:emart_seller/views/profile_screen.dart/edit_profilescreen.dart';
import 'package:emart_seller/views/shop_screen/shop_settings_screen.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';
import '../../const/const.dart';
import '../orders_screen/orders_screen.dart';
import '../products_screen/products_screen.dart';
import '../subcategory_screen/subcategory_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 246, 246),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, color: Colors.black, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen(
                      username: controller.snapshotData['vendor_name'],
                    ));
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              )),
          TextButton(
              onPressed: () async {
                await Get.put(AuthController()).signoutMethod(context);
                Get.offAll(() => LoginPage());
              },
              child: normalText(text: logout, color: Colors.black)),
        ],
      ),
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingIndicator(circleColor: black);
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            return Column(
              children: [
                ListTile(
                  leading: Image.asset(imgProduct)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make(),
                  title: boldText(
                      text: "${controller.snapshotData["vendor_name"]}",
                      color: black),
                  subtitle: normalText(
                      text: "${controller.snapshotData["email"]}",
                      color: black),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                        profileButtonsIcons.length,
                        (index) => ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Get.to(() => const ProductsScreen());
                                    break;
                                  case 1:
                                    Get.to(() => const OrdersScreen());
                                    break;
                                  case 2:
                                    Get.to(() => const ShopSettings());
                                    break;
                                  case 3:
                                    Get.to(() => const CategoryScreen());
                                    break;
                                  case 4:
                                    Get.to(() => const SubCategoryScreen());
                                    break;
                                }
                              },
                              leading: Icon(
                                profileButtonsIcons[index],
                                color: black,
                              ),
                              title: normalText(
                                  text: profileButtonsTitle[index],
                                  color: black),
                            )),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
