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
import '../theme/firebase_functions.dart';

class SubCategoryController extends GetxController {
  var isloading = false.obs;

//text field controller

  var cNameController = TextEditingController();
  var cDescController = TextEditingController();

  var statusList = ['Active', 'InActive'];
  List<Category> category = [];
  var pImagesLinks = [];

  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var statusvalue = ''.obs;
  var catsvalue = ''.obs;

  //pic image method

  sub_cat_pickImage(index, context) async {
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

          print("$pImagesLinks   ++++++++++hh");
        }
      }
    }
  }

// upload products method

  Sub_cat_uploadProduct(context, cate_sub, {catId = ''}) async {
    print("$cate_sub   ++++++++");
    var store = (catId == '')
        ? firestore.collection(categoryCollections).doc()
        : firestore.collection(categoryCollections).doc(catId);
    var w = {
      'is_featured': false,
      'img': pImagesLinks,
      'desc': cDescController.text,
      'name': cNameController.text,
      'vender': Get.find<HomeController>().username,
      'vendor_id': currentUser!.uid,
      'p_rating': "5.0",
      'status': statusvalue.value,
    };
    // print("$w  +++  V+Ff++++=");
    List<dynamic> listt = cate_sub;
    listt.add(w);
    print("$listt  ++++++++++++");
    if (listt.isNotEmpty) {
      await store.update({
        "sub_category": listt //cate_sub.add(w)
        // 'img': FieldValue.arrayUnion(pImagesLinks),
      });
    } else {
      await store.update({
        "sub_category": [w] //cate_sub.add(w)
        // 'img': FieldValue.arrayUnion(pImagesLinks),
      });
    }

    isloading(false);
    VxToast.show(context, msg: "Sub Category uploaded");
    cleartext();
  }

  // clear controllers
  void cleartext() {
    //cNameController.clear();
    cDescController.clear();
    pImagesList = RxList<dynamic>.generate(3, (index) => null);
  }

  //Delete product method
  removeProduct(docId) async {
    await firestore.collection(categoryCollections).doc(docId).delete();
  }
}
