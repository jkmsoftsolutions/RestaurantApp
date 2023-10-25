import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/Newuser_order/qrcode.dart';
import 'package:get/get.dart';
import '../../controllers/newuser_order_controller.dart';

class BildetailsScreen extends StatefulWidget {
  const BildetailsScreen({Key? key}) : super(key: key);

  @override
  State<BildetailsScreen> createState() => _BildetailsScreenState();
}

class _BildetailsScreenState extends State<BildetailsScreen> {
  var controller = Get.put(NewUserOrderController());

  bool wait = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 197, 194, 194),
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
          "Billing Information here",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      leading: Image.network(
                          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover),
                      title: "product name ".text.size(16).make(),
                      subtitle: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "700",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20.0),
                              Text('Quantity (X9)')
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Total price".text.color(green).make(),
                  "800".text.color(green).make(),
                ],
              )
                  .box
                  .padding(const EdgeInsets.all(12))
                  .color(lightGrey)
                  .width(context.screenWidth - 60)
                  .roundedSM
                  .make(),
              40.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Center(
                    child: QRCode(
                      qrSize: 100,
                      qrData: 'https://insaaf99.com/',
                    ),
                  ),
                  TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Fill Total Amount'),
                        content: Container(
                          width: 200,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your Amount',
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Submit'),
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text(
                      'Cash Pay',
                    ),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        elevation: 2,
                        backgroundColor: Colors.amber),
                  ),
                ],
              )
            ],
          ),
        ),
      ).box.white.make(),
    );
  }
}
