import 'dart:convert';

import 'package:ark_ledger/Login/login.dart';
import 'package:ark_ledger/Setting/setting.dart';
import 'package:ark_ledger/Widgets/button.dart';
import 'package:ark_ledger/Widgets/input-field.dart';
import 'package:flutter/cupertino.dart';
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
import '../drawer.dart';

class change_password extends StatefulWidget {
  const change_password({Key? key}) : super(key: key);

  @override
  State<change_password> createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  SharedPreferences? sharedPreferences;

  //TextEditingController
  final TextEditingController oldPassController =
      TextEditingController(text: "gopi@123");
  final TextEditingController newPassController =
      TextEditingController(text: "gopi@1234");
  final TextEditingController confirmPassController =
      TextEditingController(text: "gopi@234");

  bool _obscureOldPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  _toggleViewOldPass() {
    setState(() {
      _obscureOldPass = !_obscureOldPass;
    });
  }

  _toggleViewNewPass() {
    setState(() {
      _obscureNewPass = !_obscureNewPass;
    });
  }

  _toggleViewConfirmPass() {
    setState(() {
      _obscureConfirmPass = !_obscureConfirmPass;
    });
  }

  //Change password API
  changePasswordAPI() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    if (newPassController.text == confirmPassController.text) {
      sharedPreferences = await SharedPreferences.getInstance();
      String? token = sharedPreferences!.getString('token');

      Map<String, dynamic> bodyParam = {
        "oldPassword": oldPassController.text,
        "newPassword": newPassController.text,
      };

      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.CHANGE_PASSWORD),
          headers: {"Content-Type": "application/json", "token": token!},
          body: json.encode(bodyParam));
      debugPrint("Update Profile bodyParam: $bodyParam");

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var responseCode = responseBody['response_code'];
        debugPrint(responseBody.toString());

        if (responseCode == "200") {
          EasyLoading.dismiss();
          debugPrint("obj " + responseBody['obj']);

          setState(() {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const login()));
          });
        }
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Password Dosen't match",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: MyAppbar(
        label: "Chane Password",
        suffixLabel: "BACK",
        suffixLabelTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => setting()));
        },
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.black, size: 13.h),
                    SizedBox(height: 0.5.h),
                    Text("CHANGE PASSWORD",
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.5.h),
                    Text("Make sure you remember your password",
                        style: GoogleFonts.quicksand(
                            color: Colors.black, fontSize: 12.sp)),
                    _textFormField()
                  ],
                ),
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

  Widget _textFormField() {
    return Container(
      margin: EdgeInsets.only(top: 3.h),
      child: Column(
        children: [
          //Old pass
          MyInputField(
            paddingLeft: 0,
            marginBottom: 2.h,
            controller: oldPassController,
            obSecureText: _obscureOldPass,
            hint: "Enter Old Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            suffixIconWidget: InkWell(
                onTap: _toggleViewOldPass,
                child: Icon(
                    _obscureOldPass ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black)),
          ),

          //new pass
          MyInputField(
            paddingLeft: 0,
            marginBottom: 2.h,
            controller: newPassController,
            obSecureText: _obscureNewPass,
            hint: "Enter New Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            suffixIconWidget: InkWell(
                onTap: _toggleViewNewPass,
                child: Icon(
                    _obscureNewPass ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black)),
          ),

          //confirm pass
          MyInputField(
            paddingLeft: 0,
            marginBottom: 2.h,
            controller: confirmPassController,
            obSecureText: _obscureConfirmPass,
            hint: "Enter Confirm Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            suffixIconWidget: InkWell(
                onTap: _toggleViewConfirmPass,
                child: Icon(
                    _obscureConfirmPass
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black)),
          ),

          MyButton(label: "SAVE", onTap: () => changePasswordAPI())
        ],
      ),
    );
  }
}
