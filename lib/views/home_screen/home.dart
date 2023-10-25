import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:emart_seller/theme/footer.dart';
import 'package:emart_seller/views/home_screen/home_screen.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
import 'package:emart_seller/views/products_screen/products_screen.dart';
import 'package:emart_seller/views/profile_screen.dart/profile_screen.dart';
import 'package:get/get.dart';
import '../Newuser_order/new_order_main_view_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    /*var controller = Get.put(HomeController());

    var navScreen = [
      const HomeScreen(),
      const NewUserScreen(),
      //const ProductsScreen(),
      // const OrdersScreen(),

      const ProfileScreen(),
    ];
    var bottomNavbar = [
      const BottomNavigationBarItem(
          icon: Icon(Icons.space_dashboard), label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icnewOreders,
            color: Color.fromARGB(255, 184, 46, 194),
            width: 50,
          ),
          label: neworders),
      // BottomNavigationBarItem(
      //     icon: Image.asset(
      //       icProducts,
      //       color: darkGrey,
      //       width: 24,
      //     ),
      //     label: products),
      BottomNavigationBarItem(icon: Icon(Icons.dehaze_rounded), label: more),
    ];
    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Get.to(() => const NewUserScreen());
      //   },
      //   icon: Icon(Icons.article_outlined),
      //   label: Text("New Orders"),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.navIndex.value = index;
          },
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: purpleColor,
          unselectedItemColor: darkGrey,
          items: bottomNavbar,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value)),
          ],
        ),
      ),
    );
  }
  */

    // =========================================================
    return Scaffold(
      body: HomeScreen(),
    );
  }
}
