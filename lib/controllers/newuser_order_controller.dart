import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class NewUserOrderController extends GetxController {
  var isloading = false.obs;
//text field controller
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  var quantity = 1.obs;
  var totalPrice = 0.obs;

  List<Category> category = [];
  var pImagesLinks = [];

  var selectedtableIndex = 0.obs;

//featch data in database User

//method to increase & decrease quantity
  increaseQuantity(totalQuantity) {
    quantity.value++;
    // if (quantity.value < totalQuantity) {
    //   quantity.value++;
    // }
  }

  decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  //method calculate total price
  calculateTotalPice(price) {
    totalPrice.value = price * quantity.value;
  }

  //table method
  changeTableIndex(index) {
    selectedtableIndex.value = index;
  }

  // update product
  update_product(context, id) async {
    var store = firestore.collection(productsCollections).doc(id);

    await store.set({
      'is_featured': false,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': '',
    });
    isloading(false);
    VxToast.show(context, msg: "Product Updated");
    cleartext();
  }

  // clear controllers
  void cleartext() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquantityController.clear();
  }
}
