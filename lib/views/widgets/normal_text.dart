import 'package:emart_seller/const/const.dart';
import 'package:google_fonts/google_fonts.dart';

Widget normalText({text, color = Colors.white, size = 14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText({text, color = Colors.white, size = 14.0}) {
  return "$text".text.semiBold.color(color).size(size).make();
}

Widget ControllerText({text, color = Colors.white, size = 12.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget GoogleText(
    {text: "",
    color: Colors.black,
    fsize: 15.0,
    fweight: FontWeight.normal,
    fstyle: FontStyle.normal}) {
  return Text("$text",
      style: GoogleFonts.alike(
          color: color,
          fontSize: fsize,
          fontWeight: fweight,
          fontStyle: fstyle));
}
