import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/kitchen_screen/views/home_screen/khome_screen.dart';
import 'package:emart_seller/kitchen_screen/views/orders_screen/orders_screen.dart';
import 'package:emart_seller/kitchen_screen/views/profile_screen.dart/profile_screen.dart';
import 'package:emart_seller/views/home_screen/home_screen.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
import 'package:emart_seller/views/profile_screen.dart/profile_screen.dart';

Widget kthemeFooter(context, {selected: 0, footerHide: false}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.article_rounded,
        ),
        label: 'Order List',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list_rounded),
        label: 'More',
      ),
    ],
    currentIndex: selected,
    onTap: (value) {
      if (value == 0 && selected != 0) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new KHomeScreen()));
      } else if (value == 1 && selected != 1) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new KOrdersScreen()));
      } else if (value == 2 && selected != 2) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new KProfileScreen()));
      }
    },
  );
}
