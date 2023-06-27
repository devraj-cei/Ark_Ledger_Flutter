import 'package:ark_ledger/Setting/about.dart';
import 'package:ark_ledger/Setting/change%20password.dart';
import 'package:ark_ledger/Setting/help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../dashboard.dart';
import '../drawer.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
        (route) => false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: main_drawer(),
          appBar: MyAppbar(label: "Settings"),
          body: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
                  child: Column(
                    children: [_chanePassword(), _help(), _aboutUs()],
                  ),
                ),
                //Bottom Navigation
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: MyBottomNavigation(
                        selectedIndex: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Change Password
  _chanePassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 4.h,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(CupertinoIcons.person_crop_circle_fill,
                      size: 4.h, color: Colors.black)),
              _text("Change Password")
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const change_password()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  height: 7.h,
                  width: 7.h,
                  color: Colors.grey.shade300,
                  child: const Icon(CupertinoIcons.forward)),
            ),
          )
        ],
      ),
    );
  }

  //Help
  _help() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 4.h,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(CupertinoIcons.question_circle_fill,
                      size: 4.h, color: Colors.black)),
              _text("Help")
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const help()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  height: 7.h,
                  width: 7.h,
                  color: Colors.grey.shade300,
                  child: const Icon(CupertinoIcons.forward)),
            ),
          )
        ],
      ),
    );
  }

  //About Us
  _aboutUs() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 4.h,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(CupertinoIcons.info_circle_fill,
                      size: 4.h, color: Colors.black)),
              _text("About Us")
            ],
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const about()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  height: 7.h,
                  width: 7.h,
                  color: Colors.grey.shade300,
                  child: const Icon(CupertinoIcons.forward)),
            ),
          )
        ],
      ),
    );
  }

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Text(label,
          style: GoogleFonts.quicksand(
              fontSize: 13.sp, fontWeight: FontWeight.bold)),
    );
  }
}
