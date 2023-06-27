import 'package:ark_ledger/Setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../drawer.dart';

class help extends StatefulWidget {
  const help({Key? key}) : super(key: key);

  @override
  State<help> createState() => _helpState();
}

class _helpState extends State<help> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: MyAppbar(
        label: "Help",
        suffixLabel: "BACK",
        suffixLabelTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => setting()));
        },
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/Images/help.png", height: 13.h, width: 13.h),
                  SizedBox(height: 4.h),
                  Text("How can we help you?",
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp)),
                  SizedBox(height: 3.h),
                  CircleAvatar(
                      backgroundColor: Colors.yellow.shade100,
                      radius: 4.h,
                      child: const Icon(Icons.email_outlined, color: Colors.black)),
                  SizedBox(height: 2.h),
                  Text("Send us an email",
                      style: GoogleFonts.quicksand(color: Colors.grey)),
                  Text("info@nousark.com",
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                ],
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
    ));
  }
}
