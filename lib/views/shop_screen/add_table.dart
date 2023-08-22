import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';
import '../../controllers/table_controller.dart';

// ignore: prefer_typing_uninitialized_variables

// ignore: must_be_immutable
class AddTable extends StatefulWidget {
  const AddTable({super.key});

  @override
  State<AddTable> createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  final List<String> _listNotifier = <String>["Floor1", "Floor2", "Floor3"];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TablesController>();

    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: boldText(text: "Add Table", size: 16.0),
          actions: [
            controller.isloading.value
                ? LoadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      // ignore: use_build_context_synchronously
                      await controller.uploadProduct(context);

                      Get.back();
                    },
                    child: boldText(
                      text: save,
                    ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.heightBox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select Floor"),
                            value: controller.currentSelectedValue,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                controller.currentSelectedValue = newValue;
                              });

                              // print(currentSelectedValue);
                            },
                            items: _listNotifier.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                10.heightBox,
                customTextField(
                    hint: "eg. Table 101",
                    lable: "Table name",
                    controller: controller.tnameController),
                10.heightBox,
                customTextField(
                    hint: "eg. side corner view point",
                    lable: "Descripttion",
                    isDesc: true,
                    controller: controller.tdescController),
                10.heightBox,
                customTextField(
                    hint: "eg. 21",
                    lable: "Admin tab",
                    controller: controller.tadminController),
                10.heightBox,
                const Divider(
                  color: white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
