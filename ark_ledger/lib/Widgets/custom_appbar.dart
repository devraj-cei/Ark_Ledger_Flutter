import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class custom_appbar extends StatelessWidget {
  final String? label;
  final String? centerlabel;
  final Function()? drawerIconTap;
  final Widget? widget;

  const custom_appbar(
      {Key? key, this.label, this.centerlabel, this.drawerIconTap, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appbarHeight = 9.h;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.5.h),
        decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            color: Colors.black),
        width: MediaQuery.of(context).size.width,
        height: appbarHeight,
        child: Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        drawerIconTap!();
                      },
                      child: Icon(CupertinoIcons.list_bullet, color: Colors.white)),
                  SizedBox(width: 2.h),
                  Text(label ?? "",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  Text(centerlabel?? "", style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget ?? Container()],
              )
            ],
          ),
        ));
  }
}
