import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyInputField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyBoardType;
  final bool? obSecureText;
  final bool? readOnly;
  final String? title;
  final String? hint;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? marginBottom;
  final double? paddingLeft;
  final Widget? prefixIcon;
  final Widget? widget;
  final Widget? suffixIconWidget;
  final Color? color;

  const MyInputField(
      {Key? key,
      this.controller,
      this.keyBoardType,
      this.obSecureText,
      this.readOnly,
      this.title,
      this.hint,
      this.maxLines,
      this.minLines,
      this.height,
      this.marginBottom,
      this.paddingLeft,
      this.prefixIcon,
      this.widget,
      this.suffixIconWidget,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: marginBottom ?? 0),
            padding: EdgeInsets.only(left: paddingLeft ?? 0.h),
            height: height ?? 50,
            /* decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10)),*/
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    obscureText: obSecureText ?? false,
                    keyboardType: keyBoardType,
                    maxLines: maxLines ?? 1,
                    readOnly: readOnly == null ? false : true,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        fillColor: color ?? Colors.white,
                        filled: color != null ? true : false,
                        hintText: hint,
                        contentPadding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.h),
                        hintStyle: GoogleFonts.lato(
                            color: Colors.grey, fontSize: 11.sp),
                       // label: Text(title??""),
                        labelStyle: GoogleFonts.lato(color: Colors.black,fontSize: 9.5.sp),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1)),
                        prefixIcon: prefixIcon,
                        prefixIconColor: Colors.grey,
                        suffixIcon: suffixIconWidget),
                  ),
                ),
                widget == null ? Container() : Container(child: widget)
              ],
            )),
      ],
    );
  }
}
