// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/newuser_order_controller.dart';
import '../../services/store_services.dart';
import '../widgets/loading_indicator.dart';
import 'billing_details.dart';

class SelectableScreen extends StatefulWidget {
  const SelectableScreen({Key? key}) : super(key: key);

  @override
  State<SelectableScreen> createState() => _SelectableScreenState();
}

class _SelectableScreenState extends State<SelectableScreen> {
  var controller = Get.put(NewUserOrderController());

  bool wait = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 219, 219),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Select Table ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              StreamBuilder(
                  stream: StoreServices.allTables(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingIndicator();
                    } else {
                      var alltablesdata = snapshot.data!.docs;

                      //  print('${alltablesdata.length}---------');
                      return Obx(
                        () => Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(
                            alltablesdata.length,
                            (index) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (alltablesdata[index]['is_active']) {
                                      await controller.changeTableIndex(index);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'tableid', alltablesdata[index].id);
                                    } else {
                                      VxToast.show(context,
                                          msg: "Already Booked");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (controller.selectedtableIndex ==
                                                    index &&
                                                alltablesdata[index]
                                                    ['is_active'])
                                            ? Colors.green
                                            : (alltablesdata[index]
                                                    ['is_active'])
                                                ? Colors.transparent
                                                : Color.fromARGB(
                                                    255, 159, 28, 8),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 45, 177, 115),
                                            width: 1.0)),
                                    child: Text(
                                      'Table ${alltablesdata[index]['is_active'] ? '${alltablesdata[index]['tab_no']}' : 'Booked'}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
              40.heightBox,
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) return 16;
                    return null;
                  }),
                ),
                onPressed: () {
                  Get.to(() => const BildetailsScreen());
                },
                child: const Text('Booked'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
