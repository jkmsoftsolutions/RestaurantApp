import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:get/get.dart';
import '../../controllers/table_controller.dart';

// ignore: prefer_typing_uninitialized_variables

// ignore: must_be_immutable
class TableEdit extends StatefulWidget {
  final dynamic data;
  final dynamic tableId;
  const TableEdit({super.key, this.data, this.tableId});

  @override
  State<TableEdit> createState() => _TableEditState();
}

class _TableEditState extends State<TableEdit> {
  //final List<String> _listNotifier = <String>["Floor1", "Floor2", "Floor3"];
  final List<String> _listSatus = <String>["Active", "InActive"];
  var controller = Get.find<TablesController>();

  @override
  void initState() {
    if (widget.data != null) {
      controller.tnameController.text = widget.data['tab_no'];
      controller.tdescController.text = widget.data['t_desc'];
      controller.tadminController.text = widget.data['t_admin'];
      controller.currentStatusValue = widget.data['status'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      await controller.uploadTable(context, id: widget.tableId);

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
                customTextField(
                    hint: "eg. Table 101",
                    lable: "Table name",
                    controller: controller.tnameController),
                10.heightBox,
                customTextField(
                    hint: "eg. side corner view point",
                    lable: "Label",
                    isDesc: true,
                    controller: controller.tdescController),
                10.heightBox,
                // Status =================
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
                            hint: const Text("Status"),
                            value: controller.currentStatusValue,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                controller.currentStatusValue = newValue;
                              });

                              // print(currentSelectedValue);
                            },
                            items: tableStatusList.map((String value) {
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
                    hint: "eg. 21",
                    lable: "Admin Notes",
                    isDesc: true,
                    controller: controller.tadminController),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
