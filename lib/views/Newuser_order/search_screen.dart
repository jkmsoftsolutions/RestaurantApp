import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get.dart';
import '../../services/store_services.dart';
import '../../theme/style.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/normal_text.dart';
import 'NewUser_widget.dart';

class SearchScreen extends StatefulWidget {
  final String? title;
  const SearchScreen({Key? key, this.title}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 169, 166, 169),
      appBar: AppBar(
        title: widget.title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: StoreServices.searchProducts(widget.title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No products found".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(widget.title!.toLowerCase()),
                  )
                  .toList();
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 220),
                  children: filtered
                      .mapIndexed(
                        (currentValue, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductCon(context, filtered[index]),
                          ],
                        )
                            .box
                            .white
                            .outerShadowMd
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          // Get.to(() => ItemDetails(
                          //       title: "${filtered[index]['p_name']}",
                          //       data: filtered[index],
                          //     ));
                        }),
                      )
                      .toList(),
                ),
              );
            }
          }),
    );
  }

  Widget ProductCon(BuildContext context, pdata) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: themeBox,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 8.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        pdata['p_imgs'][0],
                      ),
                      fit: BoxFit.fill),
                ),
              ),
              10.heightBox,
              GoogleText(
                  text: "${pdata['p_name']}",
                  color: darkFontGrey,
                  fsize: 12.0,
                  fweight: FontWeight.bold),
              10.heightBox,
              Row(
                children: [
                  GoogleText(
                      text: "₹ ${pdata['p_price']}",
                      color: redColor,
                      fsize: 15.0,
                      fweight: FontWeight.normal),
                  IncrDecre(context, pdata),
                ],
              ),
            ],
          ),
        ));
  }

  //increment
  Widget IncrDecre(BuildContext context, pdata) {
    var quantity = 1.obs;
    //print(controller.cartData);
    return Expanded(
      child: Container(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  await fnAddProductInCart(pdata, 'decr');
                  controller.TempValue["items_data"] =
                      await controller.cartData;
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 30,
                )),
            //quantity.value.text.size(16).bold.color(red).make(),

            // Text("${pdata["id"]}"),
            Text(
                '${(controller.cartData[pdata.id] != null) ? controller.cartData[pdata.id]['qnt'] : 0}'),
            IconButton(
                onPressed: () async {
                  await fnAddProductInCart(pdata, 'incr');
                  controller.TempValue["items_data"] =
                      await controller.cartData;
                  // //controller.increaseQuantity();
                  // setState(() {
                  //   quantity = quantity.value++ as RxInt;
                  //   print("$quantity ===");
                  //   controller.calculateTotalPice(int.parse('${price}'),
                  //       int.parse("${quantity.value.text}"));
                  // });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 30,
                )),
          ],
        ).box.white.margin(const EdgeInsets.symmetric(horizontal: 4)).make(),
      ),
    );
  }

  // add product in cart
  fnAddProductInCart(data, type) async {
    await controller.calculateTotal(data, type);

    setState(() {});
  }
}
