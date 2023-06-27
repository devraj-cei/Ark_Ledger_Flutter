import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class login_button extends StatelessWidget {
  final String? label;
  final Function()? onTap;
  const login_button({Key? key,this.label,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(1.8.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              border: Border.all(
                  color: Colors.white, width: 2),
              color: Theme.of(context).primaryColor),
          child: Text(label!,
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp))),
    );
  }
}
