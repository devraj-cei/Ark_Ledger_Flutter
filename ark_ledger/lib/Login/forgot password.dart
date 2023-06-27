import 'dart:convert';

import 'package:ark_ledger/Login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../API/Api-End Point.dart';
import '../Widgets/Login Widgets/login_button.dart';
import '../Widgets/Login Widgets/login_input_field.dart';

class forgot_password extends StatefulWidget {
  final String? username;

  const forgot_password({Key? key, this.username}) : super(key: key);

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  //TextEditing Controller
  TextEditingController? numberController;

  //Generate otp API
  Generate_Otp() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {
      "mobile": numberController!.text.toString()
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => reset_password()));
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberController = TextEditingController(text: widget.username);
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
                      Text("Forgot Password?",
                          style: GoogleFonts.quicksand(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 1.h),
                      Text("Enter the mobile associated with your account",
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontSize: 12.sp))
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        login_input_field(
                            controller: numberController!,
                            paddingBottom: 1.h,
                            label: "Enter Number"),
                        SizedBox(height: 5.h),
                        //Generate OTP
                        login_button(
                            label: "GENERATE OTP",
                            onTap: () {
                              Generate_Otp();
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>reset_password()));
                            }),
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
