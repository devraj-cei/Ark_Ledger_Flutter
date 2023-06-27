import 'dart:convert';

import 'package:ark_ledger/Credit/add%20credit.dart';
import 'package:ark_ledger/Credit/credit_ledger_main_list.dart';
import 'package:ark_ledger/Customer/customer.dart';
import 'package:ark_ledger/Login/login.dart';
import 'package:ark_ledger/Offer/offers.dart';
import 'package:ark_ledger/Products/product.dart';
import 'package:ark_ledger/Setting/profile.dart';
import 'package:ark_ledger/Setting/setting.dart';
import 'package:ark_ledger/Widgets/alert_dialog.dart';
import 'package:ark_ledger/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'API/Api-End Point.dart';

class main_drawer extends StatefulWidget {
  const main_drawer({Key? key}) : super(key: key);

  @override
  State<main_drawer> createState() => _main_drawerState();
}

class _main_drawerState extends State<main_drawer> {
  SharedPreferences? sharedPreferences;

  String? _headerName, _headerEmail, _headerMobile, _headerImage;

  Get_SharedPreference_Data() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var obj = sharedPreferences!.getString('obj');
    var getProfileObj = jsonDecode(obj!);

    setState(() {
      _headerName = getProfileObj['name'];
      _headerMobile = getProfileObj['mobile'];
      _headerEmail = getProfileObj['email'];
      _headerImage = getProfileObj['profilePic'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_SharedPreference_Data();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildHeader(),
            SingleChildScrollView(
              child: Column(
                children: [
                  //Dashboard
                  ListTile(
                    leading: _navIcon(CupertinoIcons.house_alt),
                    title: _navText('Dashboard'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const dashboard()));
                    },
                  ),
                  //Add Credit
                  ListTile(
                    leading: _navIcon(CupertinoIcons.creditcard),
                    title: _navText('Add Credit'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const add_credit()));
                    },
                  ),
                  //Credit ledger
                  ListTile(
                    leading: _navIcon(CupertinoIcons.creditcard),
                    title: _navText('Credit Ledger'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const credit_ledger_main_list()));
                    },
                  ),
                  //Offers
                  ListTile(
                    leading: _navIcon(Icons.clean_hands_outlined),
                    title: _navText('Offers'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const offer()));
                    },
                  ),
                  //Customers
                  ListTile(
                    leading: _navIcon(Icons.person_pin_outlined),
                    title: _navText('Customers'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const customer()));
                    },
                  ),
                  //Products/Services
                  ListTile(
                    leading: _navIcon(Icons.production_quantity_limits_sharp),
                    title: _navText('Products/Services'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const product()));
                    },
                  ),
                  const Divider(thickness: 1),
                  //Profile
                  ListTile(
                    leading: _navIcon(CupertinoIcons.person),
                    title: _navText('My Profile'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const profile()));
                    },
                  ),
                  //Share to Business
                  ListTile(
                    leading: _navIcon(Icons.share),
                    title: _navText('Share to Business'),
                    onTap: () {},
                  ),
                  //Share to Customer
                  ListTile(
                    leading: _navIcon(Icons.share),
                    title: _navText('Share to Customer'),
                    onTap: () {},
                  ),
                  //Setting
                  ListTile(
                    leading: _navIcon(
                        CupertinoIcons.person_crop_circle_badge_exclam),
                    title: _navText('Setting'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const setting()));
                    },
                  ),
                  //Logout
                  ListTile(
                    leading: _navIcon(CupertinoIcons.power),
                    title: _navText('Logout'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return myAlertDialog(
                              content: "Are you sure you want to Logout?",
                              okLabel: "YES",
                              cancelLabel: "NO",
                              okTap: () {
                                sharedPreferences!.remove("username");
                                sharedPreferences!.remove("password");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => login()));
                              },
                            );
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Images/header_bg.png"),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      alignment: Alignment.center,
      height: 20.h,
      width: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: Colors.black,
            child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0XFFf5c151),
                backgroundImage: _headerImage == null
                    ? AssetImage("assets/Images/header_bg.png")
                    : NetworkImage(
                    "http://arkledger.techregnum.com/assets/AppClientUsers/${_headerImage}") as ImageProvider),
          ),
          SizedBox(width: 1.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_headerName ?? "",
                  style: GoogleFonts.quicksand(
                      fontSize: 11.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text(
                _headerMobile ?? "",
                style: GoogleFonts.quicksand(
                    fontSize: 10.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(_headerEmail ?? "",
                  style: GoogleFonts.quicksand(
                      fontSize: 10.sp, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  //drawer menu title
  Widget _navText(String text) {
    return Text(text,
        style: GoogleFonts.lato(
            color: Colors.black, fontSize: 11.sp, fontWeight: FontWeight.bold));
  }

  //drawer icon style
  Widget _navIcon(IconData icon) {
    return Icon(icon, color: Colors.black);
  }
}
