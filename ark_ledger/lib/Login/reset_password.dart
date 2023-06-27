import 'dart:convert';

import 'package:ark_ledger/Login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/Login Widgets/login_button.dart';
import '../Widgets/Login Widgets/login_input_field.dart';

class reset_password extends StatefulWidget {
  const reset_password({Key? key}) : super(key: key);

  @override
  State<reset_password> createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  //TextEditingController
  final mobileController = new TextEditingController();
  final otpController = new TextEditingController();
  final newPassController = new TextEditingController();
  final confirmPassController = new TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _toggleView1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggleView2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  //Forget password api
  Forget_Password_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {
      "otp": otpController.text.toString(),
      "mobile": mobileController.text.toString(),
      "password": confirmPassController.text.toString()
    };
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.FORGET_PASSWORD),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyParam));

    debugPrint("forget password bodyParam : ${bodyParam.toString()}");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseJSON = json.decode(response.body);
      var responseCode = responseJSON['response_code'];

      if (responseCode == "200") {
        debugPrint(responseJSON['obj']);
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const login()));
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
      Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  //Generate otp api
  Generate_Otp() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {
      "mobile": mobileController.text.toString()
    };
    debugPrint('bodyParam : $bodyParam');
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GENERATE_OTP),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyParam));
    print("generate otp bodyParam:${bodyParam.toString()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJSON = json.decode(response.body);
      var responseCode = responseJSON['response_code'];
      debugPrint(responseJSON.toString());
      if (responseCode == '200') {
        setState(() {
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: responseJSON['obj'], gravity: ToastGravity.BOTTOM);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //BackGround
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Container()),
              Container(
                height: 15.h,
                width: 12.h,
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  "assets/Images/hour_glass.png",
                  alignment: Alignment.bottomRight,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.h),
            alignment: Alignment.center,
            child: Column(
              children: [
                //Logo nd title
                SizedBox(
                  height: 32.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: Image(
                              image: const AssetImage(
                                  'assets/Images/ledger_logo.png'),
                              height: 13.h,
                              width: 9.h,
                              fit: BoxFit.fill)),
                      SizedBox(height: 1.h),
                      Text("Reset Password?",
                          style: GoogleFonts.quicksand(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        login_input_field(
                            inputType: TextInputType.number,
                            paddingBottom: 2.h,
                            controller: mobileController,
                            label: "Enter Mobile"),
                        login_input_field(
                            inputType: TextInputType.number,
                            paddingBottom: 2.h,
                            controller: otpController,
                            label: "Enter OTP"),
                        login_input_field(
                            paddingBottom: 2.h,
                            obSecureText: _obscureText1,
                            controller: newPassController,
                            label: "Enter New Password",
                            widget: InkWell(
                                onTap: _toggleView1,
                                child: Icon(
                                    _obscureText1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                    size: 2.5.h))),
                        login_input_field(
                            paddingBottom: 2.h,
                            obSecureText: _obscureText2,
                            controller: confirmPassController,
                            label: "Enter Confirm Password",
                            widget: InkWell(
                                onTap: _toggleView2,
                                child: Icon(
                                    _obscureText2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                    size: 2.5.h))),
                        SizedBox(height: 3.h),
                        //Generate OTP
                        login_button(
                            label: "RESET PASSWORD",
                            onTap: ()=>Forget_Password_API()),
                        SizedBox(height: 0.5.h),

                        //Resend otp
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't receive the OTP? ",
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 11.sp)),
                            InkWell(
                              onTap: () => Generate_Otp(),
                              child: Text("Resend OTP",
                                  style: GoogleFonts.quicksand(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.sp)),
                            ),
                          ],
                        )
                      ],
                    ),

                    //Powered by
                    Column(
                      children: [
                        Image.asset("assets/Images/novus_ark_logo.png",
                            height: 4.h, width: 4.h, fit: BoxFit.fill),
                        RichText(
                            text: TextSpan(
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                                children: [
                              const TextSpan(text: "Powered By "),
                              TextSpan(
                                  text: "NOVUS ARK",
                                  style: GoogleFonts.lato(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 9.sp)),
                            ]))
                      ],
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
