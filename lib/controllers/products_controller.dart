import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:emart_seller/theme/function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/category_model.dart';

class ProductsController extends GetxController {
  var isloading = false.obs;

//text field controller

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  var statusList = ['Active', 'InActive'];
  List<Category> category = [];
  var pImagesLinks = [];
  // var pImagesLinks = [
  //   'https://firebasestorage.googleapis.com/v0/b/emart-dd54c.appspot.com/o/images%2Fvendors%2FuTANVVHKIbauK9FZCgztqBGXftN2%2Fscaled_images.jpg?alt=media&token=b5add2d2-086e-4bb2-b050-da2de9ed3818',
  //   ' ' 'https://firebasestorage.googleapis.com/v0/b/emart-dd54c.appspot.com/o/images%2Fvendors%2FuTANVVHKIbauK9FZCgztqBGXftN2%2Fscaled_download%20(1).jpg?alt=media&token=c56a1864-ff35-4af1-b824-f51aeedaafe6',
  //   'https://firebasestorage.googleapis.com/v0/b/emart-dd54c.appspot.com/o/images%2Fvendors%2FuTANVVHKIbauK9FZCgztqBGXftN2%2Fscaled_download.jpg?alt=media&token=9474826d-1876-4cba-8095-9ef8d115cd55'
  // ];

  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  var categoryvalue = ''.obs;
  var statusvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectColoIndex = 0.obs;

  //choosen category method
  getCategory() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }
  //method to remove method continue category

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  //pic image method

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //uploadImage method
  uploadImage() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        if (matchString(item.toString(), 'https://')) {
          pImagesLinks.add(item);
        } else {
          var filename = basename(item.path);
          var destination = 'images/vendors/${currentUser!.uid}/$filename';
          Reference ref = FirebaseStorage.instance.ref().child(destination);
          await ref.putFile(item);
          var n = await ref.getDownloadURL();
          pImagesLinks.add(n);
        }
      }
    }
  }

// upload products method

  uploadProduct(context) async {
    var store = firestore.collection(productsCollections).doc();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      //'p_colors': FieldValue.arrayUnion([Colors.red.value, Colors.brown.value]),
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
      'status': statusvalue.value,
    });
    isloading(false);
    VxToast.show(context, msg: "Product uploaded");
    cleartext();
  }

  // update product
  update_product(context, id) async {
    var store = firestore.collection(productsCollections).doc(id);

    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      //'p_colors': FieldValue.arrayUnion([Colors.red.value, Colors.brown.value]),
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
      'status': statusvalue.value,
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
    pImagesList = RxList<dynamic>.generate(3, (index) => null);
  }

//filter featured product

  addFeatured(docId) async {
    await firestore.collection(productsCollections).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollections).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  //Delete product method
  removeProduct(docId) async {
    await firestore.collection(productsCollections).doc(docId).delete();
  }
}
