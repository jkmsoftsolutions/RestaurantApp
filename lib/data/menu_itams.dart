import '../models/menu_item.dart';

class MenuItems {
  static const List<MenuItem> itemsFirst = [
    itemSettings,
    itemShare,
  ];
  static const List<MenuItem> itemsSecond = [
    itemSignOut,
  ];

  static const itemSettings = MenuItem(text: 'Edit Table');
  static const itemShare = MenuItem(
    text: 'Delate',
  );
  static const itemSignOut = MenuItem(
    text: 'Sign Out',
  );
}
