import 'package:ark_ledger/Credit/add%20credit.dart';
import 'package:ark_ledger/Widgets/appbar.dart';
import 'package:ark_ledger/Widgets/bottomNavigation.dart';
import 'package:ark_ledger/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  var ctime;

  int selectedIndex = 2;
  int badge = 0;

  //Double Back Pressed
  Future<bool> _onBackPressed() async {
    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime) > const Duration(seconds: 2)) {
      ctime = now;
      Fluttertoast.showToast(
          msg: "Press back button again to Exit",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      return Future.value(false);
    }

    return Future.value(true);
  }

  void _tabChanged(int index) {
    badge = badge + 1;
    setState(() {
      selectedIndex = index;
    });
    print("selected index:$selectedIndex");
    if(selectedIndex==0){
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>add_credit()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: main_drawer(),
        appBar: MyAppbar(label: "Dashboard"),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: MyBottomNavigation(
                selectedIndex: 2,
              )
            )
          ],
        ),
      ),
    );
  }
}
