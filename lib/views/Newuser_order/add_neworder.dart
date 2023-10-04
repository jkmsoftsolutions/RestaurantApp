import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/Newuser_order/select_table.dart';
import 'package:get/get.dart';
import '../../controllers/newuser_order_controller.dart';
import '../../theme/function.dart';
import '../widgets/loading_indicator.dart';
import 'commponents/customeinput.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  var controller = Get.put(NewUserOrderController());

  bool wait = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 219, 219),
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
          "New User Information here",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              StreamBuilder(
                  stream: StoreServices.getUserDetails(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LoadingIndicator(),
                      );
                    } else {
                      var userdata = snapshot.data!.docs;

                      return Column(
                        children: [
                          for (var i = 0; i < userdata.length; i++)
                            Row(children: [
                              Expanded(
                                  child: custominputField(
                                lable: "${userdata[i]["mobile"]}",
                              )),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: custominputField(
                                  lable: "${userdata[i]["name"]}",
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: custominputField(
                                  lable: "${userdata[i]["email"]}",
                                ),
                              )
                            ]),
                        ],
                      );
                    }
                  }),
              10.heightBox,
              // custominputField(
              //   lable:
              //       " Near Gandhi bazar in front of Sbi bank Pryagraj 212655",
              //   isDesc: true,
              // ),
              10.heightBox,
              10.heightBox,
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "Order Information list",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              10.heightBox,

              StreamBuilder(
                  stream: StoreServices.getUserOrders(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LoadingIndicator(),
                      );
                    } else {
                      var userorderdata = snapshot.data!.docs;
                      return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userorderdata.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 300),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                    userorderdata[index]['orders'][0]['img'],
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.cover),
                                10.heightBox,
                                "${capitalize(userorderdata[index]['orders'][0]['title'])}"
                                    .text
                                    .color(green)
                                    .make(),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    "₹ ${userorderdata[index]['total_amount'].toString()}"
                                        .text
                                        .color(green)
                                        .size(16)
                                        .make(),
                                    "Qty ${userorderdata[index]['orders'][0]['qty'].toString()}"
                                        .text
                                        .color(green)
                                        .size(16)
                                        .make(),
                                  ],
                                ),
                                10.heightBox,
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPice(
                                                int.parse('200'));
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(green)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse('6'));
                                            controller.calculateTotalPice(
                                                int.parse('1200'));
                                          },
                                          icon: const Icon(Icons.add)),
                                    ],
                                  )
                                      .box
                                      .green100
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .make(),
                                ),
                              ],
                            )
                                .box
                                .white
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .padding(const EdgeInsets.all(12))
                                .make()
                                .onTap(() {
                              // Get.to(() => ItemDetails(
                              //       title:
                              //           "${allproductsdata[index]['p_name']}",
                              //       data: allproductsdata[index],
                              //     ));
                            });
                          });
                    }
                  }),

              10.heightBox,
              const Divider(
                color: Colors.black,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    color: (white), borderRadius: BorderRadius.circular(5.0)),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "₹ 2000",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation:
                                  MaterialStateProperty.resolveWith<double?>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return 16;
                                return null;
                              }),
                            ),
                            onPressed: () {
                              Get.to(() => const SelectableScreen());
                            },
                            child: const Text('Procced'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
