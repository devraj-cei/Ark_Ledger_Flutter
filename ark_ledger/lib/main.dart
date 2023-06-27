import 'dart:async';

import 'package:ark_ledger/Login/login.dart';
import 'package:ark_ledger/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MaterialApp(
        themeMode: ThemeMode.system,
        theme: MyTheme.lightTheme(context),
        darkTheme: MyTheme.darkTheme(context),
        title: 'Ark Ledger',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: splashScreen(),
      );
    });
  }
}

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      appBarTheme: const AppBarTheme(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black)),
      fontFamily: GoogleFonts.lato().fontFamily,
      primaryTextTheme: GoogleFonts.latoTextTheme(),
      primaryColor: AppThemeColor,
      buttonColor: ButtonColor,
      canvasColor: BorderColor,
      backgroundColor: Colors.grey.shade100);

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      appBarTheme: const AppBarTheme(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black)),
      fontFamily: GoogleFonts.lato().fontFamily,
      primaryTextTheme: GoogleFonts.latoTextTheme(),
      primaryColor: AppThemeColor,
      buttonColor: ButtonColor,
      canvasColor: BorderColor,
      backgroundColor: Colors.grey.shade100);

  static Color AppThemeColor = const Color(0xFFeac70d);
  static Color ButtonColor = const Color(0xFF5b4dbc);
  static Color BorderColor = Colors.grey;
}

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  bool animate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Check_Already_Login();
  }

  void Check_Already_Login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('password');
    debugPrint("splash Username & Password : $username + $password");
    if (username == null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const login()));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const dashboard()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Images/ledger_logo.png',
                fit: BoxFit.fill, height: 5.h, width: 5.h),
            SizedBox(width: 1.h),
            Text(
              "Ark Ledger",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)
            )
          ],
        ),
      ),
    );
  }
}
