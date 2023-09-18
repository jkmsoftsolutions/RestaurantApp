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

class CategoryController extends GetxController {
  var isloading = false.obs;

//text field controller

  var cNameController = TextEditingController();
  var cDescController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  var statusList = ['Active', 'InActive'];
  List<Category> category = [];
  var pImagesLinks = [];

  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  var categoryvalue = ''.obs;
  var statusvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectColoIndex = 0.obs;

  //choosen category method
  cat_getCategory() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }
  //method to remove method continue category

  cat_populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  cat_populateSubcategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  //pic image method

  cat_pickImage(index, context) async {
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

  cat_uploadProduct(context, {catId = ''}) async {
    var store = (catId == '')
        ? firestore.collection(categoryCollections).doc()
        : firestore.collection(categoryCollections).doc(catId);
    await store.set({
      'is_featured': false,
      'img': FieldValue.arrayUnion(pImagesLinks),
      'desc': cDescController.text,
      'name': cNameController.text,
      "sub_category": "",
      'vender': Get.find<HomeController>().username,
      'vendor_id': currentUser!.uid,
      'p_rating': "5.0",
      'status': statusvalue.value,
    });
    isloading(false);
    VxToast.show(context, msg: "Category uploaded");
    cleartext();
  }

  // clear controllers
  void cleartext() {
    //cNameController.clear();
    cDescController.clear();
    pImagesList = RxList<dynamic>.generate(3, (index) => null);
  }

  //Delete product method
  removeCategory(docId) async {
    await firestore.collection(categoryCollections).doc(docId).delete();
  }
}
