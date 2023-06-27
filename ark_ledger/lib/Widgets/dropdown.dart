import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyDropDown extends StatelessWidget {
  final String? label;
  final int? value;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? fontSize;
  final dynamic dynamicValue;
  final Function? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;

  const MyDropDown(
      {Key? key,
      this.label,
      this.padding,
      this.height,
        this.fontSize,
      this.onChanged,
      this.items,
      this.value,
      this.dynamicValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 2.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.white,
          isExpanded: true,
          style: const TextStyle(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          hint: Text(label!??"", style: TextStyle(color: Colors.black,fontSize: fontSize)),
          items: items,
          onChanged: onChanged!(),
          value: dynamicValue ?? value,
        ),
      ),
    );
  }
}
