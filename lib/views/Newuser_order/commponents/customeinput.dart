import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/normal_text.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/style.dart';

Widget custominputField(
    {String? lable, String? hint, controller, isDesc = false}) {
  return SizedBox(
    child: TextFormField(
      style: GoogleFonts.alike(
          color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13),
      controller: controller,
      enabled: false,
      maxLines: isDesc ? 4 : 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        isDense: true,
        label: ControllerText(text: lable),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hint,
      ),
    ),
  );
}

// form input field ===========================
Widget formInput(BuildContext context, label, controller, icon,
    {padding = 5.0,
    suggationList,
    editComplete = '',
    focusNode = '',
    currentController = '',
    isNumber = false,
    isFloat = false,
    method = '',
    methodArg = '',
    readOnly = false}) {
  // if (editComplete != '' && currentController.text == '') {
  //   controller.text = currentController.text;
  // }
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      child: (editComplete == '')
          ? TextFormField(
              controller: controller,
              style: textStyle1,
              decoration: inputStyle(label, icon),
              keyboardType:
                  (isNumber) ? TextInputType.number : TextInputType.text,
              readOnly: readOnly,
              inputFormatters: (isNumber && isFloat)
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*'))
                    ]
                  : (isNumber)
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]
                      : <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
              onChanged: (value) {
                if (method != '') {
                  if (methodArg != '') {
                    method(methodArg);
                  } else {
                    method();
                  }
                }
              },
            )
          : TextFormField(
              keyboardType:
                  (label == "Meeting Conversation" || label == "Next Follow Up")
                      ? TextInputType.multiline
                      : TextInputType.text,
              // this is for auto complete
              controller: controller,
              style: textStyle1,
              onEditingComplete: editComplete,
              focusNode: focusNode,

              decoration: inputStyle(label, icon),

              onChanged: (value) {
                currentController.text = value;
              },
            ));
}
