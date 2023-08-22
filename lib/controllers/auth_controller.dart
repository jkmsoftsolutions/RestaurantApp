import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/home_screen/home.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

//text Controller

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

//login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      route();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('type') == "Admin") {
          Get.to(
            () => const OrdersScreen(),
          );
        } else {
          Get.to(
            () => const Home(),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
