import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final double? btnHeight;
  final EdgeInsetsGeometry? btnPadding;
  final double? fontSize;
  final Function()? onTap;

  const MyButton(
      {Key? key,
      this.label,
      this.btnHeight,
      this.btnPadding,
      this.onTap,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: btnHeight ?? 52,
          alignment: Alignment.center,
          padding: btnPadding ?? EdgeInsets.all(1.8.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: Colors.white, width: 2),
              color: Theme.of(context).primaryColor),
          child: Text(label!,
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize??11.sp))),
    );
  }
}
