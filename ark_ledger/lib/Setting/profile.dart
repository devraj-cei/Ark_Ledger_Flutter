import 'dart:convert';

import 'package:ark_ledger/Setting/profile%20edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../dashboard.dart';
import '../drawer.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  SharedPreferences? sharedPreferences;

  var obj, _profilePic, _uid, _name, _mobile, _email;

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
        (route) => false);
    return false;
  }

  GetProfile_API() async {
    try {
      EasyLoading.show(
          status: "Please Wait", maskType: EasyLoadingMaskType.black);
      sharedPreferences = await SharedPreferences.getInstance();
      String? token = sharedPreferences!.getString('token');

      Map<String, dynamic> bodyParam = {};

      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_PROFILE),
          headers: {"Content-Type": "application/json", "token": token!},
          body: jsonEncode(bodyParam));

      if (response.statusCode == 200) {
        var responseJSON = json.decode(response.body);
        var responseCode = responseJSON['response_code'];

        if (responseCode == "200") {
          EasyLoading.dismiss();
          obj = responseJSON['obj'];
          setState(() {
            debugPrint("Get Profile obj : $obj");
            _profilePic = obj['profilePic'];
            _uid = obj['appClientUId'];
            _name = obj['name'];
            _mobile = obj['mobile'];
            _email = obj['email'];
          });
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        debugPrint(response.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetProfile_API();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        drawer: main_drawer(),
        appBar: MyAppbar(
            label: "Profile",
            suffixIcon: Icons.edit,
            suffixIconTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => profile_edit(
                          uid: _uid,
                          name: _name,
                          mobile: _mobile,
                          email: _email,
                          image: _profilePic)));
            }),
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 5.h, left: 2.h, right: 2.h),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10.h,
                        backgroundImage: NetworkImage(
                                "http://arkledger.techregnum.com/assets/AppClientUsers/$_profilePic"),
                      ),
                      SizedBox(height: 3.h),

                      //UID
                      _padding(Icons.person_pin_outlined, "UID", _uid ?? ""),
                      const Divider(color: Colors.black),

                      //Name
                      _padding(Icons.person, "Name", _name ?? ""),
                      const Divider(color: Colors.black),

                      //Mobile
                      _padding(
                          Icons.phone_android_sharp, "Mobile", _mobile ?? ""),
                      const Divider(color: Colors.black),

                      //Email
                      _padding(Icons.email_sharp, "Email", _email ?? ""),
                      const Divider(color: Colors.black),
                    ],
                  ),
                ),
              ),

              //Bottom Navigation
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: MyBottomNavigation(selectedIndex: 4)),
            ],
          ),
        ),
      )),
    );
  }

  _padding(IconData icon, String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.quicksand(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              Text(subTitle, style: GoogleFonts.quicksand(color: Colors.black))
            ],
          )
        ],
      ),
    );
  }
}
