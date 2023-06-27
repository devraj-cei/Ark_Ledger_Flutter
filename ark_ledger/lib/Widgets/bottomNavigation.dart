import 'package:ark_ledger/Credit/add%20credit.dart';
import 'package:ark_ledger/Credit/credit_ledger_main_list.dart';
import 'package:ark_ledger/Customer/customer.dart';
import 'package:ark_ledger/Setting/profile.dart';
import 'package:ark_ledger/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';

class MyBottomNavigation extends StatelessWidget {
  final int? selectedIndex;

  const MyBottomNavigation({Key? key, this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;
    int badge = 0;

    void _tabChanged(int index) {
      badge = badge + 1;
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => add_credit()));
      } else if (_selectedIndex == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => customer()));
      } else if (_selectedIndex == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => dashboard()));
      } else if (_selectedIndex == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => credit_ledger_main_list()));
      } else if (_selectedIndex == 4) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => profile()));
      }
    }

    return Container(
      height: 8.h,
      decoration: BoxDecoration(
          border:
              Border.fromBorderSide(BorderSide(color: Colors.grey.shade200)),
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: GNav(
          gap: 5,
          tabBorderRadius: 25,
          iconSize: 3.h,
          textStyle: TextStyle(fontSize: 11.sp, color: Colors.black),
          tabBackgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          tabs: [
            GButton(icon: CupertinoIcons.creditcard, text: 'Add Credit'),
            GButton(icon: Icons.person_pin_outlined, text: 'Customer'),
            GButton(icon: CupertinoIcons.house_alt, text: 'Dashboard'),
            GButton(icon: CupertinoIcons.creditcard, text: 'Credit Ledger'),
            GButton(icon: CupertinoIcons.person, text: 'Profile'),
          ],
          selectedIndex: selectedIndex!,
          onTabChange: _tabChanged,
        ),
      ),
    );
  }
}
