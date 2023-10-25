import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/Newuser_order/new_order_main_view_screen.dart';
import 'package:emart_seller/views/home_screen/home_screen.dart';
import 'package:emart_seller/views/profile_screen.dart/profile_screen.dart';

Widget themeFooter(context, {selected: 0, footerHide: false}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.add_circle_outline,
          size: 40.0,
        ),
        label: 'Order',
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
            new MaterialPageRoute(builder: (context) => new HomeScreen()));
      } else if (value == 1 && selected != 1) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new NewUserScreen()));
      } else if (value == 2 && selected != 2) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new ProfileScreen()));
      }
    },
  );
}
