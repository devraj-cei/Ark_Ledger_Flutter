import 'dart:convert';

import 'package:ark_ledger/Loader.dart';
import 'package:ark_ledger/Login/forgot%20password.dart';
import 'package:ark_ledger/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/Login Widgets/login_button.dart';
import '../Widgets/Login Widgets/login_input_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  SharedPreferences? sharedPreferences;

  //TextEditing Controller
  final TextEditingController emailController =
      TextEditingController(text: "gopi@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "gopi@1234");

  bool _obscureText = true;

  var username, password;

  void _toggleView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //Login Api
  void login_API() async {
    await EasyLoading.show(
        status: "please wait", maskType: EasyLoadingMaskType.black);

    username = emailController.text;
    password = passwordController.text;
    Map<String, dynamic> bodyParam = {
      'username': username,
      'password': password
    };

    try {
      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.LOGIN),
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyParam));

      debugPrint('Login bodyParam : $bodyParam');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJSON = jsonDecode(response.body);
        var responseCode = responseJSON["response_code"];
        debugPrint(responseJSON.toString());

        if (responseCode == "200") {
          String token = response.headers['token'].toString();
          debugPrint('token is $token');

          Fluttertoast.showToast(
              msg: "Login Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);

          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences!.setString('token', token);
          sharedPreferences!.setString('username', username);
          sharedPreferences!.setString('password', password);
          debugPrint('Login token is : $token');
          debugPrint('Login username is : $username + $password');

          setState(() {
            getProfile_API();
          });
        } else {
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: response.body,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        debugPrint('failed');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    }
  }

  //Get Profile api
  void getProfile_API() async {
    Map<String, dynamic> bodyParam = {};
    try {
      String? token = sharedPreferences!.getString('token');
      debugPrint("GetProfile token : $token");

      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_PROFILE),
          headers: {"Content-Type": "application/json", "token": token!},
          body: jsonEncode(bodyParam));

      if (response.statusCode == 200) {
        var responseJSON = json.decode(response.body);
        var responseCode = responseJSON['response_code'];

        if (responseCode == "200") {
          var obj = responseJSON['obj'];
          await sharedPreferences!.setString('obj', jsonEncode(obj));
          debugPrint("Get Profile obj : $obj");

          setState(() {
            EasyLoading.showSuccess("Login Successfully");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => dashboard()));
          });
        } else {
          EasyLoading.dismiss();
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
    method_loading();
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
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.sp),
                                children: [
                              TextSpan(
                                  text: "Ark",
                                  style: GoogleFonts.lato(color: Colors.white)),
                              TextSpan(
                                  text: " Ledger",
                                  style: GoogleFonts.lato(
                                      color: Theme.of(context).primaryColor)),
                            ]))
                      ],
                    ),
                  ),

                  //TextField
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Email
                          _text("Username"),
                          login_input_field(
                              controller: emailController,
                              paddingBottom: 1.h,
                              label: "Enter Email"),

                          SizedBox(height: 4.h),

                          //Password
                          _text('Password'),
                          login_input_field(
                              controller: passwordController,
                              paddingBottom: 1.h,
                              obSecureText: _obscureText,
                              label: "Enter Password",
                              widget: InkWell(
                                  onTap: _toggleView,
                                  child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColor,
                                      size: 2.5.h))),

                          SizedBox(height: 5.h),

                          //Login Button
                          login_button(
                              label: "LOGIN",
                              onTap: () {
                                login_API();
                                //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>dashboard()));
                              }),

                          //Forget password
                          Padding(
                            padding: EdgeInsets.only(top: 1.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  forgot_password(
                                                      username: emailController
                                                          .text
                                                          .toString())));
                                    },
                                    child: Text('Forgot Password ?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp)))
                              ],
                            ),
                          ),
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
              )),
        ],
      ),
    ));
  }

  Widget _text(String label) {
    return Text(label,
        style: GoogleFonts.lato(
            color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w500));
  }
}
