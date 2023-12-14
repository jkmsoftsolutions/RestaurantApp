import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../const/const.dart';

class KProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;

  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;
  //create textfield
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //create shope detils controller
  var shopNameController = TextEditingController();
  var shopeMobileController = TextEditingController();
  var shopeDescController = TextEditingController();

  // It is mandatory initialize with one value from listType
  final selected = "some book type".obs;
  void setSelected(String value) {
    selected.value = value;
  }

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //create image  upload method
  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

// update user data
  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set(
        {'vendor_name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }
  // change authpassword user

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      // ignore: avoid_print
      print(error.toString());
    });
  }
}
