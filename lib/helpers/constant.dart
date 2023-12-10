import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

String appName = "Flutter ChatGPT";
Color mainColor = Colors.amber;

nText(String text,
    {double? s,
    FontWeight? w,
    Color? clr,
    TextAlign? algn,
    TextDecoration? deco}) {
  return Text(
    text.toString(),
    textAlign: algn ?? TextAlign.start,
    style: GoogleFonts.montserrat(
        decoration: deco ?? TextDecoration.none,
        color: clr ?? Colors.black,
        fontWeight: w ?? FontWeight.normal,
        fontSize: s == null ? 15 : s),
  );
}

my_toast(String message, String type) {
  return Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: type == "error" ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0.sp);
}
