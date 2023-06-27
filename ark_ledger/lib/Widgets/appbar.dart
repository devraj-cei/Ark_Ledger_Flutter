import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyAppbar extends StatelessWidget with PreferredSizeWidget {
  final String? label;
  final Function()? suffixIconTap;
  final IconData? suffixIcon;
  final String? suffixLabel;
  final bool? suffixLabelVisibility;
  final Function()? suffixLabelTap;
  final Widget? widget;

  const MyAppbar(
      {Key? key,
      this.label,
      this.suffixIcon,
      this.suffixLabelTap,
      this.suffixLabel,
      this.suffixLabelVisibility,
      this.suffixIconTap,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      title: Text(label!.toUpperCase(),
          style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      leading: Builder(
        builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(CupertinoIcons.list_bullet)),
      ),
      actions: [
        Container(
            padding: EdgeInsets.only(right: 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(onTap: suffixIconTap, child: Icon(suffixIcon)),
                InkWell(
                  onTap: suffixLabelTap,
                  child: Visibility(
                    visible: suffixLabelVisibility ?? true,
                    child: Text(suffixLabel ?? "",
                        style: GoogleFonts.lato(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
