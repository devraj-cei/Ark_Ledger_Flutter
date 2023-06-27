import 'package:ark_ledger/Setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../drawer.dart';

class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer:  main_drawer(),
      appBar: MyAppbar(
        label: "About Us",
        suffixLabel: "BACK",
        suffixLabelTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>  setting()));
        },
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 2.h, right: 2.h, top: 10.h,bottom: 9.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/Images/novus_ark_logo.png",
                          height: 13.h, width: 13.h),
                      Text("Novus Ark",
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                        child: Text(
                            "The digital world keeps evolving continuously and to thrive in this space, "
                            "we keep ourselves updated with the latest skills. "
                            "This has not only helped us reach out to global clientele and has been a crucial "
                            "factor in driving our growth. We strive hard to ensure that we can deliver "
                            "the best to our clients and building our skillset is a major factor in it. "
                            "Take a look at some of our technical skills below.",
                            style: GoogleFonts.quicksand(color: Colors.black)),
                      ),
                      Text("WWW.novusark.com",
                          style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Developed By",
                          style: TextStyle(color: Colors.black)),
                      Image.asset("assets/Images/novus_ark_logo.png",
                          height: 3.h, width: 3.h),
                      Text("NOVUS ARK",
                          style: TextStyle(color: Colors.black, fontSize: 10.sp)),
                    ],
                  )
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
