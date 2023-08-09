import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        title: boldText(text: shopSetting, size: 16.0),
        actions: [
          TextButton(onPressed: () {}, child: normalText(text: save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            customTextField(lable: shopname, hint: nameHint),
            10.heightBox,
            customTextField(lable: address, hint: shopAddressHint),
            10.heightBox,
            customTextField(lable: mobile, hint: shopMobileHint),
            10.heightBox,
            customTextField(lable: website, hint: shopWebsitecHint),
            10.heightBox,
            customTextField(
                isDesc: true, lable: description, hint: shopeDescHint),
          ],
        ),
      ),
    );
  }
}
