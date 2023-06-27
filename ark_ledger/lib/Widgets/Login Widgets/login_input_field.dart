import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class login_input_field extends StatelessWidget {
  final String? label;
  final IconData? suffixIcon;
  final Function()? onTap;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Widget? widget;
  final bool? obSecureText;
  final double? paddingBottom;

  const login_input_field(
      {Key? key,
      this.label,
      this.suffixIcon,
      this.controller,
      this.onTap,
      this.widget,
      this.inputType,
        this.paddingBottom,
      this.obSecureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.only(bottom: paddingBottom??0),
      child: TextFormField(
        obscureText: obSecureText!,
        controller: controller,
        keyboardType: inputType,
        style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor, fontSize: 11.sp),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.lato(color: Colors.white),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.white)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.white)),
        suffixIcon: widget),
      ),
    );
  }
}
