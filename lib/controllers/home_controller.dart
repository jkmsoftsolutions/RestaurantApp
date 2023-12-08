import 'package:emart_seller/const/firebase_consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUsername();
  }

  var navIndex = 0.obs;

  var username = '';
  getUsername() async {
    //print(currentUser!.uid);
    var n = await firestore
        .collection(vendorsCollections)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var rData;
         for (var doc in value.docs) {
           rData =  doc.data();
         }
         return rData['vendor_name'];
        // print("================================");
        // print(value.docs);
        // //return value.docs.single['vendor_name'];
        // return ;
      }
    });
    username = n;
  }
}
